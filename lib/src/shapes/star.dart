import 'dart:math';
import 'dart:ui';

import 'package:flutter_confetti/src/confetti_particle.dart';
import 'package:flutter_confetti/src/confetti_physics.dart';

class Star extends ConfettiParticle {
  final Paint _paint = Paint();
  final Path _path = Path();

  @override
  void paint({
    required ConfettiPhysics physics,
    required Canvas canvas,
  }) {
    canvas.save();

    final innerRadius = 4 * physics.scalar;
    final outerRadius = 8 * physics.scalar;
    double rot = pi / 2 * 3;
    double x = physics.x;
    double y = physics.y;
    int spikes = 5;
    final step = pi / spikes;

    _path.reset();
    _path.moveTo(x, y);

    while (spikes-- >= 0) {
      x = physics.x + cos(rot) * outerRadius;
      y = physics.y + sin(rot) * outerRadius;
      _path.lineTo(x, y);
      rot += step;

      x = physics.x + cos(rot) * innerRadius;
      y = physics.y + sin(rot) * innerRadius;
      _path.lineTo(x, y);
      rot += step;
    }

    _path.close();

    _paint.color = physics.color.withValues(alpha: 1 - physics.progress);

    canvas.drawPath(_path, _paint);

    canvas.restore();
  }
}
