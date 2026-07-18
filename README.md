# 🎉 Flutter Confetti 🎉

Easily create confetti animations in Flutter.

[Live web demo](https://tao-zhi-1992.github.io/flutter_confetti/)

## Features

- easy to use.
- frame-rate independent: the confetti moves at the same speed on every device, including high refresh rate (e.g. 120Hz) screens.
- various out-of-the-box shapes: star, circle, square, triangle, emoji, snowflake.
- many examples demonstrating different confetti animations.
- easy to create your own custom shapes.

## Getting started

Import the package

```dart
import 'package:flutter_confetti/flutter_confetti.dart';
```

Launch confetti by using the static method `Confetti.launch`:

```dart
Confetti.launch(
  context,
  options: const ConfettiOptions(
      particleCount: 100, spread: 70, y: 0.6)
);
```

## API

### `Confetti.launch`

A quick way to launch the confetti. This method depends on `Overlay`, so it only works when your app uses `MaterialApp`, `CupertinoApp`, or `WidgetsApp` as the root widget. If that's not the case, use the `Confetti` widget directly instead.

### `ConfettiOptions`

Below is a description of each property:

```dart
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
        assert(ticks > 0);
}
```

### `particleBuilder`

The type of `particleBuilder` is `typedef ParticleBuilder = ConfettiParticle Function(int index);`

The default builder creates circles and squares.

You can also provide your own builder, for example one that returns a `Star`:

```dart
 Confetti.launch(context,
  ///...

  particleBuilder: (index) => Star()

  ///...
 );
```

The built-in shapes are `Circle`, `Square`, `Triangle`, `Emoji`, `Star` and `Snowflake`. You can also create your own shape by extending the `ConfettiParticle` class, like the `Circle` class below:

```dart
/// 1. Extend ConfettiParticle
class Circle extends ConfettiParticle {

  /// 2. Override paint
  @override
  void paint({
    /// The physics instance stores the particle's properties,
    /// such as its position, color, and so on.
    required ConfettiPhysics physics,
    required Canvas canvas,
  }) {
    /// 3. Paint your shape here

    canvas.save();

    canvas.translate(physics.x, physics.y);
    canvas.rotate(pi / 10 * physics.wobble);
    canvas.scale(
      (physics.x2 - physics.x1).abs() * physics.ovalScalar,
      (physics.y2 - physics.y1).abs() * physics.ovalScalar,
    );

    final paint = Paint()
      ..color = physics.color.withValues(alpha: 1 - physics.progress);

    canvas.drawArc(Rect.fromCircle(center: const Offset(0, 0), radius: 1), 0,
        2 * pi, true, paint);

    canvas.restore();
  }
}
```

Once you've created your shape, you can use it in the `particleBuilder`.

### `ConfettiController`

Use the methods on the controller instance to control the confetti:

- `controller.launch()`: launch the confetti.
- `controller.kill()`: kill the currently showing confetti.

## How to use emoji

If the system emoji is all you need, you can use the `Emoji` class directly:

```dart
Confetti.launch(context,
    /// ...
    particleBuilder: (index) => Emoji(
        emoji: '🍄'));
```

Or you can use it with the `google_fonts` package:

```dart
import 'package:google_fonts/google_fonts.dart';

Confetti.launch(context,
    /// ...
    particleBuilder: (index) => Emoji(
        emoji: '🍄',
        textStyle: GoogleFonts.notoColorEmoji()));
```

Or use any emoji font you like:

1. Download the font and add it to your pubspec.yaml.

```yaml
flutter:
  fonts:
    - family: NotoEmoji
      fonts:
        - asset: fonts/NotoColorEmoji-Regular.ttf
          weight: 400
```

2. Then use it in the `TextStyle`:

```dart
Confetti.launch(context,
    /// ...
    particleBuilder: (index) => Emoji(
        emoji: '🍄',
        textStyle: TextStyle(
          fontSize: 18, fontFamily: 'NotoEmoji')));
```

## Thanks

This package was totally inspired by [canvas-confetti](https://github.com/catdad/canvas-confetti), a wonderful confetti animation library for the browser.
I just did a little work to bring it to Flutter.
