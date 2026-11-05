import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The room behind every screen: dark planks, warm candlelight, dust.
/// It is deliberately quiet so the table and the dice own the attention.
class TavernBackground extends StatefulWidget {
  const TavernBackground({super.key, required this.child, this.candle = true});

  final Widget child;
  final bool candle;

  @override
  State<TavernBackground> createState() => _TavernBackgroundState();
}

class _TavernBackgroundState extends State<TavernBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flicker;
  bool _reducedMotion = false;

  @override
  void initState() {
    super.initState();
    _flicker = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduced = MediaQuery.disableAnimationsOf(context);
    if (reduced == _reducedMotion) return;
    _reducedMotion = reduced;
    if (reduced) {
      _flicker.stop();
      _flicker.value = 0.55;
    } else {
      _flicker.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _flicker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _flicker,
            builder: (context, _) {
              return CustomPaint(
                painter: _TavernPainter(
                  glow: widget.candle ? 0.72 + _flicker.value * 0.28 : 0.0,
                ),
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _TavernPainter extends CustomPainter {
  _TavernPainter({required this.glow});

  final double glow;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1D130C), AppColors.woodDeep, Color(0xFF070504)],
          stops: [0.0, 0.55, 1.0],
        ).createShader(rect),
    );

    _paintPlanks(canvas, size);
    _paintCandleGlow(canvas, size);
    _paintDust(canvas, size);
    _paintVignette(canvas, size);
  }

  void _paintPlanks(Canvas canvas, Size size) {
    final plankWidth = size.width / 5.2;
    final linePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.28)
      ..strokeWidth = 1.2;
    final grainPaint = Paint()
      ..color = AppColors.grain.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (var index = 0; index <= 6; index++) {
      final x = index * plankWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
      final localRandom = math.Random(index * 17 + 3);
      for (var grain = 0; grain < 4; grain++) {
        final path = Path();
        final startX = x + 6 + localRandom.nextDouble() * (plankWidth - 12);
        final startY = localRandom.nextDouble() * size.height;
        path.moveTo(startX, startY);
        for (var segment = 1; segment <= 3; segment++) {
          path.quadraticBezierTo(
            startX + (segment.isOdd ? 7 : -7),
            startY + segment * size.height * 0.08,
            startX + (localRandom.nextDouble() - 0.5) * 10,
            startY + segment * size.height * 0.16,
          );
        }
        canvas.drawPath(path, grainPaint);
      }
    }
  }

  void _paintCandleGlow(Canvas canvas, Size size) {
    if (glow <= 0) return;
    final center = Offset(size.width * 0.82, size.height * 0.10);
    final radius = size.width * 0.85;
    final glowRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.candle.withValues(alpha: 0.17 * glow),
            AppColors.candle.withValues(alpha: 0.05 * glow),
            Colors.transparent,
          ],
          stops: const [0.0, 0.35, 1.0],
        ).createShader(glowRect),
    );

    final lowGlow = Offset(size.width * 0.08, size.height * 0.92);
    canvas.drawCircle(
      lowGlow,
      size.width * 0.55,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                AppColors.blood.withValues(alpha: 0.045 * glow),
                Colors.transparent,
              ],
            ).createShader(
              Rect.fromCircle(center: lowGlow, radius: size.width * 0.55),
            ),
    );
  }

  void _paintDust(Canvas canvas, Size size) {
    final random = math.Random(41);
    final paint = Paint()..color = AppColors.candle.withValues(alpha: 0.13);
    for (var i = 0; i < 26; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.8;
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 1.1 + 0.3, paint);
    }
  }

  void _paintVignette(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -0.2),
          radius: 0.95,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.18),
            Colors.black.withValues(alpha: 0.58),
          ],
          stops: const [0.45, 0.78, 1.0],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _TavernPainter oldDelegate) {
    return oldDelegate.glow != glow;
  }
}
