import 'dart:async';

import 'package:dudo/salon/network_salon_session.dart';
import 'package:dudo/salon/salon_models.dart';
import 'package:flutter_test/flutter_test.dart';

import 'salon_test_helpers.dart';

bool feedClosed(FakeWebSocketChannel channel) => channel.closed;

List<String> addBotFrames(List<String> sent) =>
    sent.where((frame) => frame.contains('"addBot"')).toList();

List<String> joinFrames(List<String> sent) =>
    sent.where((frame) => frame.contains('"join"')).toList();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('createSalon adopte le siège hôte et ajoute ses IA', () async {
    final harness = Harness();
    final done = harness.session.createSalon('Cap Hôte', 3);
    await settle();
    final channel = harness.channel(
      'wss://dudo.supercloud.fr/api/v1/salons/S99FTH/ws',
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
    expect(harness.session.activeBaseUrl, 'https://dudo.supercloud.fr');
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
      'wss://dudo.supercloud.fr/api/v1/salons/S99FTH/ws',
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
      'wss://dudo.supercloud.fr/api/v1/salons/S99FTH/ws',
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
      'wss://dudo.supercloud.fr/api/v1/salons/S99FTH/ws',
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

  test('startGame concurrent → un seul start émis vers le Worker', () async {
    final harness = Harness();
    final creation = harness.session.createSalon('Cap Hôte', 0);
    await settle();
    final channel = harness.channel(
      'wss://dudo.supercloud.fr/api/v1/salons/S99FTH/ws',
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

    final first = harness.session.startGame();
    final second = harness.session.startGame();
    final third = harness.session.startGame();
    await settle();
    expect(framesOf(channel.sent, 'start'), hasLength(1));

    channel.serverSends(const <String, dynamic>{'type': 'started'});
    await Future.wait([first, second, third]);
    expect(harness.session.isStarting, isTrue);
  });

  test(
    'startGame sans confirmation du Worker ne prétend pas démarré',
    () async {
      final harness = Harness(timeoutMillis: 40);
      final creation = harness.session.createSalon('Cap Hôte', 0);
      await settle();
      final channel = harness.channel(
        'wss://dudo.supercloud.fr/api/v1/salons/S99FTH/ws',
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

      await harness.session.startGame();
      expect(harness.session.isStarting, isFalse);
      // A second press may retry once the pending attempt expired.
      await harness.session.startGame();
      expect(framesOf(channel.sent, 'start'), hasLength(2));
    },
  );

  test('startGame côté invité reste silencieux', () async {
    final harness = Harness();
    final joining = harness.session.joinSalon('S99FTH', 'Anne');
    await settle();
    final channel = harness.channel(
      'wss://dudo.supercloud.fr/api/v1/salons/S99FTH/ws',
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
      'wss://dudo.supercloud.fr/api/v1/salons/S99FTH/ws',
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

  test('un nouveau salon efface le fil du précédent (réseau)', () async {
    final session = NetworkSalonSession(
      handshakeTimeout: const Duration(milliseconds: 40),
      channelFactory: (uri) => FakeWebSocketChannel.unreachable(uri),
    );
    session.pushSystemMessage('Ligne de l\u2019ancien salon');
    expect(session.messages, isNotEmpty);

    await session.createSalon('Cap Hôte', 1);

    expect(
      session.messages,
      hasLength(1),
      reason: 'le thread repart à neuf, ancien salon non retenu',
    );
    expect(
      session.messages.first.body,
      contains('Impossible de créer un salon'),
      reason: 'seule la ligne de la nouvelle tentative subsiste',
    );
  });

  test('un nouveau salon efface le fil du précédent (local)', () async {
    final session = LocalSalonSession();
    await session.createSalon('Cap Hôte', 0);
    await session.sendChat('Hola la table !');
    expect(session.messages, hasLength(2));

    await session.createSalon('Cap Hôte', 0);

    expect(session.messages, hasLength(1));
    expect(session.messages.first.kind, SalonMessageKind.system);
    expect(session.messages.first.body, contains('Salon créé'));
  });

  test(
    'salon introuvable sur l\u2019hôte unique → échec sans message ferme',
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
      expect(channels, hasLength(1));
      expect(session.connected, isFalse);
    },
  );

  test('salon fermé par le Worker → socket coupé et ligne système', () async {
    final harness = Harness();
    final creation = harness.session.createSalon('Cap Hôte', 0);
    await settle();
    final channel = harness.channel(
      'wss://dudo.supercloud.fr/api/v1/salons/S99FTH/ws',
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
    expect(feedClosed(channel), isTrue);
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
      'wss://dudo.supercloud.fr/api/v1/salons/S99FTH/ws',
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

  test(
    'reconnexion automatique après coupure, puis demande de resync',
    () async {
      final created = <FakeWebSocketChannel>[];
      final session = NetworkSalonSession(
        handshakeTimeout: const Duration(milliseconds: 80),
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
      await untilOneSent(created.first);
      created.first.serverSends(
        salonFrame(
          you: 0,
          players: <Map<String, dynamic>>[
            {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
          ],
        ),
      );
      await creating;
      expect(session.connected, isTrue);

      // The relay drops the socket unexpectedly.
      await created.first.serverCloses();
      for (var index = 0; index < 100 && created.length < 2; index++) {
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      expect(created, hasLength(2));
      expect(
        session.messages.any(
          (message) => message.body.contains('Connexion perdue'),
        ),
        isTrue,
      );

      // The recovery handshake replays the join, then asks the host for a
      // fresh snapshot so a mid-game phone can resume.
      await untilOneSent(created[1]);
      created[1].serverSends(
        salonFrame(
          you: 0,
          players: <Map<String, dynamic>>[
            {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
          ],
        ),
      );
      await settle(6);
      expect(session.connected, isTrue);
      expect(
        framesOf(
          created[1].sent,
          'game',
        ).any((frame) => frame.contains('"resync"')),
        isTrue,
      );
      expect(
        session.messages.any((message) => message.body.contains('Reconnecté')),
        isTrue,
      );
    },
  );

  test(
    'le client répond pong au ping du serveur (liveness partagé)',
    () async {
      final created = <FakeWebSocketChannel>[];
      final session = NetworkSalonSession(
        handshakeTimeout: const Duration(milliseconds: 80),
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
      await untilOneSent(created.first);
      created.first.serverSends(
        salonFrame(
          you: 0,
          players: <Map<String, dynamic>>[
            {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
          ],
        ),
      );
      await creating;

      // The server probes liveness; the client must answer a pong frame.
      created.first.serverSends(const <String, dynamic>{'type': 'ping'});
      await settle(6);
      final pongs = framesOf(created.first.sent, 'pong');
      expect(pongs, hasLength(greaterThanOrEqualTo(1)));
      session.dispose();
    },
  );

  test('une création en 429 informe du délai sans marteler les autres hôtes', () async {
    final session = NetworkSalonSession(
      baseUrls: const [
        'https://dudo.supercloud.fr',
        'https://workers.dev',
      ],
      createSalonCode: (_, _) async => throw SalonRequestThrottled(3),
      channelFactory: (uri) => FakeWebSocketChannel.confirmed(uri),
    );
    await session.createSalon('Cap Hôte', 1);

    expect(
      session.messages.last.body,
      contains('réessaie'),
      reason: 'le 429 doit expliquer la pause',
    );
    expect(session.connected, isFalse);
    expect(session.code, isEmpty);
  });

  test('le seau de chat laisse une rafale de 3 puis refuse la 4e', () async {
    final harness = Harness();
    final done = harness.session.createSalon('Cap Hôte', 0);
    await settle();
    final channel = harness.channel(
      'wss://dudo.supercloud.fr/api/v1/salons/S99FTH/ws',
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
    await done;
    await settle();

    for (var round = 0; round < 3; round++) {
      await harness.session.sendChat('Message $round');
    }
    expect(framesOf(channel.sent, 'chat'), hasLength(3));

    await harness.session.sendChat('Le quatrième');
    expect(framesOf(channel.sent, 'chat'), hasLength(3));
    expect(
      harness.session.messages.last.body,
      contains('attends'),
      reason: 'le refus local doit être visible',
    );
  });
}
