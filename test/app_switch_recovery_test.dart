import 'dart:async';

import 'package:dudo/salon/network_salon_session.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'salon_test_helpers.dart';

/// Regression tests for the app-switch resume bug (beta.33 feedback):
/// switching away and coming back left a failure loop in the thread.
/// Two real-world causes, both locked down here:
///   D — a peer that never ACKs (dead radio mid-handshake) used to hold
///       the awaited close forever, wedging the recovery machinery
///       ("_recovering" stuck true, no retry ever again);
///   E — the failure feed deduped on EXACT text, but the raw error inside
///       the line varies, so the same story spammed the thread.
///
/// Real Android lifecycle order:
///   away:  inactive → hidden → paused
///   back:  paused → hidden → inactive → resumed
const _players = <Map<String, dynamic>>[
  {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
];

/// A channel whose TCP died mid-flight: `ready` hangs (upgrade never
/// answers) AND `sink.close()` hangs forever AND the stream NEVER fires
/// onDone — exactly what a real dart:io WebSocket does against a peer
/// that will never ACK.
class DeadSocketChannel extends StreamChannelMixin implements WebSocketChannel {
  DeadSocketChannel(this.uri)
    : ready = Completer<void>().future, // never completes
      _incoming = StreamController<dynamic>(); // never closes, never emits

  final Uri uri;
  final List<String> sent = <String>[];
  final StreamController<dynamic> _incoming;

  @override
  final Future<void> ready;

  @override
  Stream<dynamic> get stream => _incoming.stream;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;

  @override
  String? get protocol => null;

  @override
  WebSocketSink get sink => _HangingSink(this);
}

class _HangingSink implements WebSocketSink {
  _HangingSink(this.channel);

  final DeadSocketChannel channel;

  @override
  void add(Object? event) => channel.sent.add('$event');

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<void> addStream(Stream<dynamic> stream) async {}

  @override
  Future close([int? closeCode, String? closeReason]) =>
      Completer<void>().future; // hangs forever: no ACK will ever come

  @override
  Future<void> get done => Completer<void>().future;
}

void _switchAway(NetworkSalonSession session) {
  session.didChangeAppLifecycleState(AppLifecycleState.inactive);
  session.didChangeAppLifecycleState(AppLifecycleState.hidden);
  session.didChangeAppLifecycleState(AppLifecycleState.paused);
}

void _switchBack(NetworkSalonSession session) {
  session.didChangeAppLifecycleState(AppLifecycleState.hidden);
  session.didChangeAppLifecycleState(AppLifecycleState.inactive);
  session.didChangeAppLifecycleState(AppLifecycleState.resumed);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('D: un close qui ne revient jamais n\u2019enfouit pas la machine à reprendre', () async {
    final created = <FakeWebSocketChannel>[];
    var deadDials = 0;
    final session = NetworkSalonSession(
      handshakeTimeout: const Duration(milliseconds: 40),
      reconnectDelay: const Duration(milliseconds: 20),
      createSalonCode: (_, _) async => 'S99FTH',
      channelFactory: (uri) {
        // Dials 1..3 after creation hit a radio that answers nothing
        // (hangs the close). Dial 4+: the network came back.
        if (created.isNotEmpty && deadDials < 3) {
          deadDials++;
          return DeadSocketChannel(uri);
        }
        final channel = FakeWebSocketChannel.confirmed(uri);
        created.add(channel);
        return channel;
      },
    );

    final creating = session.createSalon('Cap Hôte', 0);
    await settle();
    final first = created.first;
    await untilOneSent(first);
    first.serverSends(<String, dynamic>{
      'type': 'salon',
      'salon': <String, dynamic>{
        'code': 'S99FTH',
        'started': false,
        'hostSeat': 0,
        'players': _players,
        'you': 0,
      },
    });
    await creating;
    expect(session.connected, isTrue);

    // Away, the socket dies silently (no close event), back.
    _switchAway(session);
    await first.serverCloses();
    await settle();
    _switchBack(session);

    // The dead dials must NOT wedge the machinery: dial 4 (the network
    // is back) must still happen and connect.
    final want = created.length + 1;
    for (var tick = 0; tick < 400 && created.length < want; tick++) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(
      created.length,
      greaterThanOrEqualTo(want),
      reason: 'la reprise doit retenter malgré les closes morts',
    );
    final live = created.last;
    await untilOneSent(live);
    live.serverSends(<String, dynamic>{
      'type': 'salon',
      'salon': <String, dynamic>{
        'code': 'S99FTH',
        'started': false,
        'hostSeat': 0,
        'players': _players,
        'you': 0,
      },
    });
    await settle(6);
    expect(session.connected, isTrue, reason: 'le salon doit revenir');
    session.dispose();
  }, timeout: const Timeout(Duration(seconds: 30)));

  test(
    'E: les échecs de reprise ne spamment pas le fil (texte variable)',
    () async {
      final created = <FakeWebSocketChannel>[];
      final session = NetworkSalonSession(
        handshakeTimeout: const Duration(milliseconds: 40),
        reconnectDelay: const Duration(milliseconds: 20),
        createSalonCode: (_, _) async => 'S99FTH',
        channelFactory: (uri) {
          // The creation dial works; every recovery dial fails.
          if (created.isNotEmpty) {
            return FakeWebSocketChannel.unreachable(uri);
          }
          final channel = FakeWebSocketChannel.confirmed(uri);
          created.add(channel);
          return channel;
        },
      );

      final creating = session.createSalon('Cap Hôte', 0);
      await settle();
      final first = created.first;
      await untilOneSent(first);
      first.serverSends(<String, dynamic>{
        'type': 'salon',
        'salon': <String, dynamic>{
          'code': 'S99FTH',
          'started': false,
          'hostSeat': 0,
          'players': _players,
          'you': 0,
        },
      });
      await creating;

      // The relay drops us; recovery dials keep failing with DIFFERENT
      // raw errors (DNS, then refused, then timeout) — what a real phone
      // shows while its radio settles. The thread must stay readable:
      // one line per failure KIND, not one per distinct error text.
      await first.serverCloses();
      for (var tick = 0; tick < 60; tick++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      final spam = session.messages
          .map((message) => message.body)
          .where(
            (body) =>
                body.contains('reste inaccessible') ||
                body.contains('Impossible de joindre'),
          )
          .toList();
      expect(
        spam,
        hasLength(lessThanOrEqualTo(1)),
        reason:
            'un même motif d\u2019échec ne se répète pas minute après minute',
      );
      // The thread must read like a tavern, not a stack trace: no
      // exception class names, no OS error dumps — those stay in adb.
      for (final message in session.messages) {
        expect(
          message.body,
          isNot(contains('Exception')),
          reason: 'erreur technique dans le fil : ${message.body}',
        );
        expect(
          message.body,
          isNot(contains('OS Error')),
          reason: 'détail OS dans le fil : ${message.body}',
        );
      }
      session.dispose();
    },
  );

  test(
    'F: taverne fermée par le serveur — le réveil ne relance rien',
    () async {
      final created = <FakeWebSocketChannel>[];
      final session = NetworkSalonSession(
        handshakeTimeout: const Duration(milliseconds: 40),
        reconnectDelay: const Duration(milliseconds: 20),
        createSalonCode: (_, _) async => 'S99FTH',
        channelFactory: (uri) {
          final channel = FakeWebSocketChannel.confirmed(uri);
          created.add(channel);
          return channel;
        },
      );

      final creating = session.createSalon('Cap Hôte', 0);
      await settle();
      final first = created.first;
      await untilOneSent(first);
      first.serverSends(<String, dynamic>{
        'type': 'salon',
        'salon': <String, dynamic>{
          'code': 'S99FTH',
          'started': false,
          'hostSeat': 0,
          'players': _players,
          'you': 0,
        },
      });
      await creating;

      // The host quits: the Worker closes the salon for everyone. This is a
      // TERMINAL state — the thread says so once and the session is done.
      first.serverSends(<String, dynamic>{
        'type': 'closed',
        'reason': 'L\u2019hôte a quitté la taverne.',
      });
      await settle();
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(session.connected, isFalse);

      // Lock, unlock: nothing may dial, nothing may speak. The salon is
      // gone; "reconnexion au salon" would be a lie, and dialing a dead
      // salon only farms "Connexion interrompue" lines.
      final threadBefore = session.messages.map((m) => m.body).toList();
      _switchAway(session);
      _switchBack(session);
      for (var tick = 0; tick < 80; tick++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }

      expect(
        created,
        hasLength(1),
        reason: 'aucune reprise sur une taverne morte',
      );
      expect(
        session.messages.map((m) => m.body).toList(),
        threadBefore,
        reason: 'le réveil ne doit rien dire ni relancer',
      );
      session.dispose();
    },
  );

  test('G: un timer de reprise en retard ne tue pas le salon frais', () async {
    final created = <FakeWebSocketChannel>[];
    var doorOpen = false;
    final session = NetworkSalonSession(
      handshakeTimeout: const Duration(milliseconds: 40),
      reconnectDelay: const Duration(milliseconds: 20),
      createSalonCode: (_, _) async => 'S99FTH',
      channelFactory: (uri) {
        // Closed door: every dial hangs (unreachable). Open door: the
        // dial works. This lets the test script the outage, then the
        // fresh creation.
        if (!doorOpen) {
          return FakeWebSocketChannel.unreachable(uri);
        }
        final channel = FakeWebSocketChannel.confirmed(uri);
        created.add(channel);
        return channel;
      },
    );

    // A salon lives, then dies: the recovery machinery arms itself with a
    // growing backoff (1.2s, 2.4s… in production) — those pending timers
    // firing into a FRESH salon were the ~6-9 s salon killer seen live on
    // BL8QD4 / 9CXR7P / CRPLJ5 (host socket closed seconds after a good
    // join, lobby torn down, failure loop).
    doorOpen = true;
    final joining = session.joinSalon('S99FTH', 'Invité');
    await settle();
    final first = created.first;
    await untilOneSent(first);
    first.serverSends(<String, dynamic>{
      'type': 'salon',
      'salon': <String, dynamic>{
        'code': 'S99FTH',
        'started': false,
        'hostSeat': 0,
        'players': _players,
        'you': 0,
      },
    });
    await joining;

    doorOpen = false;
    await first.serverCloses();
    for (var tick = 0; tick < 15; tick++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    final dialsBefore = created.length;

    // A fresh table is created while recovery timers are still pending.
    doorOpen = true;
    final creating = session.createSalon('Cap Hôte', 0);
    await settle();
    final fresh = created.last;
    await untilOneSent(fresh);
    fresh.serverSends(<String, dynamic>{
      'type': 'salon',
      'salon': <String, dynamic>{
        'code': 'S99FTH',
        'started': false,
        'hostSeat': 0,
        'players': _players,
        'you': 0,
      },
    });
    await creating;
    expect(session.connected, isTrue);

    // Whatever timers the outage armed, they must NOT fire into the new
    // salon: no parasite dial, the connection stays up.
    for (var tick = 0; tick < 80; tick++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    expect(
      created,
      hasLength(dialsBefore + 1),
      reason: 'aucun dial parasite après la création du salon frais',
    );
    expect(
      session.connected,
      isTrue,
      reason: 'le salon frais doit rester vivant malgré les timers en retard',
    );
    session.dispose();
  });

  test('H: siège repris sur un autre appareil — état terminal', () async {
    final created = <FakeWebSocketChannel>[];
    final session = NetworkSalonSession(
      handshakeTimeout: const Duration(milliseconds: 40),
      reconnectDelay: const Duration(milliseconds: 20),
      createSalonCode: (_, _) async => 'S99FTH',
      channelFactory: (uri) {
        final channel = FakeWebSocketChannel.confirmed(uri);
        created.add(channel);
        return channel;
      },
    );

    final creating = session.createSalon('Cap Hôte', 0);
    await settle();
    final first = created.first;
    await untilOneSent(first);
    first.serverSends(<String, dynamic>{
      'type': 'salon',
      'salon': <String, dynamic>{
        'code': 'S99FTH',
        'started': true,
        'hostSeat': 0,
        'players': _players,
        'you': 0,
      },
    });
    await creating;

    // Another phone with the same name reclaims the seat: the Worker
    // closes THIS socket with a distinctive reason. Dialing back would
    // trade the host engine forever (two parallel games, salon 9VP2FY).
    await first.serverCloses(
      code: 1000,
      reason: 'Siège repris sur un autre téléphone',
    );
    for (var tick = 0; tick < 60; tick++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }

    expect(created, hasLength(1), reason: 'aucun dial de revanche');
    expect(
      session.messages.map((m) => m.body),
      contains(contains('repris sur un autre appareil')),
      reason: 'le fil explique le transfert de siège',
    );
    // Lock and unlock: still terminal, nothing dials.
    _switchAway(session);
    _switchBack(session);
    for (var tick = 0; tick < 40; tick++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    expect(created, hasLength(1), reason: 'le réveil ne relance rien non plus');
    session.dispose();
  });

  test('I: refus siège encore tenu — la reprise continue', () async {
    final created = <FakeWebSocketChannel>[];
    final session = NetworkSalonSession(
      // Wide handshake window: this test pins the REFUSAL path (the
      // server answers with an error frame, then closes), so the error
      // must always beat the timeout — a 40 ms timeout flakes on a slow
      // test runner and turns the refusal into a plain outage.
      handshakeTimeout: const Duration(seconds: 2),
      reconnectDelay: const Duration(milliseconds: 20),
      createSalonCode: (_, _) async => 'S99FTH',
      channelFactory: (uri) {
        final channel = FakeWebSocketChannel.confirmed(uri);
        created.add(channel);
        return channel;
      },
    );

    final creating = session.createSalon('Cap Hôte', 0);
    await settle();
    final first = created.first;
    await untilOneSent(first);
    first.serverSends(<String, dynamic>{
      'type': 'salon',
      'salon': <String, dynamic>{
        'code': 'S99FTH',
        'started': true,
        'hostSeat': 0,
        'players': _players,
        'you': 0,
      },
    });
    await creating;

    // Plain transport drop: recovery arms itself.
    await first.serverCloses(code: 1006);
    for (var tick = 0; tick < 300 && created.length < 2; tick++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    final second = created[1];
    await untilOneSent(second);
    // The Worker refuses the reclaim: the seat's owner is still connected
    // (alive = answered the last heartbeat ping). The seat frees within a
    // heartbeat, so the session must NOT stand down — pre-fix, any
    // refusal set _closedByServer and the recovery died here.
    second.serverSends(<String, dynamic>{
      'type': 'error',
      'message':
          'Ce nom est déjà pris : le siège est encore tenu par un téléphone '
          'connecté. Réessaie dans un instant ou change de nom.',
    });
    await second.serverCloses(code: 1008, reason: 'Siège encore tenu');

    for (var tick = 0; tick < 300 && created.length < 3; tick++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    expect(
      created,
      hasLength(3),
      reason: 'le refus "siège encore tenu" reste retryable',
    );
    final third = created[2];
    await untilOneSent(third);
    third.serverSends(<String, dynamic>{
      'type': 'salon',
      'salon': <String, dynamic>{
        'code': 'S99FTH',
        'started': true,
        'hostSeat': 0,
        'players': _players,
        'you': 0,
      },
    });
    for (var tick = 0; tick < 30; tick++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    expect(
      session.connected,
      isTrue,
      reason: 'le siège libéré, la reprise aboutit',
    );
    expect(
      session.messages.map((m) => m.body),
      contains(contains('encore tenu')),
      reason: 'le fil explique pourquoi la reprise a été repoussée',
    );
    session.dispose();
  });

  test('J: un changement d’epoch tue le vieux cliché de partie', () async {
    final created = <FakeWebSocketChannel>[];
    final session = NetworkSalonSession(
      handshakeTimeout: const Duration(seconds: 2),
      reconnectDelay: const Duration(milliseconds: 20),
      createSalonCode: (_, _) async => 'S99FTH',
      channelFactory: (uri) {
        final channel = FakeWebSocketChannel.confirmed(uri);
        created.add(channel);
        return channel;
      },
    );

    final creating = session.createSalon('Cap Hôte', 0);
    await settle();
    final first = created.first;
    await untilOneSent(first);
    first.serverSends(<String, dynamic>{
      'type': 'salon',
      'salon': <String, dynamic>{
        'code': 'S99FTH',
        'started': false,
        'hostSeat': 0,
        'players': _players,
        'you': 0,
      },
    });
    await creating;

    // The engine's last picture lands in the session: a takeover would
    // rebuild from it.
    first.serverSends(<String, dynamic>{
      'type': 'snapshot',
      'payload': <String, dynamic>{
        'round': 12,
        'phase': 'bidding',
        'players': _players,
      },
    });
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(session.lastSnapshot, isNotNull);

    // A NEW game begins (the rematch bumped the epoch). The phone that
    // missed the previous game's fold must NOT keep the old picture:
    // restoring it resurrected last round's table ("back at round 12").
    first.serverSends(<String, dynamic>{
      'type': 'salon',
      'salon': <String, dynamic>{
        'code': 'S99FTH',
        'started': true,
        'epoch': 2,
        'hostSeat': 0,
        'players': _players,
        'you': 0,
      },
    });
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(
      session.lastSnapshot,
      isNull,
      reason: 'le cliché de la partie précédente est mort avec son epoch',
    );
    session.dispose();
  });
}
