import 'dart:async';
import 'dart:convert';

import 'package:dudo/salon/network_salon_session.dart';
import 'package:dudo/salon/salon_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// A scripted WebSocket channel: tests push server frames in with
/// [serverSends] and read what the session sent in [sent].
class FakeWebSocketChannel extends StreamChannelMixin
    implements WebSocketChannel {
  FakeWebSocketChannel.confirmed(this.uri) : ready = Future<void>.value();

  /// Emulates an unreachable host: the handshake never completes.
  FakeWebSocketChannel.unreachable(this.uri) : ready = Completer<void>().future;

  final Uri uri;

  @override
  final Future<void> ready;
  final List<String> sent = <String>[];
  final StreamController<String> _incoming = StreamController<String>();
  bool closed = false;

  @override
  Stream<dynamic> get stream => _incoming.stream;

  @override
  WebSocketSink get sink => _FakeSink(this);

  @override
  String? get protocol => null;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;

  void serverSends(Map<String, dynamic> frame) {
    _incoming.add(jsonEncode(frame));
  }

  Future<void> serverCloses() async {
    await _incoming.close();
  }
}

class _FakeSink implements WebSocketSink {
  _FakeSink(this.channel);

  final FakeWebSocketChannel channel;
  final Completer<void> _done = Completer<void>();

  @override
  void add(Object? event) => channel.sent.add('$event');

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<void> addStream(Stream<dynamic> stream) async {}

  @override
  Future close([int? closeCode, String? closeReason]) {
    channel.closed = true;
    if (!_done.isCompleted) {
      _done.complete();
    }
    return _done.future;
  }

  @override
  Future<void> get done => _done.future;
}

/// Session driving scripted channels for both candidate hosts.
class Harness {
  final Map<String, FakeWebSocketChannel> channels =
      <String, FakeWebSocketChannel>{};
  late NetworkSalonSession session;

  Harness({int timeoutMillis = 150, String providedCode = 's99fth'}) {
    session = NetworkSalonSession(
      handshakeTimeout: Duration(milliseconds: timeoutMillis),
      createSalonCode: (_, _) async => providedCode,
      channelFactory: (uri) => channels.putIfAbsent(
        uri.toString(),
        () => FakeWebSocketChannel.confirmed(uri),
      ),
    );
  }

  FakeWebSocketChannel channel(String url) {
    final key = Uri.parse(url).toString();
    return channels[key]!;
  }
}

Map<String, dynamic> salonFrame({
  required List<Map<String, dynamic>> players,
  required int you,
  bool started = false,
}) {
  return <String, dynamic>{
    'type': 'salon',
    'salon': <String, dynamic>{
      'code': 'S99FTH',
      'started': started,
      'hostSeat': 0,
      'players': players,
      'you': you,
    },
  };
}

/// Lets microtask chains (socket plumbing) settle.
Future<void> settle([int rounds = 4]) async {
  for (var index = 0; index < rounds; index++) {
    await Future<void>.delayed(Duration.zero);
  }
}

/// Waits until the session pushed at least one frame through the channel.
Future<void> untilOneSent(FakeWebSocketChannel channel) async {
  for (var index = 0; index < 200; index++) {
    if (channel.sent.isNotEmpty) return;
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}

List<String> framesOf(List<String> sent, String type) =>
    sent.where((frame) => frame.contains('"type":"$type"')).toList();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('createSalon adopte le siège hôte et ajoute ses IA', () async {
    final harness = Harness();
    final done = harness.session.createSalon('Cap Hôte', 3);
    await settle();
    final channel = harness.channel(
      'wss://api.dudo.supercloud.fr/salons/S99FTH/ws',
    );
    await untilOneSent(channel);
    expect(framesOf(channel.sent, 'join'), hasLength(1));
    expect(
      channel.sent.firstWhere((frame) => frame.contains('"join"')),
      contains('Cap Hôte'),
    );

    channel.serverSends(
      salonFrame(
        you: 0,
        players: <Map<String, dynamic>>[
          {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
        ],
      ),
    );
    await done;
    await settle();

    expect(harness.session.connected, isTrue);
    expect(harness.session.role, SalonRole.host);
    expect(harness.session.code, 'S99FTH');
    expect(harness.session.activeBaseUrl, 'https://api.dudo.supercloud.fr');
    expect(harness.session.you, 0);
    expect(addBotFrames(channel.sent), hasLength(3));
    expect(
      harness.session.messages.last,
      isA<SalonMessage>()
          .having((message) => message.kind, 'kind', SalonMessageKind.system)
          .having((message) => message.body, 'body', contains('Salon créé')),
    );
  });

  test('les états du salon mettent l\u2019équipage à jour', () async {
    final harness = Harness();
    final done = harness.session.createSalon('Cap Hôte', 1);
    await settle();
    final channel = harness.channel(
      'wss://api.dudo.supercloud.fr/salons/S99FTH/ws',
    );
    await untilOneSent(channel);
    channel.serverSends(
      salonFrame(
        you: 0,
        players: <Map<String, dynamic>>[
          {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
          {'seat': 1, 'name': 'Barbe-Noire', 'bot': true},
        ],
      ),
    );
    await done;

    channel.serverSends(
      salonFrame(
        you: 0,
        started: true,
        players: <Map<String, dynamic>>[
          {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
          {'seat': 1, 'name': 'Barbe-Noire', 'bot': true},
          {'seat': 2, 'name': 'Anne', 'bot': false},
        ],
      ),
    );
    await settle();

    expect(harness.session.players, hasLength(3));
    expect(harness.session.bots.map((player) => player.name), ['Barbe-Noire']);
    expect(
      harness.session.players.firstWhere((player) => player.seat == 0).isHost,
      isTrue,
    );
    expect(
      harness.session.players.firstWhere((player) => player.seat == 2).isHost,
      isFalse,
    );
    expect(harness.session.isStarting, isTrue);
  });

  test('chat et réactions relayés, avec \u2019mine\u2019 par siège', () async {
    final harness = Harness();
    final done = harness.session.createSalon('Cap Hôte', 0);
    await settle();
    final channel = harness.channel(
      'wss://api.dudo.supercloud.fr/salons/S99FTH/ws',
    );
    await untilOneSent(channel);
    channel.serverSends(
      salonFrame(
        you: 0,
        players: <Map<String, dynamic>>[
          {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
          {'seat': 1, 'name': 'Anne', 'bot': false},
        ],
      ),
    );
    await done;

    await harness.session.sendChat('En route !');
    expect(framesOf(channel.sent, 'chat').first, contains('En route !'));
    // Nothing locally echoed: only the relayed frame lands in the feed.
    final baseline = harness.session.messages.length;

    await harness.session.sendChat('En route !');
    expect(framesOf(channel.sent, 'chat').first, contains('En route !'));
    // Nothing locally echoed: only the relayed frame lands in the feed.

    channel.serverSends(<String, dynamic>{
      'type': 'chat',
      'chat': {'seat': 1, 'name': 'Anne', 'text': 'Salut capitaine !'},
    });
    channel.serverSends(<String, dynamic>{
      'type': 'reaction',
      'reaction': {'seat': 1, 'name': 'Anne', 'emoji': '🍺'},
    });
    channel.serverSends(<String, dynamic>{
      'type': 'chat',
      'chat': {'seat': 0, 'name': 'Cap Hôte', 'text': 'Toujours !'},
    });
    await settle();

    expect(harness.session.messages, hasLength(baseline + 3));
    expect(harness.session.messages[baseline].body, 'Salut capitaine !');
    expect(harness.session.messages[baseline].isMine, isFalse);
    expect(harness.session.messages[baseline + 1].kind, SalonMessageKind.emoji);
    expect(harness.session.messages[baseline + 2].isMine, isTrue);
  });

  test('startGame côté hôte attend le \u2019started\u2019 du Worker', () async {
    final harness = Harness();
    final creation = harness.session.createSalon('Cap Hôte', 0);
    await settle();
    final channel = harness.channel(
      'wss://api.dudo.supercloud.fr/salons/S99FTH/ws',
    );
    await untilOneSent(channel);
    channel.serverSends(
      salonFrame(
        you: 0,
        players: <Map<String, dynamic>>[
          {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
          {'seat': 1, 'name': 'Anne', 'bot': false},
        ],
      ),
    );
    await creation;

    final started = harness.session.startGame();
    await settle();
    expect(framesOf(channel.sent, 'start'), hasLength(1));
    channel.serverSends(
      salonFrame(
        you: 0,
        started: true,
        players: <Map<String, dynamic>>[
          {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
          {'seat': 1, 'name': 'Anne', 'bot': false},
        ],
      ),
    );
    channel.serverSends(const <String, dynamic>{'type': 'started'});
    await started;
    expect(harness.session.isStarting, isTrue);
  });

  test('startGame côté invité reste silencieux', () async {
    final harness = Harness();
    final joining = harness.session.joinSalon('S99FTH', 'Anne');
    await settle();
    final channel = harness.channel(
      'wss://api.dudo.supercloud.fr/salons/S99FTH/ws',
    );
    await untilOneSent(channel);
    channel.serverSends(
      salonFrame(
        you: 1,
        players: <Map<String, dynamic>>[
          {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
          {'seat': 1, 'name': 'Anne', 'bot': false},
        ],
      ),
    );
    final result = await joining;
    expect(result.ok, isTrue);
    expect(harness.session.role, SalonRole.guest);
    expect(harness.session.you, 1);

    await harness.session.startGame();
    await settle();
    expect(framesOf(channel.sent, 'start'), isEmpty);
  });

  test('un refus ferme du serveur court-circuite les autres hôtes', () async {
    final harness = Harness();
    final joining = harness.session.joinSalon('S99FTH', 'Anne');
    await settle();
    final channel = harness.channel(
      'wss://api.dudo.supercloud.fr/salons/S99FTH/ws',
    );
    await untilOneSent(channel);
    channel.serverSends(<String, dynamic>{
      'type': 'error',
      'message': 'Salon complet.',
    });
    final result = await joining;

    expect(result.ok, isFalse);
    expect(result.message, contains('Salon complet'));
    // Only the first host was ever contacted.
    expect(
      harness.channels.keys.any((key) => key.contains('workers.dev')),
      isFalse,
    );
  });

  test('joinSalon reçoit un code trop court sans réseau', () async {
    final harness = Harness();
    final result = await harness.session.joinSalon('ZZZ', 'Anne');
    expect(result.ok, isFalse);
    expect(result.message, contains('six caractères'));
    expect(harness.channels, isEmpty);
  });

  test(
    'salon introuvable sur les deux hôtes → échec sans message ferme',
    () async {
      final channels = <String, FakeWebSocketChannel>{};
      final session = NetworkSalonSession(
        handshakeTimeout: const Duration(milliseconds: 40),
        channelFactory: (uri) => channels.putIfAbsent(
          uri.toString(),
          () => FakeWebSocketChannel.unreachable(uri),
        ),
      );
      final result = await session.joinSalon('S99FTH', 'Anne');
      expect(result.ok, isFalse);
      expect(channels, hasLength(2));
      expect(session.connected, isFalse);
    },
  );

  test('salon fermé par le Worker → socket coupé et ligne système', () async {
    final harness = Harness();
    final creation = harness.session.createSalon('Cap Hôte', 0);
    await settle();
    final channel = harness.channel(
      'wss://api.dudo.supercloud.fr/salons/S99FTH/ws',
    );
    await untilOneSent(channel);
    channel.serverSends(
      salonFrame(
        you: 0,
        players: <Map<String, dynamic>>[
          {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
        ],
      ),
    );
    await creation;

    channel.serverSends(<String, dynamic>{
      'type': 'closed',
      'reason': 'L\u2019hôte a quitté la taverne.',
    });
    await settle();
    await Future<void>.delayed(const Duration(milliseconds: 30));

    expect(harness.session.connected, isFalse);
    expect(channel.closed, isTrue);
    expect(
      harness.session.messages.last.body,
      contains('L\u2019hôte a quitté'),
    );
  });

  test('les payloads relayés du jeu ressortent sur le flux table', () async {
    final harness = Harness();
    final creation = harness.session.createSalon('Cap Hôte', 0);
    await settle();
    final channel = harness.channel(
      'wss://api.dudo.supercloud.fr/salons/S99FTH/ws',
    );
    await untilOneSent(channel);
    channel.serverSends(
      salonFrame(
        you: 0,
        players: <Map<String, dynamic>>[
          {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
        ],
      ),
    );
    await creation;

    final received = Completer<RelayedTableMessage>();
    harness.session.tableEvents.listen(received.complete);
    channel.serverSends(<String, dynamic>{
      'type': 'game',
      'from': 0,
      'payload': <String, dynamic>{'kind': 'bid', 'quantity': 3, 'face': 4},
    });
    await settle();

    final message = await received.future;
    expect(message.kind, 'game');
    expect(message.fromSeat, 0);
    expect((message.payload as Map<String, dynamic>)['kind'], 'bid');
  });
}

bool feedClosed(FakeWebSocketChannel channel) => channel.closed;

List<String> addBotFrames(List<String> sent) =>
    sent.where((frame) => frame.contains('"addBot"')).toList();

List<String> joinFrames(List<String> sent) =>
    sent.where((frame) => frame.contains('"join"')).toList();
