import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// The leather cup used in the peek ritual. Drawn rather than photographed so
/// it shares the same material language as the rest of the table.
class LeatherCup extends StatelessWidget {
  const LeatherCup({super.key, this.size = 168});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Gobelet en cuir',
      child: SizedBox(
        width: size,
        height: size * 1.06,
        child: CustomPaint(painter: _CupPainter()),
      ),
    );
  }
}

class _CupPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final topY = h * 0.12;
    final bottomY = h * 0.88;
    final topW = w * 0.72;
    final bottomW = w * 0.54;

    final body = Path()
      ..moveTo(cx - topW / 2, topY)
      ..quadraticBezierTo(
        cx - topW * 0.46,
        h * 0.58,
        cx - bottomW / 2,
        bottomY - h * 0.05,
      )
      ..quadraticBezierTo(
        cx,
        bottomY + h * 0.035,
        cx + bottomW / 2,
        bottomY - h * 0.05,
      )
      ..quadraticBezierTo(cx + topW * 0.46, h * 0.58, cx + topW / 2, topY)
      ..close();

    canvas.drawShadow(body, Colors.black, w * 0.10, false);

    // Handle, drawn behind the body.
    final handle = Path()
      ..moveTo(cx + topW * 0.43, h * 0.34)
      ..cubicTo(
        w * 0.99,
        h * 0.30,
        w * 0.99,
        h * 0.69,
        cx + topW * 0.28,
        h * 0.70,
      );
    canvas.drawPath(
      handle,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = w * 0.075
        ..color = AppColors.leatherDeep,
    );
    canvas.drawPath(
      handle,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = w * 0.028
        ..color = AppColors.brassDim.withValues(alpha: 0.65),
    );

    canvas.drawPath(
      body,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.leatherLight,
            AppColors.leather,
            AppColors.leatherDeep,
          ],
          stops: [0.0, 0.48, 1.0],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = AppColors.brassDim.withValues(alpha: 0.85),
    );

    // Gold bands, following the taper.
    _drawBand(canvas, cx, h * 0.30, w * 0.60, w * 0.026);
    _drawBand(canvas, cx, h * 0.72, w * 0.51, w * 0.020);

    // Top rim.
    final rimRect = Rect.fromCenter(
      center: Offset(cx, topY + 2),
      width: topW,
      height: h * 0.085,
    );
    canvas.drawOval(rimRect, Paint()..color = AppColors.leatherDeep);
    canvas.drawOval(
      rimRect.deflate(2),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0B0705), Color(0xFF3E281B)],
        ).createShader(rimRect),
    );
    canvas.drawOval(
      rimRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..color = AppColors.brass,
    );

    // Embossed seal on the belly.
    final sealCenter = Offset(cx, h * 0.48);
    canvas.drawCircle(
      sealCenter,
      w * 0.10,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = AppColors.brass.withValues(alpha: 0.42),
    );
    final text = TextPainter(
      text: TextSpan(
        text: 'D',
        style: AppTypography.inscription(
          size: w * 0.11,
          color: AppColors.brass.withValues(alpha: 0.55),
          letterSpacing: 0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, sealCenter - Offset(text.width / 2, text.height / 2));

    // Rivets on the top band.
    for (final dx in [-0.22, 0.0, 0.22]) {
      canvas.drawCircle(
        Offset(cx + w * dx, h * 0.30),
        w * 0.012,
        Paint()..color = AppColors.brassBright.withValues(alpha: 0.75),
      );
    }

    // Soft highlight on the left cheek.
    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white.withValues(alpha: 0.07),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.16),
          ],
          stops: const [0.0, 0.42, 1.0],
        ).createShader(Offset.zero & size),
    );
  }

  void _drawBand(
    Canvas canvas,
    double cx,
    double y,
    double width,
    double stroke,
  ) {
    final path = Path()
      ..moveTo(cx - width / 2, y)
      ..quadraticBezierTo(cx, y + 6, cx + width / 2, y);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = AppColors.brass.withValues(alpha: 0.72),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// The felt table seen from above, with a stitched rim and brass studs.
class TableSurface extends StatelessWidget {
  const TableSurface({super.key});

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(painter: _TablePainter(), size: Size.infinite),
      ),
    );
  }
}

class _TablePainter extends CustomPainter {
  const _TablePainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final outer = Rect.fromLTWH(4, 4, size.width - 8, size.height - 8);
    final inner = outer.deflate(math.min(size.width, size.height) * 0.055);

    final rim = Path()..addOval(outer);
    canvas.drawShadow(rim, Colors.black, 18, false);
    canvas.drawOval(
      outer,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.leatherLight, AppColors.leatherDeep],
        ).createShader(outer),
    );
    canvas.drawOval(
      outer,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.brassDim.withValues(alpha: 0.65),
    );

    canvas.drawOval(
      inner,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.15, -0.3),
          radius: 0.95,
          colors: const [
            AppColors.feltLight,
            AppColors.felt,
            AppColors.feltDeep,
          ],
          stops: const [0.0, 0.62, 1.0],
        ).createShader(inner),
    );
    canvas.drawOval(
      inner,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.black.withValues(alpha: 0.28),
    );

    // Stitched rim.
    final stitchPath = Path()..addOval(inner.deflate(9));
    final stitchPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..color = AppColors.brass.withValues(alpha: 0.36);
    for (final metric in stitchPath.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + 6),
          stitchPaint,
        );
        distance += 13;
      }
    }

    // Brass studs around the rim.
    final center = outer.center;
    final radiusX = outer.width / 2 - 1;
    final radiusY = outer.height / 2 - 1;
    for (var i = 0; i < 10; i++) {
      final angle = i * math.pi * 2 / 10;
      final point = Offset(
        center.dx + math.cos(angle) * radiusX,
        center.dy + math.sin(angle) * radiusY,
      );
      canvas.drawCircle(
        point,
        math.min(size.width, size.height) * 0.008 + 1.2,
        Paint()..color = AppColors.brass.withValues(alpha: 0.55),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
