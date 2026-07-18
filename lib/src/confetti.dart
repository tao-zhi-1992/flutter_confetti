import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_confetti/src/confetti_controller.dart';
import 'package:flutter_confetti/src/confetti_options.dart';
import 'package:flutter_confetti/src/confetti_physics.dart';
import 'package:flutter_confetti/src/shapes/square.dart';
import 'package:flutter_confetti/src/utils/glue.dart';
import 'package:flutter_confetti/src/utils/launcher.dart';
import 'package:flutter_confetti/src/utils/launcher_config.dart';
import 'package:flutter_confetti/src/utils/painter.dart';
import 'package:flutter_confetti/src/confetti_particle.dart';
import 'package:flutter_confetti/src/shapes/circle.dart';

typedef ParticleBuilder = ConfettiParticle Function(int index);

class Confetti extends StatefulWidget {
  /// The options used to launch the confetti.
  final ConfettiOptions? options;

  /// A builder that creates the particles.
  /// if you don't provide one, a default one will be used.
  /// the default particles are circles and squares.
  final ParticleBuilder? particleBuilder;

  /// The controller of the confetti.
  /// in general, you don't need to provide one.
  final ConfettiController controller;

  /// A callback that will be called when the confetti finished its animation.
  final void Function()? onFinished;

  /// if true, the confetti will be launched instantly as soon as it is created.
  /// the default value is false.
  final bool instant;

  /// The confetti speed is now frame-rate independent by default, so this
  /// flag is no longer needed and has no effect.
  @Deprecated('The confetti speed is frame-rate independent now, '
      'so this flag is no longer needed and has no effect.')
  final bool enableCustomScheduler;

  const Confetti(
      {super.key,
      this.options,
      this.particleBuilder,
      required this.controller,
      this.onFinished,
      this.instant = false,
      @Deprecated('The confetti speed is frame-rate independent now, '
          'so this flag is no longer needed and has no effect.')
      this.enableCustomScheduler = false});

  @override
  State<Confetti> createState() => _ConfettiState();

  /// A quick way to launch the confetti.
  /// Notice: If your APP is not using the MaterialApp as the root widget,
  /// you can't use this method. Instead, you should use the Confetti widget directly.
  /// [context] is the context of the APP.
  /// [options] is the options used to launch the confetti.
  /// [particleBuilder] is the builder that creates the particles. if you don't
  /// provide one, a default one will be used.The default particles are circles and squares..
  /// [onFinished] is a callback that will be called when the confetti finished its animation.
  /// [insertInOverlay] is a callback that will be called to insert the confetti into the overlay.
  static ConfettiController launch(
    BuildContext context, {
    required ConfettiOptions options,
    ParticleBuilder? particleBuilder,
    void Function(OverlayEntry overlayEntry)? insertInOverlay,
    void Function(OverlayEntry overlayEntry)? onFinished,
    @Deprecated('The confetti speed is frame-rate independent now, '
        'so this flag is no longer needed and has no effect.')
    bool enableCustomScheduler = false,
  }) {
    OverlayEntry? overlayEntry;
    final controller = ConfettiController();

    overlayEntry = OverlayEntry(
        builder: (BuildContext ctx) {
          final height = MediaQuery.of(ctx).size.height;
          final width = MediaQuery.of(ctx).size.width;

          return Positioned(
            left: width * options.x,
            top: height * options.y,
            width: 2,
            height: 2,
            child: Confetti(
              controller: controller,
              options: options.copyWith(x: 0.5, y: 0.5),
              particleBuilder: particleBuilder,
              onFinished: () {
                if (onFinished != null) {
                  onFinished(overlayEntry!);
                } else {
                  overlayEntry?.remove();
                }
              },
              instant: true,
            ),
          );
        },
        opaque: false);

    if (insertInOverlay != null) {
      insertInOverlay(overlayEntry);
    } else {
      Overlay.of(context).insert(overlayEntry);
    }

    return controller;
  }
}

class _ConfettiState extends State<Confetti>
    with SingleTickerProviderStateMixin {
  ConfettiOptions get options {
    return widget.options ?? const ConfettiOptions();
  }

  List<Glue> glueList = [];

  late final Ticker ticker;

  /// The physics simulation always runs at 60 ticks per second, no matter
  /// what the display refresh rate is, so the confetti speed is the same
  /// on every device.
  static const physicsTick = Duration(microseconds: 16667);

  Duration lastElapsed = Duration.zero;
  Duration accumulator = Duration.zero;

  /// Bumped after every physics update to trigger a repaint of the painter.
  final repaint = ValueNotifier<int>(0);

  late double containerWidth;
  late double containerHeight;

  static final Random _random = Random();

  int randomInt(int min, int max) {
    return _random.nextInt(max - min) + min;
  }

  void addParticles() {
    final colors = options.colors;
    final colorsCount = colors.length;

    final particleBuilder = widget.particleBuilder != null
        ? widget.particleBuilder!
        : (int index) => randomInt(0, 2) == 0 ? Circle() : Square();

    double x = options.x * containerWidth;
    double y = options.y * containerHeight;

    for (int i = 0; i < options.particleCount; i++) {
      final color = colors[i % colorsCount];
      final physic = ConfettiPhysics.fromOptions(options: options, color: color)
        ..x = x
        ..y = y;

      final glue = Glue(particle: particleBuilder(i), physics: physic);

      glueList.add(glue);
    }
  }

  void onTick(Duration elapsed) {
    Duration delta = elapsed - lastElapsed;
    lastElapsed = elapsed;

    // Avoid a burst of updates after the ticker was muted for a while,
    // e.g. when the app was in the background.
    if (delta > const Duration(milliseconds: 100)) {
      delta = physicsTick;
    }

    accumulator += delta;

    bool updated = false;

    while (accumulator >= physicsTick) {
      accumulator -= physicsTick;

      for (final glue in glueList) {
        if (!glue.physics.finished) {
          glue.physics.update();
        }
      }

      updated = true;
    }

    // On displays faster than 60Hz some frames don't run a physics step,
    // so there is nothing new to draw and no need to repaint.
    if (!updated) {
      return;
    }

    glueList.removeWhere((glue) => glue.physics.finished);

    if (glueList.isEmpty) {
      ticker.stop();

      if (widget.onFinished != null) {
        widget.onFinished!();
      }
    }

    repaint.value++;
  }

  void play() {
    if (!ticker.isActive) {
      lastElapsed = Duration.zero;
      accumulator = Duration.zero;
      ticker.start();
    }
  }

  void launch() {
    addParticles();
    play();
  }

  void kill() {
    for (var glue in glueList) {
      glue.physics.kill();
    }
  }

  @override
  void initState() {
    super.initState();

    ticker = createTicker(onTick);

    if (widget.instant) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          launch();
        },
      );
    }

    Launcher.load(
        widget.controller, LauncherConfig(onLaunch: launch, onKill: kill));
  }

  @override
  void didUpdateWidget(covariant Confetti oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      Launcher.unload(oldWidget.controller);
      Launcher.load(
          widget.controller, LauncherConfig(onLaunch: launch, onKill: kill));
    }
  }

  @override
  void dispose() {
    ticker.dispose();
    repaint.dispose();

    Launcher.unload(widget.controller);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      containerWidth = constraints.maxWidth;
      containerHeight = constraints.maxHeight;

      // The confetti repaints on every physics tick; the boundary keeps
      // those repaints isolated from the rest of the tree.
      return RepaintBoundary(
        child: CustomPaint(
          willChange: true,
          painter: Painter(glueList: glueList, repaint: repaint),
          child: const SizedBox.expand(),
        ),
      );
    });
  }
}
