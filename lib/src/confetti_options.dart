import 'package:flutter/material.dart';

const List<Color> defaultColors = [
  Color(0xFF26ccff),
  Color(0xFFa25afd),
  Color(0xFFff5e7e),
  Color(0xFFfcff42),
  Color(0xFFffa62d),
  Color(0xFFff36ff),
];

class ConfettiOptions {
  /// The number of confetti to launch.
  final int particleCount;

  /// The angle in which to launch the confetti, in degrees. 90 is straight up.
  final double angle;

  /// How far off center the confetti can go, in degrees.
  /// 45 means the confetti will launch at the defined angle plus or minus 22.5 degrees.
  final double spread;

  /// How fast the confetti will start going, in pixels.
  final double startVelocity;

  /// How quickly the confetti will lose speed.
  /// Keep this number between 0 and 1, otherwise the confetti will gain speed.
  /// Better yet, just never change it.
  final double decay;

  /// How quickly the particles are pulled down.
  /// 1 is full gravity, 0.5 is half gravity, etc.,
  /// but there are no limits. You can even make particles go up if you'd like.
  final double gravity;

  /// How much to the side the confetti will drift.
  /// The default is 0, meaning that they will fall straight down.
  /// Use a negative number for left and positive number for right.
  final double drift;

  ///  Optionally turns off the tilt and wobble that three dimensional confetti
  /// would have in the real world.
  final bool flat;

  /// How many times the confetti will move.
  final int ticks;

  /// The x position on the page,
  /// with 0 being the left edge and 1 being the right edge.
  final double x;

  /// The y position on the page,
  /// with 0 being the top edge and 1 being the bottom edge.
  final double y;

  /// An array of color strings.
  final List<Color> colors;

  /// Scale factor for each confetti particle.
  /// Use decimals to make the confetti smaller.
  final double scalar;

  /// If true, each particle's horizontal spawn position is randomized across
  /// the container width instead of using [x]. Useful for snowfall and similar
  /// effects where particles should appear along the top of the screen.
  final bool randomX;

  /// How much each particle's [drift] may vary. The actual drift applied to a
  /// particle is `drift + random(-driftVariance, driftVariance)`.
  final double driftVariance;

  const ConfettiOptions(
      {this.colors = defaultColors,
      this.particleCount = 50,
      this.angle = 90,
      this.spread = 45,
      this.startVelocity = 45,
      this.decay = 0.9,
      this.gravity = 1,
      this.drift = 0,
      this.flat = false,
      this.scalar = 1,
      this.x = 0.5,
      this.y = 0.5,
      this.ticks = 200,
      this.randomX = false,
      this.driftVariance = 0})
      : assert(decay >= 0 && decay <= 1),
        assert(ticks > 0),
        assert(driftVariance >= 0);

  /// Create a copy of this object with the given fields replaced with new values.
  ConfettiOptions copyWith({
    int? particleCount,
    double? angle,
    double? spread,
    double? startVelocity,
    double? decay,
    double? gravity,
    double? drift,
    bool? flat,
    double? scalar,
    double? x,
    double? y,
    int? ticks,
    List<Color>? colors,
    bool? randomX,
    double? driftVariance,
  }) {
    return ConfettiOptions(
      particleCount: particleCount ?? this.particleCount,
      angle: angle ?? this.angle,
      spread: spread ?? this.spread,
      startVelocity: startVelocity ?? this.startVelocity,
      decay: decay ?? this.decay,
      gravity: gravity ?? this.gravity,
      drift: drift ?? this.drift,
      flat: flat ?? this.flat,
      scalar: scalar ?? this.scalar,
      x: x ?? this.x,
      y: y ?? this.y,
      ticks: ticks ?? this.ticks,
      colors: colors ?? this.colors,
      randomX: randomX ?? this.randomX,
      driftVariance: driftVariance ?? this.driftVariance,
    );
  }
}
