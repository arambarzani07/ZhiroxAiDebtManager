import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color navy = Color(0xFF050B16);
  static const Color navy2 = Color(0xFF0A1324);
  static const Color panel = Color(0xFF101A2E);
  static const Color panelSoft = Color(0xFF152139);
  static const Color gold = Color(0xFFE7C15F);
  static const Color cyan = Color(0xFF37D7FF);
  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFFB7185);
  static const Color muted = Color(0xFF94A3B8);

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = base.textTheme.apply(
      bodyColor: const Color(0xFFF8FAFC),
      displayColor: const Color(0xFFF8FAFC),
    );

    return base.copyWith(
      scaffoldBackgroundColor: navy,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: cyan,
        surface: panel,
        error: danger,
      ),
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -1.4),
        headlineLarge: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.8),
        headlineMedium: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        titleLarge: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        bodyMedium: textTheme.bodyMedium?.copyWith(height: 1.45),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: Color(0xFFF8FAFC)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF111C31),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        labelStyle: const TextStyle(color: Color(0xFFCBD5E1), fontWeight: FontWeight.w600),
        hintStyle: const TextStyle(color: Color(0xFF64748B)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0x1AFFFFFF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: gold, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: danger),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: const Color(0xFF111827),
          minimumSize: const Size.fromHeight(58),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFF8FAFC),
          minimumSize: const Size.fromHeight(56),
          side: const BorderSide(color: Color(0x55E7C15F)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
      ),
      cardTheme: CardThemeData(
        color: panel,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xFF16243A),
        selectedColor: gold,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFF8FAFC)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: Color(0x1AFFFFFF)),
      ),
      dividerTheme: const DividerThemeData(color: Color(0x1FFFFFFF), thickness: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: panelSoft,
        contentTextStyle: const TextStyle(color: Color(0xFFF8FAFC), fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
