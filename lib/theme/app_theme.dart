import 'package:flutter/material.dart';

import 'wio_theme.dart';

/// Global [ThemeData] built directly from [WioTheme] design tokens.
///
/// Usage:
/// ```dart
/// MaterialApp(theme: AppTheme.light)
/// ```
abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,

        // ── Colour scheme ───────────────────────────────────────────────────
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: WioTheme.p1,    // brand violet  #5700FF
          onPrimary: WioTheme.p2,  // white
          secondary: WioTheme.s1,  // deep navy #0F1A38
          onSecondary: WioTheme.s2,
          surface: WioTheme.sf2,   // white
          onSurface: WioTheme.s1,  // deep navy
          error: WioTheme.sf4,     // error red #FD0D49
          onError: WioTheme.p2,
        ),

        scaffoldBackgroundColor: WioTheme.bg1, // off-white #F5F5F7

        // ── Typography ──────────────────────────────────────────────────────
        fontFamily: 'WioGrotesk_A_Rg',
        textTheme: const TextTheme(
          // Display / Headline → H-scale tokens
          displayLarge: WioTheme.h1Regular,   // 40sp w400
          displayMedium: WioTheme.h2Regular,  // 34sp w400
          displaySmall: WioTheme.h3Regular,   // 24sp w400
          headlineLarge: WioTheme.h2Medium,   // 34sp w500
          headlineMedium: WioTheme.h3Medium,  // 24sp w500
          headlineSmall: WioTheme.h4Medium,   // 20sp w500
          // Title → H4 / B1
          titleLarge: WioTheme.h4Regular,     // 20sp w400
          titleMedium: WioTheme.b1Regular,    // 18sp w400
          titleSmall: WioTheme.b2Medium,      // 16sp w500
          // Body
          bodyLarge: WioTheme.b2Regular,      // 16sp w400
          bodyMedium: WioTheme.b3Regular,     // 14sp w400
          bodySmall: WioTheme.b4Regular,      // 12sp w400
          // Label
          labelLarge: WioTheme.b3Medium,      // 14sp w500
          labelMedium: WioTheme.b4Medium,     // 12sp w500
          labelSmall: WioTheme.b5Regular,     // 10sp w400
        ),

        // ── AppBar ──────────────────────────────────────────────────────────
        appBarTheme: const AppBarTheme(
          backgroundColor: WioTheme.bg3, // white
          foregroundColor: WioTheme.s1,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: WioTheme.b2Medium,
          iconTheme: IconThemeData(color: WioTheme.s1),
        ),

        // ── Buttons ─────────────────────────────────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: WioTheme.p1,
            foregroundColor: WioTheme.p2,
            disabledBackgroundColor: WioTheme.sf6,
            textStyle: WioTheme.b3Medium,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(WioTheme.radiusInput),
            ),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: WioTheme.s1,
            side: const BorderSide(color: WioTheme.br6),
            textStyle: WioTheme.b3Medium,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(WioTheme.radiusInput),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: WioTheme.p1,
            textStyle: WioTheme.b3Medium,
          ),
        ),

        // ── Input fields ────────────────────────────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: WioTheme.sf7,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: WioTheme.spaceLg,
            vertical: WioTheme.spaceMd,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(WioTheme.radiusInput),
            borderSide: const BorderSide(color: WioTheme.br6),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(WioTheme.radiusInput),
            borderSide: const BorderSide(color: WioTheme.br6),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(WioTheme.radiusInput),
            borderSide: const BorderSide(color: WioTheme.br2, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(WioTheme.radiusInput),
            borderSide: const BorderSide(color: WioTheme.sf4),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(WioTheme.radiusInput),
            borderSide: const BorderSide(color: WioTheme.sf4, width: 1.5),
          ),
          hintStyle: WioTheme.b2Regular.copyWith(color: WioTheme.s4),
          labelStyle: WioTheme.b3Medium.copyWith(color: WioTheme.s3),
          errorStyle: WioTheme.b4Regular.copyWith(color: WioTheme.sf4),
        ),

        // ── Divider ─────────────────────────────────────────────────────────
        dividerTheme: const DividerThemeData(
          color: WioTheme.br6,
          thickness: 1,
          space: 1,
        ),

        // ── Card ────────────────────────────────────────────────────────────
        cardTheme: CardThemeData(
          color: WioTheme.sf2,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WioTheme.radiusMd),
            side: const BorderSide(color: WioTheme.br6),
          ),
        ),

        // ── Chip ────────────────────────────────────────────────────────────
        chipTheme: ChipThemeData(
          backgroundColor: WioTheme.sf7,
          labelStyle: WioTheme.b4Medium.copyWith(color: WioTheme.s1),
          side: const BorderSide(color: WioTheme.br6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WioTheme.radiusXXxl),
          ),
        ),

        // ── Progress indicator ───────────────────────────────────────────────
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: WioTheme.p1,
          linearTrackColor: WioTheme.sf6,
        ),

        // ── SnackBar ─────────────────────────────────────────────────────────
        snackBarTheme: SnackBarThemeData(
          backgroundColor: WioTheme.s1,
          contentTextStyle: WioTheme.b3Regular.copyWith(color: WioTheme.s2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WioTheme.radiusInput),
          ),
        ),
      );
}
