class LauncherConfig {
  final void Function() onLaunch;
  final void Function() onKill;

  const LauncherConfig({required this.onLaunch, required this.onKill});
}
