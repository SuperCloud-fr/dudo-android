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
      session.dispose();
    },
  );
}
