import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.cyan,
      brightness: Brightness.light,
      primary: const Color.fromARGB(
        255,
        33,
        150,
        243,
      ), // Better Blue for visibility
      onPrimary: Colors.white, // Text on primary buttons is now white
      surface: Colors.white,
      onSurface: Colors.black87, // Text on background
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
        color: Colors.white,
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.cyan[600],
      foregroundColor: Colors.white,
    ),

    // FIXED: Text was white on white background. Now it's dark grey/black.
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        fontSize: 28,
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(167, 0, 0, 0),
        fontSize: 20,
      ),
      bodySmall: TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black54,
        fontSize: 16,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.cyan,
      brightness: Brightness.dark,
      primary: Colors.cyan[700],
      onPrimary: Colors.white,
      surface: const Color(
        0xFF1E1E1E,
      ), // Slightly lighter than pure black for depth
      onSurface: Colors.white,
    ),

    scaffoldBackgroundColor: const Color(0xFF121212),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black, // Sleek dark app bar
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
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
