import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('confetti speed is independent of the display refresh rate',
      (tester) async {
    // Pumps frames at the given interval until the confetti finishes and
    // returns the total simulated time it took.
    Future<Duration> timeToFinish(Duration frame) async {
      final controller = ConfettiController();
      var finished = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Confetti(
            controller: controller,
            options: const ConfettiOptions(ticks: 30, particleCount: 5),
            onFinished: () => finished = true,
          ),
        ),
      );

      controller.launch();
      await tester.pump();

      var elapsed = Duration.zero;
      while (!finished && elapsed < const Duration(seconds: 5)) {
        await tester.pump(frame);
        elapsed += frame;
      }

      expect(finished, isTrue);
      return elapsed;
    }

    final at60Hz = await timeToFinish(const Duration(milliseconds: 16));
    final at120Hz = await timeToFinish(const Duration(milliseconds: 8));

    // 30 physics ticks at a fixed 60 ticks/s should take ~500ms of wall time
    // on both refresh rates.
    expect((at60Hz - at120Hz).abs(), lessThan(const Duration(milliseconds: 50)));
  });
}
