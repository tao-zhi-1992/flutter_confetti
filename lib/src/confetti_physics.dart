import 'dart:math';
import 'dart:ui';

import 'package:flutter_confetti/src/confetti_options.dart';

class ConfettiPhysics {
  static final Random _rng = Random();

  double wobbleSpeed;
  double velocity;
  double angle2D;
  Color color;
  double decay;
  double drift;
  double gravity;
  double scalar;
  double ovalScalar;
  bool flat;

  int totalTicks;
  int ticket = 0;
  bool get finished => ticket > totalTicks;

  // Simulation state, advanced in fixed steps by [update].
  double _x = 0;
  double _y = 0;
  double _wobble = 0;
  double _tiltAngle = 0;
  double _random = 0;
  double _progress = 0;

  // Simulation state before the latest [update], kept so the render state
  // can be interpolated between two physics steps.
  double _prevX = 0;
  double _prevY = 0;
  double _prevWobble = 0;
  double _prevTiltAngle = 0;
  double _prevRandom = 0;
  double _prevProgress = 0;

  // Render state produced by [interpolate]. This is what particle painters
  // read, so the drawn position can sit between two physics steps.
  double _renderX = 0;
  double _renderY = 0;
  double _renderWobble = 0;
  double _renderRandom = 0;
  double _renderProgress = 0;

  double get x => _renderX;
  set x(double value) {
    _x = value;
    _prevX = value;
    _renderX = value;
  }

  double get y => _renderY;
  set y(double value) {
    _y = value;
    _prevY = value;
    _renderY = value;
  }

  double get wobble => _renderWobble;
  set wobble(double value) {
    _wobble = value;
    _prevWobble = value;
    _renderWobble = value;
  }

  double get tiltAngle => _tiltAngle;
  set tiltAngle(double value) {
    _tiltAngle = value;
    _prevTiltAngle = value;
  }

  double get random => _renderRandom;
  set random(double value) {
    _random = value;
    _prevRandom = value;
    _renderRandom = value;
  }

  double get progress => _renderProgress;
  set progress(double value) {
    _progress = value;
    _prevProgress = value;
    _renderProgress = value;
  }

  double wobbleX;
  double wobbleY;
  double tiltSin;
  double tiltCos;
  double x1 = 0;
  double x2 = 0;
  double y1 = 0;
  double y2 = 0;

  ConfettiPhysics(
      {required double wobble,
      required this.wobbleSpeed,
      required this.velocity,
      required this.angle2D,
      required double tiltAngle,
      required this.color,
      required this.decay,
      required this.drift,
      required double random,
      required this.tiltSin,
      required this.wobbleX,
      required this.wobbleY,
      required this.gravity,
      required this.ovalScalar,
      required this.scalar,
      required this.flat,
      required this.tiltCos,
      required this.totalTicks}) {
    this.wobble = wobble;
    this.tiltAngle = tiltAngle;
    this.random = random;
  }

  factory ConfettiPhysics.fromOptions(
      {required ConfettiOptions options, required Color color}) {
    final radAngle = options.angle * (pi / 180);
    final radSpread = options.spread * (pi / 180);

    return ConfettiPhysics(
        wobble: _rng.nextDouble() * 10,
        wobbleSpeed: min(0.11, _rng.nextDouble() * 0.1 + 0.05),
        velocity: options.startVelocity * 0.5 +
            _rng.nextDouble() * options.startVelocity,
        angle2D:
            -radAngle + (0.5 * radSpread - _rng.nextDouble() * radSpread),
        tiltAngle: (_rng.nextDouble() * (0.75 - 0.25) + 0.25) * pi,
        color: color,
        decay: options.decay,
        drift: options.drift,
        random: _rng.nextDouble() + 2,
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
    _prevX = _x;
    _prevY = _y;
    _prevWobble = _wobble;
    _prevTiltAngle = _tiltAngle;
    _prevRandom = _random;
    _prevProgress = _progress;

    _progress = ticket / totalTicks;
    ticket++;

    _x += cos(angle2D) * velocity + drift;
    _y += sin(angle2D) * velocity + gravity;

    velocity *= decay;

    if (flat) {
      _wobble = 0;
      _random = 1;
    } else {
      _wobble += wobbleSpeed;
      _tiltAngle += 0.1;
      _random = _rng.nextDouble() + 2;
    }

    // Keep the render state usable even if [interpolate] is never called,
    // e.g. when update() is driven directly by user code.
    interpolate(1);
  }

  /// Updates the render state (the fields read by particle painters) to sit
  /// between the previous and the current physics step.
  ///
  /// [alpha] is the fraction of a physics tick that has elapsed since the
  /// last [update]: 0 draws the previous state, 1 draws the current one.
  /// Interpolating removes the temporal aliasing that a fixed-timestep
  /// simulation shows on displays whose refresh rate doesn't line up with
  /// the physics tick rate.
  void interpolate(double alpha) {
    final t = alpha.clamp(0.0, 1.0);

    _renderX = _lerp(_prevX, _x, t);
    _renderY = _lerp(_prevY, _y, t);
    _renderWobble = _lerp(_prevWobble, _wobble, t);
    _renderRandom = _lerp(_prevRandom, _random, t);
    _renderProgress = _lerp(_prevProgress, _progress, t);

    if (flat) {
      wobbleX = _renderX + (10 * scalar);
      wobbleY = _renderY + (10 * scalar);

      tiltSin = 0;
      tiltCos = 0;
    } else {
      wobbleX = _renderX + 10 * scalar * cos(_renderWobble);
      wobbleY = _renderY + 10 * scalar * sin(_renderWobble);

      final tilt = _lerp(_prevTiltAngle, _tiltAngle, t);
      tiltSin = sin(tilt);
      tiltCos = cos(tilt);
    }

    x1 = _renderX + _renderRandom * tiltCos;
    y1 = _renderY + _renderRandom * tiltSin;
    x2 = wobbleX + _renderRandom * tiltCos;
    y2 = wobbleY + _renderRandom * tiltSin;
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  void kill() {
    ticket = totalTicks + 1;
  }
}
