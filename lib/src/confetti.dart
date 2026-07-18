import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
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

  /// If true, the confetti will use a timer to schedule the confetti, it is useful when you want to keep the
  /// speed of the confetti constant on every device with different  refresh rates.
  final bool enableCustomScheduler;

  const Confetti(
      {super.key,
      this.options,
      this.particleBuilder,
      required this.controller,
      this.onFinished,
      this.instant = false,
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
  /// [enableCustomScheduler] is a flag that indicates whether to use a custom scheduler. If true,
  /// the confetti will use a timer to schedule the confetti, it is useful when you want to keep the
  /// speed of the confetti constant on every device with different  refresh rates.
  static ConfettiController launch(
    BuildContext context, {
    required ConfettiOptions options,
    ParticleBuilder? particleBuilder,
    void Function(OverlayEntry overlayEntry)? insertInOverlay,
    void Function(OverlayEntry overlayEntry)? onFinished,
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
              enableCustomScheduler: enableCustomScheduler,
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

  bool get enableCustomScheduler => widget.enableCustomScheduler == true;

  List<Glue> glueList = [];

  late AnimationController animationController;

  late Timer? timer;
  static const frameDuration = Duration(milliseconds: 16);

  late double containerWidth;
  late double containerHeight;

  int randomInt(int min, int max) {
    return Random().nextInt(max - min) + min;
  }

  void addParticles() {
    final colors = options.colors;
    final colorsCount = colors.length;

    final particleBuilder = widget.particleBuilder != null
        ? widget.particleBuilder!
        : (int index) => [Circle(), Square()][randomInt(0, 2)];

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

  void initScheduler() {
    void schedule() {
      final finished = !glueList.any((element) => !element.physics.finished);

      if (finished) {
        if (enableCustomScheduler) {
          timer?.cancel();
        } else {
          animationController.stop();
        }

        if (widget.onFinished != null) {
          widget.onFinished!();
        }
      }
    }

    if (enableCustomScheduler) {
      timer = Timer.periodic(frameDuration, (_) {
        schedule();

        setState(() {}); // refresh the screen
      });
    } else {
      animationController = AnimationController(
          vsync: this, duration: const Duration(seconds: 1));

      animationController.addListener(() {
        schedule();
      });
    }
  }

  void play() {
    if (enableCustomScheduler) {
      if (timer == null || !timer!.isActive) {
        initScheduler();
      }
    } else {
      if (animationController.isAnimating == false) {
        animationController.repeat();
      }
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

    initScheduler();

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
    if (enableCustomScheduler) {
      timer?.cancel();
    } else {
      animationController.dispose();
    }

    Launcher.unload(widget.controller);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      containerWidth = constraints.maxWidth;
      containerHeight = constraints.maxHeight;

      return CustomPaint(
        willChange: true,
        painter: Painter(
            glueList: glueList,
            animationController:
                enableCustomScheduler ? null : animationController),
        child: const SizedBox.expand(),
      );
    });
  }
}
