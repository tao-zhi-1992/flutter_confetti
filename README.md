# 🎉 Flutter Confetti 🎉

Easily make confetti animation in Flutter.

[Live web demo](https://tao-zhi-1992.github.io/flutter_confetti/)

## Features

- easy to use.
- various out-of-the-box shapes: star, circle, square, triangle, emoji.
- many examples that demonstrated the different confetti animation.
- easy to make shapes you want.

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

### `ConfettiController Confetti.launch(BuildContext context, {required ConfettiOptions options, ParticleBuilder? particleBuilder})`

A quick way to launch the confetti. can't use the method without the MaterialApp, CupertinoApp, or WidgetsApp as the root widget. Because the method depend on the Overlay, but you can use the Confetti widget directly.

### `ConfettiOptions`

Below is the description of the properties:

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
      this.ticks = 200})
      : assert(decay >= 0 && decay <= 1),
        assert(ticks > 0);
}
```

### `particleBuilder`

The `particleBuilder`'s type is `typedef ParticleBuilder = ConfettiParticle Function(int index);`

The default builder will create circles and squares.

Or you can create your own builder, such as return the Star like below:

```dart
 Confetti.launch(context,
  ///...

  particleBuilder: (index) => Star()

  ///...
 );
```

Up to now there are those shapes: Circle, Square, Triangle, Emoji and Star, and you can create a shape by inheriting the ConfettiParticle class, like the Circle class below:

```dart
/// 1. Inherit from ConfettiParticle
class Circle extends ConfettiParticle {

  /// 2. Override paint
  @override
  void paint({
    /// The physics instance stored all the properties about the position, color, and so on of the particle.
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
      ..color = physics.color.withOpacity(1 - physics.progress);

    canvas.drawArc(Rect.fromCircle(center: const Offset(0, 0), radius: 1), 0,
        2 * pi, true, paint);

    canvas.restore();
  }
}
```

As soon as you have created your shape, you can use it in the `particleBuilder`.

### `ConfettiController`

Using the methods of the controller instance to control the confetti:

- `controller.launch()`, launch the confetti.
- `controller.kill()`, kill the showing confetti.

## How to use emoji

If you just want to use system emoji, you can use the `Emoji` class directly:

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

Or use any emoji fonts you want:

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

The package was totally inspired by [canvas-confetti](https://github.com/catdad/canvas-confetti), a wonderful confetti animation in the browser,
I just do a little work to make it work in flutter.
