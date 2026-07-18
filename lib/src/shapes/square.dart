import 'dart:ui';

import 'package:flutter_confetti/src/confetti_particle.dart';
import 'package:flutter_confetti/src/confetti_physics.dart';

class Square extends ConfettiParticle {
  final Paint _paint = Paint();
  final Path _path = Path();

  @override
  void paint({
    required ConfettiPhysics physics,
    required Canvas canvas,
  }) {
    canvas.save();

    _path.reset();
    _path.moveTo(physics.x.floor().toDouble(), physics.y.floor().toDouble());
    _path.lineTo(physics.wobbleX, physics.y1.floor().toDouble());
    _path.lineTo(physics.x2.floor().toDouble(), physics.y2.floor().toDouble());
    _path.lineTo(
        physics.x1.floor().toDouble(), physics.wobbleY.floor().toDouble());

    _path.close();

    _paint.color = physics.color.withValues(alpha: 1 - physics.progress);

    canvas.drawPath(_path, _paint);

    canvas.restore();
  }
}
