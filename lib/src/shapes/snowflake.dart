import 'dart:math';
import 'dart:ui';

import 'package:flutter_confetti/src/confetti_particle.dart';
import 'package:flutter_confetti/src/confetti_physics.dart';

/// A six-armed snowflake drawn with stroked lines.
class Snowflake extends ConfettiParticle {
  final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint({
    required ConfettiPhysics physics,
    required Canvas canvas,
  }) {
    canvas.save();

    canvas.translate(physics.x, physics.y);
    canvas.rotate(physics.wobble);
    canvas.scale(physics.scalar, physics.scalar);

    _paint
      ..color = physics.color.withValues(alpha: 1 - physics.progress)
      ..strokeWidth = 1.2;

    const arms = 6;
    const radius = 6.0;
    const branch = 2.5;
    const branchOffset = 3.5;

    for (int i = 0; i < arms; i++) {
      final angle = i * pi / 3;
      final dx = cos(angle);
      final dy = sin(angle);

      canvas.drawLine(Offset.zero, Offset(dx * radius, dy * radius), _paint);

      // Two side branches on each arm.
      final bx = dx * branchOffset;
      final by = dy * branchOffset;
      final perpX = -dy;
      final perpY = dx;

      canvas.drawLine(
        Offset(bx, by),
        Offset(bx + dx * branch * 0.3 + perpX * branch, by + dy * branch * 0.3 + perpY * branch),
        _paint,
      );
      canvas.drawLine(
        Offset(bx, by),
        Offset(bx + dx * branch * 0.3 - perpX * branch, by + dy * branch * 0.3 - perpY * branch),
        _paint,
      );
    }

    canvas.restore();
  }
}
