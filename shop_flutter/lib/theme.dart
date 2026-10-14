import 'package:flutter/material.dart';

const _leaf = Color(0xFF1F7A4D); // primary: deep leaf green
const _sun = Color(0xFFF2A33A); // accent: amber, used sparingly for stock tags

ThemeData buildTheme(Brightness brightness) {
  var scheme = ColorScheme.fromSeed(seedColor: _leaf, brightness: brightness);
  scheme = brightness == Brightness.light
      ? scheme.copyWith(
          primary: _leaf,
          onPrimary: Colors.white,
          tertiary: _sun,
          surface: const Color(0xFFF6F8F7),
        )
      : scheme.copyWith(tertiary: _sun);

  final base = ThemeData(colorScheme: scheme, useMaterial3: true);
  final text = base.textTheme;

  return base.copyWith(
    scaffoldBackgroundColor: scheme.surface,
    textTheme: text.copyWith(
      headlineMedium: text.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineSmall: text.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleLarge: text.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
