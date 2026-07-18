import 'dart:async';

import 'package:example/demo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fades the whole page to a black stage, runs [play], then holds and fades out.
///
/// Confetti overlays insert above this stage entry, so particles read clearly
/// against the dark backdrop.
class DemoStage {
  DemoStage._();

  static bool _busy = false;

  static Future<void> present(
    BuildContext context, {
    required VoidCallback play,
    Duration hold = const Duration(seconds: 4),
  }) async {
    if (_busy) return;
    _busy = true;

    final overlay = Overlay.of(context);
    final completer = Completer<void>();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _StageCurtain(
        hold: hold,
        onReady: play,
        onClosed: () {
          entry.remove();
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    overlay.insert(entry);
    await completer.future;
    _busy = false;
  }
}

class _StageCurtain extends StatefulWidget {
  const _StageCurtain({
    required this.hold,
    required this.onReady,
    required this.onClosed,
  });

  final Duration hold;
  final VoidCallback onReady;
  final VoidCallback onClosed;

  @override
  State<_StageCurtain> createState() => _StageCurtainState();
}

class _StageCurtainState extends State<_StageCurtain>
    with SingleTickerProviderStateMixin {
  static const _fadeIn = Duration(milliseconds: 420);
  static const _fadeOut = Duration(milliseconds: 520);

  late final AnimationController _controller;
  late final Animation<double> _opacity;
  Timer? _holdTimer;
  bool _played = false;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _fadeIn);
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_played) {
        _played = true;
        widget.onReady();
        _holdTimer = Timer(widget.hold, _close);
      } else if (status == AnimationStatus.dismissed && _closing) {
        widget.onClosed();
      }
    });

    _controller.forward();
  }

  void _replay() {
    if (_closing || !_played || !mounted) return;
    _holdTimer?.cancel();
    widget.onReady();
    _holdTimer = Timer(widget.hold, _close);
  }

  Future<void> _close() async {
    if (_closing || !mounted) return;
    _closing = true;
    _holdTimer?.cancel();
    _controller.duration = _fadeOut;
    await _controller.reverse();
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.dmSans(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    );

    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.black,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: Opacity(
            opacity: _opacity.value,
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _close,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.15,
                    colors: [
                      const Color(0xFF16161A),
                      Colors.black.withValues(alpha: 0.98),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(DemoRadii.pill),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: _close,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                          ),
                          child: Text('Close', style: labelStyle),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            width: 1,
                            height: 16,
                            color: Colors.white24,
                          ),
                        ),
                        TextButton(
                          onPressed: _replay,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                          ),
                          child: Text('Replay', style: labelStyle),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
