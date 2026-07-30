import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:holy_quran/core/theme/app_palette.dart';

/// The eight-pointed star (rub-el-hizb) used to carry surah and ayah numbers.
///
/// It is painted rather than shipped as an asset so it can take any colour and
/// stay crisp at any size.
class StarBadge extends StatelessWidget {
  const StarBadge({
    super.key,
    required this.label,
    this.size = 40,
    this.fill,
    this.foreground,
    this.outlined = false,
  });

  final String label;
  final double size;
  final Color? fill;
  final Color? foreground;

  /// Draws only the outline — used on filled backgrounds like the hero card.
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final fillColor = fill ?? palette.primarySoft;
    final textColor = foreground ?? palette.primary;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _StarPainter(
          color: fillColor,
          outlined: outlined,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size * 0.2),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'InterSemibold',
                  fontSize: size * 0.32,
                  color: textColor,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  const _StarPainter({required this.color, required this.outlined});

  final Color color;
  final bool outlined;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final side = size.shortestSide * 0.74;
    final square = Rect.fromCenter(center: center, width: side, height: side);

    final first = Path()..addRect(square);
    final second = Path()..addRect(square);
    final rotated = second.transform(
      (Matrix4.identity()
            ..translate(center.dx, center.dy, 0)
            ..rotateZ(math.pi / 4)
            ..translate(-center.dx, -center.dy, 0))
          .storage,
    );

    final star = Path.combine(PathOperation.union, first, rotated);

    final paint = Paint()
      ..color = color
      ..isAntiAlias = true;

    if (outlined) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1, size.shortestSide * 0.035)
        ..strokeJoin = StrokeJoin.round;
    }

    canvas.drawPath(star, paint);
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.outlined != outlined;
}
