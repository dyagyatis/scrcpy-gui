import 'package:flutter/material.dart';

enum AppThemeMode {
  dark,
  light,
  oled,
  system,
}

enum AppAccentColor {
  purple,
  cyan,
  emerald,
  orange,
  crimson,
  system,
}

class AppTheme {
  // Backgrounds - Dark
  static const bgDarkest = Color(0xFF0D0E12);
  static const bgOled = Color(0xFF000000);
  static const bgSidebar = Color(0xFF0F1117);
  static const bgCard = Color(0xFF151821);
  static const bgCardOled = Color(0xFF0A0A0A);
  static const bgInput = Color(0xFF10121A);
  static const borderColor = Color(0xFF232735);
  static const borderHover = Color(0xFF3B4256);

  // Backgrounds - Light
  static const bgLight = Color(0xFFF1F5F9);
  static const bgLightSidebar = Color(0xFFE2E8F0);
  static const bgLightCard = Color(0xFFFFFFFF);
  static const bgLightInput = Color(0xFFF8FAFC);
  static const borderLight = Color(0xFFCBD5E1);

  // Accents Palette
  static const purpleAccent = Color(0xFF8B5CF6);
  static const purpleActive = Color(0xFF4C1D95);
  static const greenAccent = Color(0xFF10B981);
  static const redAccent = Color(0xFFEF4444);
  static const orangeAccent = Color(0xFFF97316);
  static const yellowAccent = Color(0xFFF59E0B);
  static const blueAccent = Color(0xFF3B82F6);
  static const cyanAccent = Color(0xFF06B6D4);
  static const systemBlue = Color(0xFF0078D4); // Windows Modern Fluent Accent

  // Static Aliases
  static Color primaryColor = purpleAccent;
  static const successColor = greenAccent;
  static const dangerColor = redAccent;
  static const warningColor = yellowAccent;

  // Text
  static const textPrimaryDark = Color(0xFFF8FAFC);
  static const textSecondaryDark = Color(0xFF94A3B8);
  static const textMuted = Color(0xFF64748B);
  static const textPrimaryLight = Color(0xFF0F172A);
  static const textSecondaryLight = Color(0xFF475569);

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
      case AppAccentColor.system:
        return systemBlue;
    }
  }

  static ThemeData createTheme({
    AppThemeMode themeMode = AppThemeMode.dark,
    AppAccentColor accent = AppAccentColor.purple,
  }) {
    final activeAccent = getAccentColor(accent);
    primaryColor = activeAccent;

    final isLight = themeMode == AppThemeMode.light;
    final isOled = themeMode == AppThemeMode.oled;

    final scaffoldBg = isLight ? bgLight : (isOled ? bgOled : bgDarkest);
    final cardBg = isLight ? bgLightCard : (isOled ? bgCardOled : bgCard);
    final inputBg = isLight ? bgLightInput : bgInput;
    final border = isLight ? borderLight : borderColor;
    final textPrim = isLight ? textPrimaryLight : textPrimaryDark;
    final textSec = isLight ? textSecondaryLight : textSecondaryDark;

    return ThemeData(
      useMaterial3: true,
      brightness: isLight ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor: scaffoldBg,
      primaryColor: activeAccent,
      colorScheme: isLight
          ? ColorScheme.light(
              primary: activeAccent,
              secondary: greenAccent,
              surface: cardBg,
              error: redAccent,
            )
          : ColorScheme.dark(
              primary: activeAccent,
              secondary: greenAccent,
              surface: cardBg,
              error: redAccent,
            ),
      fontFamily: 'Segoe UI',
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: isLight ? 1 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: activeAccent, width: 1.5),
        ),
        labelStyle: TextStyle(color: textSec, fontSize: 12),
        hintStyle: const TextStyle(color: textMuted, fontSize: 12),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return activeAccent;
          }
          return inputBg;
        }),
        side: BorderSide(color: border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: activeAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme => createTheme();
}
