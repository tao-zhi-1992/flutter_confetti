import 'dart:ui';

import 'package:flutter_confetti/src/confetti_particle.dart';
import 'package:flutter_confetti/src/confetti_physics.dart';

class Square extends ConfettiParticle {
  @override
  void paint({
    required ConfettiPhysics physics,
    required Canvas canvas,
  }) {
    canvas.save();

    final path = Path()
      ..moveTo(physics.x.floor().toDouble(), physics.y.floor().toDouble());
    path.lineTo(physics.wobbleX, physics.y1.floor().toDouble());
    path.lineTo(physics.x2.floor().toDouble(), physics.y2.floor().toDouble());
    path.lineTo(
        physics.x1.floor().toDouble(), physics.wobbleY.floor().toDouble());

    path.close();

    final paint = Paint()
      ..color = physics.color.withValues(alpha: 1 - physics.progress);

    canvas.drawPath(path, paint);

    canvas.restore();
  }
}
