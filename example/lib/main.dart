import 'dart:async';
import 'dart:math';

import 'package:example/code_block.dart';
import 'package:example/confetti_backdrop.dart';
import 'package:example/demo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

late final Highlighter _dartDarkHighlighter;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Highlighter.initialize(['dart']);

  final darkTheme = await HighlighterTheme.loadDarkTheme();
  _dartDarkHighlighter = Highlighter(
    language: 'dart',
    theme: darkTheme,
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final controller = ConfettiController();
  List<ConfettiController> killableControllerList = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Confetti',
      debugShowCheckedModeBanner: false,
      theme: buildDemoTheme(),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: DemoColors.canvas,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width >= 1100
                    ? 3
                    : width >= 720
                        ? 2
                        : 1;
                const gap = 16.0;
                final itemWidth =
                    (width - 40 - gap * (crossAxisCount - 1)) / crossAxisCount;

                return Stack(
                  children: [
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 280,
                      child: ConfettiBackdrop(),
                    ),
                    CustomScrollView(
                      slivers: [
                        const SliverToBoxAdapter(child: _Header()),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: gap,
                              mainAxisSpacing: gap,
                              childAspectRatio: itemWidth / 320,
                            ),
                            delegate: SliverChildListDelegate(
                              _demoCards(context),
                              addAutomaticKeepAlives: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _demoCards(BuildContext context) {
    return [
      CodeBlock(
        buttonText: 'Basic Cannon',
        highlighter: _dartDarkHighlighter,
        stageHold: const Duration(seconds: 4),
        onTap: () {
          ///BEGIN
          Confetti.launch(
            context,
            options: const ConfettiOptions(
                particleCount: 100,
                spread: 70,
                y: 0.6),
          );

          ///END
        },
      ),
      CodeBlock(
        buttonText: 'Random Direction',
        highlighter: _dartDarkHighlighter,
        stageHold: const Duration(seconds: 4),
        onTap: () {
          ///BEGIN
          double randomInRange(double min, double max) {
            return min +
                Random().nextDouble() * (max - min);
          }

          Confetti.launch(
            context,
            options: ConfettiOptions(
                angle: randomInRange(55, 125),
                spread: randomInRange(50, 70),
                particleCount:
                    randomInRange(50, 100).toInt(),
                y: 0.6),
          );

          ///END
        },
      ),
      CodeBlock(
        buttonText: 'Fireworks',
        highlighter: _dartDarkHighlighter,
        stageHold: const Duration(seconds: 16),
        onTap: () {
          ///BEGIN
          double randomInRange(double min, double max) {
            return min +
                Random().nextDouble() * (max - min);
          }

          int total = 60;
          int progress = 0;

          Timer.periodic(
              const Duration(milliseconds: 250),
              (timer) {
            progress++;

            if (progress >= total) {
              timer.cancel();
              return;
            }

            int count =
                ((1 - progress / total) * 50).toInt();

            Confetti.launch(
              context,
              options: ConfettiOptions(
                  particleCount: count,
                  startVelocity: 30,
                  spread: 360,
                  ticks: 60,
                  x: randomInRange(0.1, 0.3),
                  y: Random().nextDouble() - 0.2),
            );
            Confetti.launch(
              context,
              options: ConfettiOptions(
                  particleCount: count,
                  startVelocity: 30,
                  spread: 360,
                  ticks: 60,
                  x: randomInRange(0.7, 0.9),
                  y: Random().nextDouble() - 0.2),
            );
          });

          ///END
        },
      ),
      CodeBlock(
        buttonText: 'Stars',
        highlighter: _dartDarkHighlighter,
        stageHold: const Duration(seconds: 4),
        onTap: () {
          ///BEGIN

          const options = ConfettiOptions(
              spread: 360,
              ticks: 50,
              gravity: 0,
              decay: 0.94,
              startVelocity: 30,
              colors: [
                Color(0xffFFE400),
                Color(0xffFFBD00),
                Color(0xffE89400),
                Color(0xffFFCA6C),
                Color(0xffFDFFB8)
              ]);

          shoot() {
            Confetti.launch(context,
                options: options.copyWith(
                    particleCount: 40, scalar: 1.2),
                particleBuilder: (index) => Star());
            Confetti.launch(context,
                options: options.copyWith(
                  particleCount: 10,
                  scalar: 0.75,
                ),
                particleBuilder: (index) => Star());
          }

          Timer(Duration.zero, shoot);
          Timer(const Duration(milliseconds: 100),
              shoot);
          Timer(const Duration(milliseconds: 200),
              shoot);

          ///END
        },
      ),
      CodeBlock(
        buttonText: 'Emoji',
        tip: 'First run may pause briefly while the emoji font downloads.',
        highlighter: _dartDarkHighlighter,
        stageHold: const Duration(seconds: 5),
        onTap: () {
          ///BEGIN

          const options = ConfettiOptions(
            spread: 360,
            ticks: 50,
            gravity: 0,
            decay: 0.94,
            startVelocity: 30,
          );

          shoot() {
            Confetti.launch(context,
                options: options.copyWith(
                  particleCount: 40,
                ),
                particleBuilder: (index) => Emoji(
                    emoji: '🍄',
                    textStyle:
                        GoogleFonts.notoColorEmoji()));
            Confetti.launch(context,
                options: options.copyWith(
                  particleCount: 10,
                ),
                particleBuilder: (index) => Emoji(
                      emoji: '️⚽',
                      textStyle:
                          GoogleFonts.notoColorEmoji(),
                    ));
          }

          Timer(Duration.zero, shoot);
          Timer(const Duration(milliseconds: 200),
              shoot);
          Timer(const Duration(milliseconds: 400),
              shoot);

          ///END
        },
      ),
      CodeBlock(
        buttonText: 'Snow',
        tip: 'Falls gently from the top — no cannon blast.',
        highlighter: _dartDarkHighlighter,
        stageHold: const Duration(seconds: 14),
        onTap: () {
          ///BEGIN

          const colors = [
            Color(0xFFFFFFFF),
            Color(0xFFE8F1FF),
            Color(0xFFBFD7FF),
          ];

          // ~12 seconds of snowfall.
          int total = 120;
          int progress = 0;

          ConfettiController? controller;
          bool isDone = false;

          Timer.periodic(
              const Duration(milliseconds: 100),
              (timer) {
            progress++;

            if (progress >= total) {
              timer.cancel();
              isDone = true;
              return;
            }

            if (controller == null) {
              controller = Confetti.launch(
                context,
                options: const ConfettiOptions(
                  particleCount: 2,
                  // No launch speed — gravity alone pulls them down.
                  startVelocity: 0,
                  spread: 360,
                  ticks: 1000,
                  gravity: 0.4,
                  driftVariance: 0.6,
                  scalar: 0.7,
                  y: -0.05,
                  randomX: true,
                  colors: colors,
                ),
                particleBuilder: (index) =>
                    Snowflake(),
                onFinished: (overlayEntry) {
                  if (isDone) {
                    overlayEntry.remove();
                  }
                },
              );
            } else {
              controller!.launch();
            }
          });

          ///END
        },
      ),
      CodeBlock(
        buttonText: 'School Pride',
        highlighter: _dartDarkHighlighter,
        stageHold: const Duration(seconds: 16),
        onTap: () {
          ///BEGIN

          const colors = [
            Color(0xffbb0000),
            Color(0xffffffff),
          ];

          int frameTime = 1000 ~/ 24;
          int total = 15 * 1000 ~/ frameTime;
          int progress = 0;

          ConfettiController? controller1;
          ConfettiController? controller2;
          bool isDone = false;

          Timer.periodic(
              Duration(milliseconds: frameTime),
              (timer) {
            progress++;

            if (progress >= total) {
              timer.cancel();
              isDone = true;
              return;
            }
            if (controller1 == null) {
              controller1 = Confetti.launch(
                context,
                options: const ConfettiOptions(
                    particleCount: 2,
                    angle: 60,
                    spread: 55,
                    x: 0,
                    colors: colors),
                onFinished: (overlayEntry) {
                  if (isDone) {
                    overlayEntry.remove();
                  }
                },
              );
            } else {
              controller1!.launch();
            }

            if (controller2 == null) {
              controller2 = Confetti.launch(
                context,
                options: const ConfettiOptions(
                    particleCount: 2,
                    angle: 120,
                    spread: 55,
                    x: 1,
                    colors: colors),
                onFinished: (overlayEntry) {
                  if (isDone) {
                    overlayEntry.remove();
                  }
                },
              );
            } else {
              controller2!.launch();
            }
          });

          ///END
        },
      ),
      CodeBlock(
        buttonText: 'Launch',
        tip: 'Play, then press Kill to stop mid-flight.',
        highlighter: _dartDarkHighlighter,
        useStage: false,
        onTap: () {
          ///BEGIN

          final controller = Confetti.launch(
            context,
            options: const ConfettiOptions(
                particleCount: 100,
                spread: 70,
                y: 0.6),
          );

          /// call the kill method to kill the confetti
          /// controller.kill();

          ///END

          killableControllerList.add(controller);
        },
        otherButton: OutlinedButton(
          onPressed: () {
            for (var controller
                in killableControllerList) {
              controller.kill();
            }
          },
          child: const Text('Kill'),
        ),
      ),
      CodeBlock(
        buttonText: 'Not Full Screen',
        highlighter: _dartDarkHighlighter,
        useStage: false,
        onTap: () {
          ///BEGIN
          controller.launch();

          // Wrap the Confetti widget in a Container.
          // Container(
          //   child: ClipPath(
          //     child: Confetti(
          //       controller: controller,
          //       options: const ConfettiOptions(
          //           particleCount: 100, spread: 70, y: 1),
          //     ),
          //   ),
          // );

          ///END
        },
        overWidget: Positioned(
          left: 12,
          right: 12,
          bottom: 12,
          top: 108,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DemoRadii.md),
            child: Confetti(
              controller: controller,
              options: const ConfettiOptions(
                  particleCount: 100,
                  spread: 70,
                  y: 1),
            ),
          ),
        ),
      ),

    ];
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...List.generate(6, (i) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.only(right: i == 5 ? 0 : 5),
                  decoration: BoxDecoration(
                    color: DemoColors.accents[i],
                    borderRadius: BorderRadius.circular(
                      i.isEven ? 2 : DemoRadii.sm,
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Flutter Confetti',
            style: DemoTextStyles.headerTitle,
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Text(
              'Press Play to preview an effect. Most demos open on a dark stage — you can replay or close anytime.',
              style: DemoTextStyles.headerSubtitle,
            ),
          ),
        ],
      ),
    );
  }
}
