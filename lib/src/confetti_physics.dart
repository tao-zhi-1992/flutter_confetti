import 'dart:math';
import 'dart:ui';

import 'package:flutter_confetti/src/confetti_options.dart';

class ConfettiPhysics {
  static final Random _random = Random();

  double wobble;
  double wobbleSpeed;
  double velocity;
  double angle2D;
  double tiltAngle;
  Color color;
  double decay;
  double drift;
  double gravity;
  double scalar;
  double ovalScalar;
  double wobbleX;
  double wobbleY;
  double tiltSin;
  double tiltCos;
  double random;
  bool flat;

  int totalTicks;
  int ticket = 0;
  double progress = 0;
  bool get finished => ticket > totalTicks;

  double x = 0;
  double y = 0;
  double x1 = 0;
  double x2 = 0;
  double y1 = 0;
  double y2 = 0;

  ConfettiPhysics(
      {required this.wobble,
      required this.wobbleSpeed,
      required this.velocity,
      required this.angle2D,
      required this.tiltAngle,
      required this.color,
      required this.decay,
      required this.drift,
      required this.random,
      required this.tiltSin,
      required this.wobbleX,
      required this.wobbleY,
      required this.gravity,
      required this.ovalScalar,
      required this.scalar,
      required this.flat,
      required this.tiltCos,
      required this.totalTicks});

  factory ConfettiPhysics.fromOptions(
      {required ConfettiOptions options, required Color color}) {
    final radAngle = options.angle * (pi / 180);
    final radSpread = options.spread * (pi / 180);

    return ConfettiPhysics(
        wobble: _random.nextDouble() * 10,
        wobbleSpeed: min(0.11, _random.nextDouble() * 0.1 + 0.05),
        velocity: options.startVelocity * 0.5 +
            _random.nextDouble() * options.startVelocity,
        angle2D:
            -radAngle + (0.5 * radSpread - _random.nextDouble() * radSpread),
        tiltAngle: (_random.nextDouble() * (0.75 - 0.25) + 0.25) * pi,
        color: color,
        decay: options.decay,
        drift: options.drift,
        random: _random.nextDouble() + 2,
        tiltSin: 0,
        tiltCos: 0,
        wobbleX: 0,
        wobbleY: 0,
        gravity: options.gravity * 3,
        ovalScalar: 0.6,
        scalar: options.scalar,
        flat: options.flat,
        totalTicks: options.ticks);
  }

  void update() {
    progress = ticket / totalTicks;
    ticket++;

    x += cos(angle2D) * velocity + drift;
    y += sin(angle2D) * velocity + gravity;

    velocity *= decay;

    if (flat) {
      wobble = 0;
      wobbleX = x + (10 * scalar);
      wobbleY = y + (10 * scalar);

      tiltSin = 0;
      tiltCos = 0;
      random = 1;
    } else {
      wobble += wobbleSpeed;
      wobbleX = x + 10 * scalar * cos(wobble);
      wobbleY = y + 10 * scalar * sin(wobble);

      tiltAngle += 0.1;
      tiltSin = sin(tiltAngle);
      tiltCos = cos(tiltAngle);
      random = _random.nextDouble() + 2;
    }

    x1 = x + random * tiltCos;
    y1 = y + random * tiltSin;
    x2 = wobbleX + random * tiltCos;
    y2 = wobbleY + random * tiltSin;
  }

  void kill() {
    ticket = totalTicks + 1;
  }
}
