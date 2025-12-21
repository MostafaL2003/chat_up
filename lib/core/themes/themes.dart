import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true, // Turns on modern logic
    brightness: Brightness.light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.cyan,
      brightness: Brightness.light,
      primary: const Color.fromARGB(255, 68, 128, 185),
      onPrimary: const Color.fromARGB(255, 0, 95, 107),
      surface: Colors.white,
    ),

    scaffoldBackgroundColor: Colors.white,

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.cyan[600],
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.cyan[600],
      foregroundColor: Colors.white,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.cyan,
      brightness: Brightness.dark,
      primary: Colors.cyan[700],
      surface: const Color(0xFF121212),
    ),

    scaffoldBackgroundColor: const Color(0xFF121212),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.cyan[900],
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.cyan[700],
      foregroundColor: Colors.white,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}
