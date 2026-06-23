import 'dart:async';
import 'dart:math';

import 'package:example/code_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:google_fonts/google_fonts.dart';

// late final Highlighter _dartLightHighlighter;
late final Highlighter _dartDarkHighlighter;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Initialize the highlighter.
  await Highlighter.initialize([
    'dart',
  ]);

  // Load the default light theme and create a highlighter.
  // var lightTheme = await HighlighterTheme.loadLightTheme();
  // _dartLightHighlighter = Highlighter(
  //   language: 'dart',
  //   theme: lightTheme,
  // );

  // Load the default dark theme and create a highlighter.
  var darkTheme = await HighlighterTheme.loadDarkTheme();
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
      theme: ThemeData(useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(title: const Text('🎉 Flutter Confetti🎉 ')),
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.extent(
              maxCrossAxisExtent: 500,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                CodeBlock(
                  buttonText: 'Basic Cannon',
                  highlighter: _dartDarkHighlighter,
                  onTap: () {
                    ///BEGIN
                    Confetti.launch(
                      context,
                      options: const ConfettiOptions(
                          particleCount: 100, spread: 70, y: 0.6),
                    );

                    ///END
                  },
                ),
                CodeBlock(
                  buttonText: 'Random Direction',
                  highlighter: _dartDarkHighlighter,
                  onTap: () {
                    ///BEGIN
                    double randomInRange(double min, double max) {
                      return min + Random().nextDouble() * (max - min);
                    }

                    Confetti.launch(
                      context,
                      options: ConfettiOptions(
                          angle: randomInRange(55, 125),
                          spread: randomInRange(50, 70),
                          particleCount: randomInRange(50, 100).toInt(),
                          y: 0.6),
                    );

                    ///END
                  },
                ),
                CodeBlock(
                  buttonText: 'Fireworks',
                  highlighter: _dartDarkHighlighter,
                  onTap: () {
                    ///BEGIN
                    double randomInRange(double min, double max) {
                      return min + Random().nextDouble() * (max - min);
                    }

                    int total = 60;
                    int progress = 0;

                    Timer.periodic(const Duration(milliseconds: 250), (timer) {
                      progress++;

                      if (progress >= total) {
                        timer.cancel();
                        return;
                      }

                      int count = ((1 - progress / total) * 50).toInt();

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
                          options:
                              options.copyWith(particleCount: 40, scalar: 1.2),
                          particleBuilder: (index) => Star());
                      Confetti.launch(context,
                          options: options.copyWith(
                            particleCount: 10,
                            scalar: 0.75,
                          ),
                          particleBuilder: (index) => Star());
                    }

                    Timer(Duration.zero, shoot);
                    Timer(const Duration(milliseconds: 100), shoot);
                    Timer(const Duration(milliseconds: 200), shoot);

                    ///END
                  },
                ),
                CodeBlock(
                  buttonText: 'Emoji',
                  tip:
                      'The demo uses google web fonts so the first call may take a few seconds to download the font.',
                  highlighter: _dartDarkHighlighter,
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
                              textStyle: GoogleFonts.notoColorEmoji()));
                      Confetti.launch(context,
                          options: options.copyWith(
                            particleCount: 10,
                          ),
                          particleBuilder: (index) => Emoji(
                                emoji: '️⚽',
                                textStyle: GoogleFonts.notoColorEmoji(),
                              ));
                    }

                    Timer(Duration.zero, shoot);
                    Timer(const Duration(milliseconds: 200), shoot);
                    Timer(const Duration(milliseconds: 400), shoot);

                    ///END
                  },
                ),
                CodeBlock(
                  buttonText: 'School Pride',
                  highlighter: _dartDarkHighlighter,
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

                    Timer.periodic(Duration(milliseconds: frameTime), (timer) {
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
                  tip: 'Launch then click the kill button.',
                  highlighter: _dartDarkHighlighter,
                  onTap: () {
                    ///BEGIN

                    final controller = Confetti.launch(
                      context,
                      options: const ConfettiOptions(
                          particleCount: 100, spread: 70, y: 0.6),
                    );

                    /// call the kill method to kill the confetti
                    /// controller.kill();

                    ///END

                    killableControllerList.add(controller);
                  },
                  otherButton: OutlinedButton(
                      onPressed: () {
                        for (var controller in killableControllerList) {
                          controller.kill();
                        }
                      },
                      child: const Text('Kill')),
                ),
                CodeBlock(
                  buttonText: 'Not Full Screen',
                  highlighter: _dartDarkHighlighter,
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
                      right: 24,
                      left: 24,
                      bottom: 24,
                      top: 82,
                      child: ClipPath(
                        child: Confetti(
                          controller: controller,
                          options: const ConfettiOptions(
                              particleCount: 100, spread: 70, y: 1),
                        ),
                      )),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
