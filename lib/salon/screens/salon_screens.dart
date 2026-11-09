import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ornaments.dart';
import '../../core/widgets/tavern_background.dart';
import '../../core/widgets/tavern_button.dart';
import '../../game/models/game_config.dart';
import '../../screens/game/game_screen.dart';
import '../network_game.dart';
import '../network_salon_session.dart';
import '../salon_models.dart';
import '../widgets/reaction_bar.dart';
import '../widgets/salon_bits.dart';
import '../widgets/salon_crew_card.dart';

/// "Créer un salon" / "Rejoindre un salon" and the lobby with code sharing,
/// IA adjustment, live reactions and chat. Works with any [SalonSession]
/// implementation (local prototype or network backend).
class SalonHomeScreen extends StatelessWidget {
  const SalonHomeScreen({super.key, required this.session});

  final SalonSession session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: TavernBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        RoundIconButton(
                          icon: Icons.arrow_back,
                          semanticLabel: 'Retour à la taverne',
                          onPressed: () => Navigator.of(context).pop(),
                          size: 42,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'MULTIJOUEUR',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: AppColors.brass,
                                  letterSpacing: 2.2,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const SalonTitle('Un salon, cinq gobelets'),
                    const SizedBox(height: 6),
                    const SalonHint(
                      'Les amis entrent avec un code à six caractères. '
                      'L\u2019hôte distribue les pirates IA, le salon '
                      'communique en direct par le Worker.',
                    ),
                    const SizedBox(height: 24),
                    TavernButton(
                      label: 'Créer un salon',
                      icon: Icons.wine_bar,
                      expand: true,
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => CreateSalonScreen(session: session),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    TavernButton(
                      label: 'Rejoindre un salon',
                      icon: Icons.door_sliding_outlined,
                      tone: TavernButtonTone.ghost,
                      expand: true,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => JoinSalonScreen(session: session),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 22),
                    OrnamentDivider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateSalonScreen extends StatefulWidget {
  const CreateSalonScreen({super.key, required this.session});

  final SalonSession session;

  @override
  State<CreateSalonScreen> createState() => _CreateSalonScreenState();
}

class _CreateSalonScreenState extends State<CreateSalonScreen> {
  late final TextEditingController _name;
  int _bots = 3;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.session.myName);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: TavernBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        RoundIconButton(
                          icon: Icons.arrow_back,
                          semanticLabel: 'Retour',
                          onPressed: () => Navigator.of(context).pop(),
                          size: 42,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'CRÉER UN SALON',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: AppColors.brass,
                                  letterSpacing: 2.2,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const SalonTitle('Tu arrives premier'),
                    const SizedBox(height: 6),
                    const SalonHint(
                      'Choisis ton matelot et combien de pirates IA viendront mentir avec toi.',
                    ),
                    const SizedBox(height: 18),
                    SalonTextField(
                      label: 'Ton nom de pirate',
                      controller: _name,
                      maxLength: 14,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    const SalonSectionLabel('Pirates IA'),
                    const SizedBox(height: 8),
                    SalonCrewCard(
                      bots: _bots,
                      onMinus: () =>
                          setState(() => _bots = (_bots - 1).clamp(0, 5)),
                      onPlus: () =>
                          setState(() => _bots = (_bots + 1).clamp(0, 5)),
                    ),
                    const SizedBox(height: 22),
                    TavernButton(
                      label: 'Créer le salon',
                      icon: Icons.record_voice_over_outlined,
                      expand: true,
                      onPressed: () async {
                        final name = _name.text.trim().isEmpty
                            ? 'Toi'
                            : _name.text.trim();
                        await widget.session.createSalon(name, _bots);
                        if (!context.mounted) return;
                        if (widget.session.code.isEmpty ||
                            widget.session.players.isEmpty) {
                          final last = widget.session.messages.isEmpty
                              ? 'La création du salon a échoué.'
                              : widget.session.messages.last.body;
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(last)));
                          return;
                        }
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                SalonLobbyScreen(session: widget.session),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class JoinSalonScreen extends StatefulWidget {
  const JoinSalonScreen({super.key, required this.session});

  final SalonSession session;

  @override
  State<JoinSalonScreen> createState() => _JoinSalonScreenState();
}

class _JoinSalonScreenState extends State<JoinSalonScreen> {
  late final TextEditingController _code;
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _code = TextEditingController();
    _name = TextEditingController(text: 'Mousse');
  }

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    super.dispose();
  }

  bool get _canJoin => _code.text.length == 6 && _name.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: TavernBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        RoundIconButton(
                          icon: Icons.arrow_back,
                          semanticLabel: 'Retour',
                          onPressed: () => Navigator.of(context).pop(),
                          size: 42,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'REJOINDRE UN SALON',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: AppColors.brass,
                                  letterSpacing: 2.2,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const SalonTitle('Le code fait foi'),
                    const SizedBox(height: 6),
                    const SalonHint(
                      'Entre les six caractères que l\u2019hôte t\u2019a envoyés. '
                      'Sur le salon, ton nom est tout ce que tu peux changer.',
                    ),
                    const SizedBox(height: 18),
                    SalonTextField(
                      label: 'Code du salon',
                      controller: _code,
                      maxLength: 6,
                      autofocus: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[A-HJ-NP-Z2-9]'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.cached, size: 16),
                        label: const Text(
                          'Rentrer en frais — via SMS, mail, WhatsApp, Signal ou n\u2019importe où ailleurs c\u2019est juste mieux.',
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SalonTextField(
                      label: 'Ton nom (tu peux encore le changer)',
                      controller: _name,
                      maxLength: 14,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 22),
                    ListenableBuilder(
                      listenable: _code,
                      builder: (context, _) {
                        return TavernButton(
                          label: 'Rejoindre',
                          icon: Icons.group_add_outlined,
                          expand: true,
                          onPressed: _canJoin
                              ? () async {
                                  final result = await widget.session.joinSalon(
                                    _code.text,
                                    _name.text.trim(),
                                  );
                                  if (context.mounted && !result.ok) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          result.message ?? 'Salon injoignable pour l\u2019instant.',
                                        ),
                                      ),
                                    );
                                  }
                                  if (context.mounted && result.ok) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute<void>(
                                        builder: (_) => SalonLobbyScreen(
                                          session: widget.session,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              : null,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SalonLobbyScreen extends StatefulWidget {
  const SalonLobbyScreen({super.key, required this.session});

  final SalonSession session;

  @override
  State<SalonLobbyScreen> createState() => _SalonLobbyScreenState();
}

class _SalonLobbyScreenState extends State<SalonLobbyScreen> {
  bool _tableOpened = false;
  bool _starting = false;

  @override
  void initState() {
    super.initState();
    widget.session.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.session.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (!mounted) return;
    setState(() {});
    final isNetwork = widget.session is NetworkSalonSession;
    // Guests (and any late host) hop to the table as soon as the Worker
    // confirms the round started.
    if (isNetwork && widget.session.isStarting && !_tableOpened) {
      _tableOpened = true;
      _pushTable(context);
    }
    // The game reached its standings: the Worker reopened the salon, the
    // table folds back to the tavern lobby so a new phone can join or the
    // table can replay.
    if (isNetwork && _tableOpened && !widget.session.isStarting) {
      _tableOpened = false;
      final current = _tableRoute;
      if (current != null && current.isCurrent) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      _tableRoute = null;
    }
  }

  Route<void>? _tableRoute;

  bool get isHost => widget.session.role == SalonRole.host;

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: TavernBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    RoundIconButton(
                      icon: Icons.close,
                      semanticLabel: 'Quitter le salon',
                      onPressed: () => _confirmLeave(context),
                      size: 42,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'SALON ${session.code}',
                            style: AppTypography.inscription(
                              size: 18,
                              color: AppColors.brassBright,
                              letterSpacing: 2.4,
                            ),
                          ),
                          Text(
                            isHost
                                ? 'Tu reines sur ce salon'
                                : "Invité de l’hôte",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    RoundIconButton(
                      icon: Icons.language,
                      semanticLabel: 'Copier le code',
                      onPressed: () async {
                        await session.copyCode();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Code copié dans le presse-papier.',
                              ),
                            ),
                          );
                        }
                      },
                      size: 42,
                      highlighted: true,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 150,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (isHost) ...[
                              _ShareRow(session: session),
                              const SizedBox(height: 14),
                            ],
                            _PlayersCard(session: session, isHost: isHost),
                            const SizedBox(height: 16),
                            if (isHost)
                              TavernButton(
                                label: _starting
                                    ? 'La manche se prépare…'
                                    : 'Lancer la manche',
                                icon: _starting
                                    ? Icons.hourglass_top
                                    : Icons.sports_esports_outlined,
                                expand: true,
                                onPressed:
                                    session.players.length >= 2 &&
                                        !_starting &&
                                        !_tableOpened
                                    ? () => _openTable(context)
                                    : null,
                              ),
                            if (!isHost) ...[
                              const SizedBox(height: 8),
                              const SalonHint(
                                'En attente que l\u2019hôte lance la manche…',
                              ),
                            ],
                            const SizedBox(height: 18),
                            const SalonSectionLabel('Le fil du salon'),
                            const SizedBox(height: 8),
                            for (final message in session.messages)
                              _SalonMessageRow(message: message),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ReactionBar(
                players: session.players,
                onSendReaction: session.sendReaction,
                onSendChat: session.sendChat,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLeave(BuildContext context) async {
    final quit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Quitter le salon ?',
            style: AppTypography.inscription(
              size: 22,
              color: AppColors.parchment,
            ),
          ),
          content: const Text(
            'Le code deviendra inutilisable pour cette partie.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Rester'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.bloodBright,
              ),
              child: const Text('Quitter'),
            ),
          ],
        );
      },
    );
    if (quit == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  /// Starts the round: sends `start` and, once the Worker accepts, opens
  /// the network table — relayed engine on the host, snapshot mirror on
  /// the guests. Local sessions navigate to their offline engine as before.
  Future<void> _openTable(BuildContext context) async {
    if (_starting || _tableOpened) return;
    setState(() => _starting = true);
    await widget.session.startGame();
    if (!context.mounted) return;
    if (!widget.session.isStarting) {
      if (mounted) setState(() => _starting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La manche n\u2019a pas pu démarrer. Réessaie.'),
        ),
      );
      return;
    }
    // The started-listener may already have pushed the table.
    if (_tableOpened) return;
    _tableOpened = true;
    _pushTable(context);
  }

  /// Builds the table (host relay or guest mirror) and pushes the screen.
  void _pushTable(BuildContext context) {
    if (!context.mounted) return;
    final navigator = Navigator.of(context, rootNavigator: true);

    if (widget.session is! NetworkSalonSession) {
      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => GameScreen(
            config: GameConfig(opponentCount: widget.session.bots.length),
          ),
        ),
      );
      return;
    }

    final network = widget.session as NetworkSalonSession;
    final names = [
      for (var seat = 0; seat < network.players.length; seat++)
        network.players.firstWhere((player) => player.seat == seat).name,
    ];

    if (network.role == SalonRole.host) {
      // Salon bots sit on those seats; the host controller plays them.
      final botSeats = {
        for (final player in network.players)
          if (player.isBot) player.seat,
      };
      final relay = HostGameRelay(
        session: network,
        names: names,
        botSeats: botSeats,
      );
      relay.start();
      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => GameScreen(controller: relay.controller),
        ),
      );
      return;
    }
    final guest = GuestGameController(
      config: GameConfig(opponentCount: names.length - 1),
      session: network,
      names: names,
    );
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => GameScreen(controller: guest)),
    );
  }
}

class _ShareRow extends StatelessWidget {
  const _ShareRow({required this.session});

  final SalonSession session;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.leather.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.brassDim.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Text(
            session.code,
            textAlign: TextAlign.center,
            style: AppTypography.inscription(
              size: 34,
              color: AppColors.brassBright,
              letterSpacing: 7,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundIconButton(
                icon: Icons.share_outlined,
                semanticLabel: 'Partager le code',
                onPressed: session.shareCode,
                size: 44,
              ),
              const SizedBox(width: 6),
              RoundIconButton(
                icon: Icons.sms_outlined,
                semanticLabel: 'Envoyer par SMS',
                onPressed: session.writeOnSms,
                size: 44,
              ),
              const SizedBox(width: 6),
              RoundIconButton(
                icon: Icons.mail_outline,
                semanticLabel: 'Envoyer par mail',
                onPressed: session.writeOnMail,
                size: 44,
              ),
              const SizedBox(width: 6),
              RoundIconButton(
                icon: Icons.chat_outlined,
                semanticLabel: 'Envoyer sur WhatsApp',
                onPressed: session.shareOnWhatsapp,
                size: 44,
              ),
            ],
          ),
          const SizedBox(height: 6),
          SalonHint(
            'WhatsApp, Signal, SMS, mail : chaque app ouvre les bons liens, sinon copie.',
          ),
        ],
      ),
    );
  }
}

class _PlayersCard extends StatelessWidget {
  const _PlayersCard({required this.session, required this.isHost});

  final SalonSession session;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.leatherDeep.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grain),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SalonSectionLabel(
            'À table (${session.players.length})',
            trailing: isHost
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RoundIconButton(
                        icon: Icons.remove,
                        semanticLabel: 'Retirer un pirate IA',
                        onPressed: session.removeBot,
                        size: 38,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${session.bots.length}',
                        style: AppTypography.inscription(
                          size: 15,
                          color: AppColors.brassBright,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(width: 6),
                      RoundIconButton(
                        icon: Icons.add,
                        semanticLabel: 'Ajouter un pirate IA',
                        onPressed: session.addBot,
                        size: 38,
                      ),
                    ],
                  )
                : null,
          ),
          const SizedBox(height: 8),
          for (final player in session.players)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    player.isBot ? Icons.smart_toy_outlined : Icons.person,
                    size: 17,
                    color: player.isHost
                        ? AppColors.brassBright
                        : AppColors.parchmentDim,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      !player.isBot && player.seat == 0
                          ? '${player.name} (toi)'
                          : player.name,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(color: AppColors.parchment, fontSize: 14),
                    ),
                  ),
                  if (player.isHost)
                    Text(
                      'HÔTE',
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: AppColors.brass),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SalonMessageRow extends StatelessWidget {
  const _SalonMessageRow({required this.message});

  final SalonMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: message.isMine
              ? AppColors.brass.withValues(alpha: 0.16)
              : message.kind == SalonMessageKind.system
              ? AppColors.feltDeep.withValues(alpha: 0.6)
              : AppColors.leather,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: message.kind == SalonMessageKind.system
                ? AppColors.brassDim.withValues(alpha: 0.4)
                : message.isMine
                ? AppColors.brass.withValues(alpha: 0.4)
                : AppColors.grain,
          ),
        ),
        child: message.kind == SalonMessageKind.emoji
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.emoji ?? '',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    message.authorName,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: AppColors.parchmentMuted),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.authorName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: message.isMine
                          ? AppColors.brassBright
                          : AppColors.parchmentMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message.body,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: AppColors.parchment),
                  ),
                ],
              ),
      ),
    );
  }
}
