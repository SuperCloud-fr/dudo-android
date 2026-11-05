import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/dice_face.dart';
import '../../core/widgets/ornaments.dart';
import '../../core/widgets/tavern_background.dart';
import '../../core/widgets/tavern_button.dart';
import '../rules/rules_screen.dart';
import '../setup/setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: TavernBackground(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (MediaQuery.sizeOf(context).height > 740)
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 138,
                child: _TavernTableEdge(),
              ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 36,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 430),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SectionLabel(
                                'Taverne du dernier dé',
                                trailing: Text(
                                  'SOLO · HORS LIGNE',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: AppColors.brassDim,
                                        letterSpacing: 1.2,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: SwayingSign(
                                  width: math.min(
                                    360,
                                    constraints.maxWidth - 48,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Cinq dés. Un gobelet.\nTout le monde ment.',
                                textAlign: TextAlign.center,
                                style: AppTypography.inscription(
                                  size: 21,
                                  weight: FontWeight.w400,
                                  color: AppColors.parchment,
                                  letterSpacing: 0.8,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Le Perudo des pirates, contre un équipage qui sait bluffer.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.parchmentMuted),
                              ),
                              const SizedBox(height: 26),
                              TavernButton(
                                label: 'Jouer',
                                icon: Icons.casino_outlined,
                                expand: true,
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => const SetupScreen(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 6),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => const RulesScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.menu_book_outlined,
                                  size: 17,
                                ),
                                label: const Text('Comment jouer ?'),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var value = 1; value <= 3; value++)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      child: DiceFace(
                                        value: value,
                                        size: 17,
                                        rotation: (value - 2) * 0.08,
                                        dimmed: true,
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'v0.1 · 2 à 6 joueurs',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppColors.parchmentMuted,
                                          letterSpacing: 0.4,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SwayingSign extends StatefulWidget {
  const SwayingSign({super.key, required this.width});

  final double width;

  @override
  State<SwayingSign> createState() => _SwayingSignState();
}

class _SwayingSignState extends State<SwayingSign>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sway;

  @override
  void initState() {
    super.initState();
    _sway = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6400),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _sway.stop();
      _sway.value = 0.5;
    } else if (!_sway.isAnimating) {
      _sway.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _sway.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.width / 1.36;
    return AnimatedBuilder(
      animation: _sway,
      builder: (context, child) {
        final angle = math.sin(_sway.value * math.pi * 2) * 0.009;
        return Transform.rotate(
          angle: angle,
          alignment: Alignment.topCenter,
          child: child,
        );
      },
      child: SizedBox(
        width: widget.width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const CustomPaint(painter: _SignPainter()),
            Padding(
              padding: EdgeInsets.fromLTRB(
                widget.width * 0.07,
                height * 0.19,
                widget.width * 0.07,
                height * 0.08,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const DiceFace(
                    value: 1,
                    size: 38,
                    highlight: true,
                    rotation: -0.05,
                  ),
                  SizedBox(height: height * 0.03),
                  Text(
                    'DUDO',
                    style: AppTypography.inscription(
                      size: widget.width * 0.18,
                      color: AppColors.parchment,
                      letterSpacing: widget.width * 0.026,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: height * 0.025),
                  Container(
                    width: widget.width * 0.18,
                    height: 1,
                    color: AppColors.brassDim,
                  ),
                  SizedBox(height: height * 0.018),
                  Text(
                    'LE JEU DU MENSONGE',
                    style: AppTypography.inscription(
                      size: widget.width * 0.028,
                      weight: FontWeight.w400,
                      color: AppColors.brass,
                      letterSpacing: 2.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignPainter extends CustomPainter {
  const _SignPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final board = Rect.fromLTWH(0, h * 0.135, w, h * 0.865);
    final notch = w * 0.045;

    final boardPath = Path()
      ..moveTo(board.left + notch, board.top)
      ..lineTo(board.right - notch, board.top)
      ..lineTo(board.right, board.top + notch)
      ..lineTo(board.right, board.bottom - notch)
      ..lineTo(board.right - notch, board.bottom)
      ..lineTo(board.left + notch, board.bottom)
      ..lineTo(board.left, board.bottom - notch)
      ..lineTo(board.left, board.top + notch)
      ..close();

    canvas.drawShadow(boardPath, Colors.black, 16, false);

    // Chains.
    final chainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.brassDim.withValues(alpha: 0.75);
    for (final x in [w * 0.28, w * 0.72]) {
      canvas.drawLine(Offset(x, 0), Offset(x, board.top + 2), chainPaint);
      for (var y = 6.0; y < board.top; y += 13) {
        canvas.drawOval(
          Rect.fromCenter(center: Offset(x, y), width: 7, height: 10),
          chainPaint,
        );
      }
    }

    // Board.
    canvas.drawPath(
      boardPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.woodLight, AppColors.wood, AppColors.woodDeep],
          stops: [0.0, 0.55, 1.0],
        ).createShader(board),
    );
    canvas.drawPath(
      boardPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.brassDim,
    );

    // Grain.
    final random = math.Random(7);
    final grainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = AppColors.grain.withValues(alpha: 0.42);
    for (var i = 0; i < 9; i++) {
      final y = board.top + 12 + random.nextDouble() * (board.height - 24);
      final path = Path()..moveTo(board.left + 10, y);
      for (var segment = 1; segment <= 3; segment++) {
        path.quadraticBezierTo(
          board.left + w * segment / 3,
          y + (random.nextDouble() - 0.5) * 8,
          board.left + w * (segment + 1) / 4,
          y + (random.nextDouble() - 0.5) * 4,
        );
      }
      canvas.drawPath(path, grainPaint);
    }

    // Nails.
    final nailPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.brassBright.withValues(alpha: 0.9),
          AppColors.brassDim,
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: w * 0.012));
    for (final point in [
      Offset(board.left + notch, board.top + notch),
      Offset(board.right - notch, board.top + notch),
      Offset(board.left + notch, board.bottom - notch),
      Offset(board.right - notch, board.bottom - notch),
    ]) {
      canvas.drawCircle(point, w * 0.009, nailPaint);
    }

    // Candlelight from the top right.
    canvas.drawPath(
      boardPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.candle.withValues(alpha: 0.10),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.18),
          ],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(board),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TavernTableEdge extends StatelessWidget {
  const _TavernTableEdge();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const CustomPaint(painter: _TableEdgePainter()),
            Positioned(
              top: 22,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  DiceFace(value: 5, size: 34, rotation: -0.09, dimmed: true),
                  SizedBox(width: 10),
                  DiceFace(value: 1, size: 40, rotation: 0.04),
                  SizedBox(width: 10),
                  DiceFace(value: 3, size: 32, rotation: 0.11, dimmed: true),
                  SizedBox(width: 10),
                  DiceFace(value: 6, size: 36, rotation: -0.04, dimmed: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableEdgePainter extends CustomPainter {
  const _TableEdgePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final edge = Path()
      ..moveTo(0, 34)
      ..quadraticBezierTo(w * 0.5, -8, w, 34)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawShadow(edge, Colors.black, 18, false);
    canvas.drawPath(
      edge,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF24513F), AppColors.feltDeep, Color(0xFF081A13)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
    final rim = Path()
      ..moveTo(0, 34)
      ..quadraticBezierTo(w * 0.5, -8, w, 34);
    canvas.drawPath(
      rim,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = AppColors.leatherDeep,
    );
    canvas.drawPath(
      rim,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = AppColors.brassDim.withValues(alpha: 0.8),
    );

    final random = math.Random(9);
    final grain = Paint()
      ..color = AppColors.candle.withValues(alpha: 0.05)
      ..strokeWidth = 0.8;
    for (var i = 0; i < 8; i++) {
      final y = 60 + random.nextDouble() * (h - 60);
      canvas.drawLine(
        Offset(random.nextDouble() * w * 0.25, y),
        Offset(w * (0.75 + random.nextDouble() * 0.25), y + 4),
        grain,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
