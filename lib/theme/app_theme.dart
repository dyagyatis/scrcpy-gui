import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF3B82F6);
  static const primaryHover = Color(0xFF60A5FA);
  static const successColor = Color(0xFF10B981);
  static const dangerColor = Color(0xFFEF4444);
  static const warningColor = Color(0xFFF59E0B);
  
  static const bgDarkest = Color(0xFF0F1015);
  static const bgDark = Color(0xFF13151B);
  static const bgCard = Color(0xFF1A1D24);
  static const bgInput = Color(0xFF12141A);
  static const borderColor = Color(0xFF282C37);
  static const textPrimary = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFF94A3B8);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDarkest,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: successColor,
        surface: bgCard,
        error: dangerColor,
      ),
      cardTheme: CardTheme(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: borderColor),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgInput,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          borderSide: const BorderSide(color: primaryColor),
        ),
        hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF242936),
          foregroundColor: textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: Color(0xFF333A4C)),
          ),
        ),
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Color(0xFF60A5FA),
        unselectedLabelColor: Color(0xFF94A3B8),
        indicatorColor: primaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }
}
