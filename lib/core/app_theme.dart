import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    const bg = Color(0xFF0E1014);
    const surface = Color(0xFF171A21);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4FC3F7),
        secondary: Color(0xFF7CFF8F),
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        color: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      useMaterial3: true,
    );
  }
}
