import 'package:flutter_confetti/src/utils/launcher.dart';

class ConfettiController {
  /// launch the confetti
  void launch() {
    Launcher.launch(this);
  }

  /// kill the confetti
  void kill() {
    Launcher.kill(this);
  }
}
