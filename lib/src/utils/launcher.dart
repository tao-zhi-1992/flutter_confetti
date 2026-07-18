import 'package:flutter_confetti/src/utils/launcher_config.dart';

class Launcher {
  static final Map<Object, LauncherConfig> _bullets = {};

  static void load(Object key, LauncherConfig launcherConfig) {
    _bullets[key] = launcherConfig;
  }

  static void launch(Object key) {
    _bullets[key]?.onLaunch();
  }

  static void kill(Object key) {
    _bullets[key]?.onKill();
  }

  static void unload(Object key) {
    _bullets.remove(key);
  }
}
