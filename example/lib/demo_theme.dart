import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Soft white stage with confetti-palette accents.
abstract final class DemoColors {
  static const canvas = Color(0xFFFAFBFD);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1A1C22);
  static const inkMuted = Color(0xFF6B7280);
  static const line = Color(0xFFE6E9F0);
  static const codeBg = Color(0xFF15171C);

  static const cyan = Color(0xFF26CCFF);
  static const violet = Color(0xFFA25AFD);
  static const rose = Color(0xFFFF5E7E);
  static const sun = Color(0xFFFCFF42);
  static const amber = Color(0xFFFFA62D);
  static const magenta = Color(0xFFFF36FF);

  static const accents = [cyan, violet, rose, sun, amber, magenta];
}

/// Shared corner radii so cards, panels, and controls feel like one system.
abstract final class DemoRadii {
  /// Small chips / tight accents.
  static const sm = 8.0;

  /// Nested panels (code well, snackbars).
  static const md = 12.0;

  /// Primary surfaces (demo cards).
  static const lg = 16.0;

  /// Pill buttons and stage controls.
  static const pill = 999.0;
}

/// Cached text styles so cards don't re-resolve Google Fonts on every build.
abstract final class DemoTextStyles {
  static final cardTitle = GoogleFonts.syne(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: DemoColors.ink,
    letterSpacing: -0.2,
  );

  static final tip = GoogleFonts.dmSans(
    color: DemoColors.inkMuted,
    fontSize: 12,
    height: 1.35,
  );

  static final play = GoogleFonts.dmSans(
    fontWeight: FontWeight.w600,
    fontSize: 13,
  );

  static final code = GoogleFonts.jetBrainsMono(
    fontSize: 12.5,
    height: 1.45,
    color: const Color(0xEBFFFFFF),
  );

  static final headerTitle = GoogleFonts.syne(
    fontSize: 40,
    height: 1.05,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.2,
    color: DemoColors.ink,
  );

  static final headerSubtitle = GoogleFonts.dmSans(
    fontSize: 15,
    height: 1.45,
    color: DemoColors.inkMuted,
  );
}

ThemeData buildDemoTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: DemoColors.canvas,
    colorScheme: const ColorScheme.light(
      primary: DemoColors.rose,
      onPrimary: Colors.white,
      secondary: DemoColors.violet,
      surface: DemoColors.surface,
      onSurface: DemoColors.ink,
      outline: DemoColors.line,
    ),
  );

  return base.copyWith(
    textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).apply(
      bodyColor: DemoColors.ink,
      displayColor: DemoColors.ink,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: DemoColors.canvas.withValues(alpha: 0.92),
      foregroundColor: DemoColors.ink,
      centerTitle: false,
      titleTextStyle: GoogleFonts.syne(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: DemoColors.ink,
        letterSpacing: -0.4,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DemoColors.ink,
        backgroundColor: DemoColors.surface,
        side: const BorderSide(color: DemoColors.line),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DemoRadii.pill)),
        textStyle: GoogleFonts.dmSans(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.1,
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: DemoColors.inkMuted,
        hoverColor: DemoColors.rose.withValues(alpha: 0.08),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: DemoColors.rose,
      linearTrackColor: DemoColors.line,
    ),
  );
}
