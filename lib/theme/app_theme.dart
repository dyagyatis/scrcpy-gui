import 'package:flutter/material.dart';

enum AppAccentColor {
  purple,
  cyan,
  emerald,
  orange,
  crimson,
}

class AppTheme {
  // Backgrounds
  static const bgDarkest = Color(0xFF0D0E12);
  static const bgOled = Color(0xFF000000);
  static const bgSidebar = Color(0xFF0F1117);
  static const bgCard = Color(0xFF151821);
  static const bgCardOled = Color(0xFF0A0A0A);
  static const bgInput = Color(0xFF10121A);
  static const borderColor = Color(0xFF232735);
  static const borderHover = Color(0xFF3B4256);

  // Default Accents
  static const purpleAccent = Color(0xFF8B5CF6);
  static const purpleActive = Color(0xFF4C1D95);
  static const greenAccent = Color(0xFF10B981);
  static const redAccent = Color(0xFFEF4444);
  static const orangeAccent = Color(0xFFF97316);
  static const yellowAccent = Color(0xFFF59E0B);
  static const blueAccent = Color(0xFF3B82F6);
  static const cyanAccent = Color(0xFF06B6D4);

  // Dynamic Aliases (updated based on active accent)
  static Color primaryColor = purpleAccent;
  static const successColor = greenAccent;
  static const dangerColor = redAccent;
  static const warningColor = yellowAccent;

  // Text
  static const textPrimary = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFF94A3B8);
  static const textMuted = Color(0xFF64748B);

  static Color getAccentColor(AppAccentColor accent) {
    switch (accent) {
      case AppAccentColor.purple:
        return purpleAccent;
      case AppAccentColor.cyan:
        return cyanAccent;
      case AppAccentColor.emerald:
        return greenAccent;
      case AppAccentColor.orange:
        return orangeAccent;
      case AppAccentColor.crimson:
        return redAccent;
    }
  }

  static ThemeData createTheme({
    AppAccentColor accent = AppAccentColor.purple,
    bool isOled = false,
  }) {
    final activeAccent = getAccentColor(accent);
    primaryColor = activeAccent;
    final scaffoldBg = isOled ? bgOled : bgDarkest;
    final cardBg = isOled ? bgCardOled : bgCard;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: ColorScheme.dark(
        primary: activeAccent,
        secondary: greenAccent,
        surface: cardBg,
        error: redAccent,
      ),
      fontFamily: 'Segoe UI',
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgInput,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: activeAccent, width: 1.5),
        ),
        labelStyle: const TextStyle(color: textMuted, fontSize: 12),
        hintStyle: const TextStyle(color: textMuted, fontSize: 12),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return activeAccent;
          }
          return bgInput;
        }),
        side: const BorderSide(color: borderColor, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  static ThemeData get darkTheme => createTheme();
}
