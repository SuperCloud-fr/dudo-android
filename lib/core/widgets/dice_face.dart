import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A die drawn as a physical object: ivory body, bevelled edge, dark pips.
/// Aces carry a red pip because they are the wild card of the table.
class DiceFace extends StatelessWidget {
  const DiceFace({
    super.key,
    required this.value,
    this.size = 44,
    this.hidden = false,
    this.highlight = false,
    this.dimmed = false,
    this.rotation = 0,
    this.semanticLabel,
  }) : assert(value >= 1 && value <= 6);

  final int value;
  final double size;
  final bool hidden;
  final bool highlight;
  final bool dimmed;
  final double rotation;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final label =
        semanticLabel ??
        (hidden
            ? 'Dé caché'
            : value == 1
            ? 'As, joker'
            : 'Dé de valeur $value');
    return Semantics(
      label: label,
      image: true,
      child: Transform.rotate(
        angle: rotation,
        child: Opacity(
          opacity: dimmed ? 0.34 : 1,
          child: SizedBox.square(
            dimension: size,
            child: CustomPaint(
              painter: _DicePainter(
                value: value,
                hidden: hidden,
                highlight: highlight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DicePainter extends CustomPainter {
  _DicePainter({
    required this.value,
    required this.hidden,
    required this.highlight,
  });

  final int value;
  final bool hidden;
  final bool highlight;

  static const List<Offset> _pips = [
    Offset(0.5, 0.5),
    Offset(0.28, 0.28),
    Offset(0.72, 0.28),
    Offset(0.28, 0.5),
    Offset(0.72, 0.5),
    Offset(0.28, 0.72),
    Offset(0.72, 0.72),
  ];

  static const Map<int, List<int>> _layout = {
    1: [0],
    2: [1, 6],
    3: [1, 0, 6],
    4: [1, 2, 5, 6],
    5: [1, 2, 0, 5, 6],
    6: [1, 2, 3, 4, 5, 6],
  };

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final radius = size.width * 0.2;
    final body = RRect.fromRectAndRadius(
      rect.deflate(size.width * 0.035),
      Radius.circular(radius),
    );

    if (highlight) {
      canvas.drawRRect(
        body.inflate(size.width * 0.035),
        Paint()
          ..color = AppColors.brass.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.09
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.width * 0.06),
      );
    }

    canvas.drawShadow(
      Path()..addRRect(body),
      Colors.black,
      size.width * 0.12,
      false,
    );

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: hidden
            ? const [AppColors.leatherLight, AppColors.leatherDeep]
            : const [AppColors.ivory, AppColors.ivoryShade],
      ).createShader(rect);
    canvas.drawRRect(body, bodyPaint);

    canvas.drawRRect(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1, size.width * 0.03)
        ..color = hidden ? AppColors.brassDim : AppColors.dieEdge,
    );

    final inner = body.deflate(size.width * 0.085);
    canvas.drawRRect(
      inner,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = hidden
            ? AppColors.brass.withValues(alpha: 0.22)
            : Colors.white.withValues(alpha: 0.30),
    );

    if (hidden) {
      _paintCompass(canvas, size);
      return;
    }

    final pipRadius = size.width * (value == 1 ? 0.095 : 0.075);
    for (final index in _layout[value]!) {
      final position = Offset(
        _pips[index].dx * size.width,
        _pips[index].dy * size.height,
      );
      final isAce = value == 1;
      canvas.drawCircle(
        position.translate(0, size.width * 0.012),
        pipRadius,
        Paint()..color = Colors.black.withValues(alpha: 0.13),
      );
      canvas.drawCircle(
        position,
        pipRadius,
        Paint()..color = isAce ? AppColors.ace : AppColors.pip,
      );
      canvas.drawCircle(
        position.translate(-pipRadius * 0.28, -pipRadius * 0.3),
        pipRadius * 0.22,
        Paint()..color = Colors.white.withValues(alpha: 0.22),
      );
    }
  }

  void _paintCompass(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..color = AppColors.brass.withValues(alpha: 0.62);
    final long = size.width * 0.19;
    final short = size.width * 0.10;
    for (var i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final direction = Offset(math.cos(angle), math.sin(angle));
      final side = Offset(-direction.dy, direction.dx);
      final point = Path()
        ..moveTo(
          center.dx + direction.dx * long,
          center.dy + direction.dy * long,
        )
        ..lineTo(
          center.dx + side.dx * short * 0.32,
          center.dy + side.dy * short * 0.32,
        )
        ..lineTo(
          center.dx - side.dx * short * 0.32,
          center.dy - side.dy * short * 0.32,
        )
        ..close();
      canvas.drawPath(point, paint);
    }
    canvas.drawCircle(
      center,
      size.width * 0.045,
      Paint()..color = AppColors.brassBright.withValues(alpha: 0.7),
    );
    canvas.drawCircle(
      center,
      size.width * 0.14,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppColors.brass.withValues(alpha: 0.4),
    );
  }

  @override
  bool shouldRepaint(covariant _DicePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.hidden != hidden ||
        oldDelegate.highlight != highlight;
  }
}
