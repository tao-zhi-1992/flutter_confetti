import 'dart:ui';

import 'package:flutter_confetti/src/confetti_particle.dart';
import 'package:flutter_confetti/src/confetti_physics.dart';

class Triangle extends ConfettiParticle {
  @override
  void paint({
    required ConfettiPhysics physics,
    required Canvas canvas,
  }) {
    canvas.save();

    final path = Path()
      ..moveTo(physics.x.floor().toDouble(), physics.y.floor().toDouble())
      ..lineTo(physics.wobbleX.ceil().toDouble(), physics.y1.floor().toDouble())
      ..lineTo(physics.x2.floor().toDouble(), physics.wobbleY.ceil().toDouble())
      ..close();

    final paint = Paint()
      ..color = physics.color.withValues(alpha: 1 - physics.progress);

    canvas.drawPath(path, paint);

    canvas.restore();
  }
}
