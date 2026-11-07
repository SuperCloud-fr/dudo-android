import 'dart:convert';

import 'package:dudo/game/models/bid.dart';
import 'package:dudo/game/models/game_config.dart';
import 'package:dudo/game/models/table_event.dart';
import 'package:dudo/salon/network_game.dart';
import 'package:dudo/salon/network_salon_session.dart';
import 'package:flutter_test/flutter_test.dart';

import 'salon_test_helpers.dart';

/// Builds two sessions (one "host" phone, one "guest" phone) across a
/// three-seat salon, plus the engine relay on the host side and the
/// snapshot mirror on the guest side.
class TwoPhones {
  Harness hostHarness = Harness();
  Harness guestHarness = Harness();
  HostGameRelay? relay;

  static const List<Map<String, dynamic>> salonJson = <Map<String, dynamic>>[
    {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
    {'seat': 1, 'name': 'Anne', 'bot': false},
    {'seat': 2, 'name': 'Bob', 'bot': false},
  ];

  FakeWebSocketChannel hostChannel() => harness(hostHarness);

  FakeWebSocketChannel guestChannel() => harness(guestHarness);

  FakeWebSocketChannel harness(Harness value) =>
      value.channel('wss://dudo.supercloud.fr/api/v1/salons/S99FTH/ws');

  /// Mirrors the Worker: what the host broadcasts lands on the guest socket.
  Future<void> forwardHostToGuest() async {
    final snapshots = framesOf(hostChannel().sent, 'snapshot').map(
      (frame) => <String, dynamic>{
        'type': 'snapshot',
        'from': 0,
        'payload': (jsonDecode(frame) as Map<String, dynamic>)['payload'],
      },
    );
    for (final frame in snapshots) {
      guestChannel().serverSends(frame);
    }
    await settle();
  }

  List<Map<String, dynamic>> hostSnapshots() =>
      framesOf(hostChannel().sent, 'snapshot')
          .map(
            (frame) =>
                (jsonDecode(frame) as Map<String, dynamic>)['payload']
                    as Map<String, dynamic>,
          )
          .toList();

  List<Map<String, dynamic>> guestSends() =>
      framesOf(guestChannel().sent, 'game')
          .map(
            (frame) =>
                (jsonDecode(frame) as Map<String, dynamic>)['payload']
                    as Map<String, dynamic>,
          )
          .toList();

  HostGameRelay startHostRelay({
    Set<int> botSeats = const <int>{},
    List<String> names = const ['Cap Hôte', 'Anne', 'Bob'],
  }) {
    relay = HostGameRelay(
      session: hostHarness.session,
      names: names,
      seedFactory: () => 424242,
      botSeats: botSeats,
    );
    relay!.start();
    return relay!;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Both phones handshake against the scripted Worker, the salon frame
  /// lands on each socket, then the relay and the mirror come up.
  Future<TwoPhones> openTable({
    List<Map<String, dynamic>> seats = TwoPhones.salonJson,
  }) async {
    final phones = TwoPhones();
    final creating = phones.hostHarness.session.createSalon('Cap Hôte', 0);
    final joining = phones.guestHarness.session.joinSalon('S99FTH', 'Anne');
    await settle();
    final hostChannel = phones.hostChannel();
    final guestChannel = phones.guestChannel();
    await untilOneSent(hostChannel);
    await untilOneSent(guestChannel);
    hostChannel.serverSends(salonFrame(you: 0, players: seats));
    guestChannel.serverSends(salonFrame(you: 1, players: seats));
    final joinResult = await joining;
    await creating;
    await settle();
    expect(phones.hostHarness.session.you, 0);
    expect(phones.guestHarness.session.you, 1);
    expect(joinResult.ok, isTrue);
    return phones;
  }

  test('le même seed fait émerger les mêmes dés des deux côtés', () async {
    final phones = await openTable();

    final relay = phones.startHostRelay();
    final host = relay.controller;

    final guest = GuestGameController(
      config: const GameConfig(opponentCount: 2),
      session: phones.guestHarness.session,
      names: ['Cap Hôte', 'Anne', 'Bob'],
    );
    await phones.forwardHostToGuest();
    expect(guest.players, hasLength(3));
    expect(guest.round, host.round);

    // Same seed → the same dice values, seen table-relative.
    for (var local = 0; local < 3; local++) {
      final salonSeat = (local + phones.guestHarness.session.you) % 3;
      expect(guest.players[local].dice, host.players[salonSeat].dice);
      expect(guest.players[local].diceCount, host.players[salonSeat].diceCount);
    }
    guest.dispose();
    relay.dispose();
  });

  test(
    'une enchère d\u2019invité passe par un hôte puis revient en miroir',
    () async {
      final phones = await openTable();

      final relay = phones.startHostRelay();
      final host = relay.controller;
      host.beginBidding();
      expect(host.phase, GamePhase.bidding);

      final guest = GuestGameController(
        config: const GameConfig(opponentCount: 2),
        session: phones.guestHarness.session,
        names: ['Cap Hôte', 'Anne', 'Bob'],
      );

      // Push the two snapshots so far (initial + bidding).
      await phones.forwardHostToGuest();
      expect(guest.phase, GamePhase.bidding);
      // Salon seat 0 becomes local seat 2 → not her turn yet.
      expect(guest.currentPlayer, 2);
      expect(guest.isHumanTurn, isFalse);

      // Host opens the bidding: 2 paco.
      expect(
        host.submitHumanBid(const Bid(quantity: 2, face: 1, playerSeat: 0)),
        isTrue,
      );
      await phones.forwardHostToGuest();
      // The table moved to salon seat 1 → local seat 0 → her turn.
      expect(guest.currentPlayer, 0);
      expect(guest.isHumanTurn, isTrue);
      expect(guest.currentBid?.quantity, 2);

      // Her bid travels as a command; the host validates and broadcasts.
      expect(
        guest.submitHumanBid(const Bid(quantity: 4, face: 1, playerSeat: 0)),
        isTrue,
      );
      final commands = phones.guestSends();
      expect(commands, hasLength(1));
      expect(commands.first['kind'], 'bid');
      expect(commands.first['quantity'], 4);

      relay.handleTable(
        RelayedTableMessage(kind: 'game', fromSeat: 1, payload: commands.first),
      );
      expect(
        host.currentBid,
        isA<Bid>()
            .having((bid) => bid.quantity, 'quantity', 4)
            .having((bid) => bid.playerSeat, 'seat', 1),
      );
      await phones.forwardHostToGuest();
      expect(guest.currentBid?.quantity, 4);
      // Engine advanced to salon seat 2 → local seat 1.
      expect(guest.currentPlayer, 1);

      guest.dispose();
      relay.dispose();
    },
  );

  test(
    'le dudo d\u2019un invité produit un \u2019reveal\u2019 partagé',
    () async {
      final phones = await openTable();

      final relay = phones.startHostRelay();
      final host = relay.controller;
      host.beginBidding();
      host.submitHumanBid(const Bid(quantity: 1, face: 1, playerSeat: 0));

      final guest = GuestGameController(
        config: const GameConfig(opponentCount: 2),
        session: phones.guestHarness.session,
        names: ['Cap Hôte', 'Anne', 'Bob'],
      );
      await phones.forwardHostToGuest();
      expect(guest.currentBid?.quantity, 1);
      // Salon seat 1 → local seat 0 : her turn.
      expect(guest.callHumanDudo(), isTrue);
      final commands = phones.guestSends();
      expect(commands, hasLength(1));
      expect(commands.first['kind'], 'dudo');

      relay.handleTable(
        RelayedTableMessage(kind: 'game', fromSeat: 1, payload: commands.first),
      );
      expect(host.phase, GamePhase.reveal);
      expect(host.outcome, isNotNull);
      await phones.forwardHostToGuest();

      expect(guest.phase, GamePhase.reveal);
      // The caller, salon seat 1, is local seat 0 on the guest mirror too.
      expect(guest.outcome!.callerSeat, 0);
      expect(guest.outcome!.actualCount, host.outcome!.actualCount);
      // The mirror never self-applies; the host drives the reveal.
      guest.applyOutcome();
      expect(guest.phase, GamePhase.reveal);

      host.applyOutcome();
      await phones.forwardHostToGuest();
      expect(host.phase, GamePhase.roundOver);
      expect(guest.phase, GamePhase.roundOver);

      // A guest can wave the next round through.
      guest.nextRound();
      final commands2 = phones.guestSends();
      expect(commands2.last['kind'], 'nextRound');
      relay.handleTable(
        RelayedTableMessage(kind: 'game', fromSeat: 1, payload: commands2.last),
      );
      expect(host.phase, GamePhase.peek);
      expect(host.round, 2);
      await phones.forwardHostToGuest();
      expect(guest.round, 2);
      expect(guest.phase, GamePhase.peek);

      guest.dispose();
      relay.dispose();
    },
  );

  test('les PNJ du salon jouent sur le téléphone de l\u2019hôte', () async {
    final phones = await openTable(
      seats: const [
        {'seat': 0, 'name': 'Cap Hôte', 'bot': false},
        {'seat': 1, 'name': 'Anne', 'bot': false},
        {'seat': 2, 'name': 'Mérou', 'bot': true},
      ],
    );

    final relay = phones.startHostRelay(
      botSeats: {2},
      names: ['Cap Hôte', 'Anne', 'Mérou'],
    );
    final host = relay.controller;

    final guest = GuestGameController(
      config: const GameConfig(opponentCount: 2),
      session: phones.guestHarness.session,
      names: ['Cap Hôte', 'Anne', 'Mérou'],
    );
    await phones.forwardHostToGuest();

    // The bot seat is no longer holed up as a human on the host engine.
    expect(host.players[2].isHuman, isFalse);
    expect(host.autoPlayBots, isTrue);
    // The guest mirror stays view-only: nobody plays locally.
    expect(guest.autoPlayBots, isFalse);
    expect(guest.players[1].isHuman, isTrue);

    host.beginBidding();
    expect(
      host.submitHumanBid(const Bid(quantity: 2, face: 2, playerSeat: 0)),
      isTrue,
      reason: 'l\u2019hôte ouvre',
    );
    expect(host.currentBid!.playerSeat, 0);
    expect(host.currentPlayer, 1, reason: 'au tour d\u2019Anne');

    // Anne never answers (issue #7): the host's AFK guard bids for her
    // with the cheapest legal raise, and the table keeps moving.
    host.enforceTurnTimeoutNow();
    expect(
      host.currentBid!.playerSeat,
      1,
      reason: 'l\u2019hôte remplace le pirate silencieux',
    );
    expect(host.currentPlayer, 2, reason: 'au tour du PNJ');

    // Online bots play when told to (same code path as the solo timer).
    host.performBotMove();
    final botEvent = host.journal.last;
    expect(botEvent.playerSeat, 2);
    expect(
      botEvent.kind == TableEventKind.bid || botEvent.kind == TableEventKind.dudo,
      isTrue,
      reason: 'le PNJ enchИrit ou annonce dudo',
    );

    // The bot's move is broadcast; the guest sees it re-based.
    await phones.forwardHostToGuest();
    expect(guest.journal.last.playerSeat, 1, reason: 'siège 2 vu de chez Anne');

    guest.dispose();
    relay.dispose();
  });
}
