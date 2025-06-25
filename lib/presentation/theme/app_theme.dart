import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF6A1B9A), // Deep Purple
    scaffoldBackgroundColor: const Color(0xFF12123A), // Dark Blue/Purple
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6A1B9A),
      secondary: Color(0xFFFBC02D), // Gold Accent
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      background: Color(0xFF12123A),
      surface: Color(0xFF1E1E4B),
      error: Colors.redAccent,
      onBackground: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E4B),
      elevation: 4,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
      iconTheme: IconThemeData(color: Color(0xFFFBC02D)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E4B),
      selectedItemColor: Color(0xFFFBC02D), // Gold
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFBC02D), // Gold
      foregroundColor: Color(0xFF12123A), // Dark Blue
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E4B),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E4B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFFBC02D)), // Gold
      ),
      labelStyle: const TextStyle(color: Colors.white70),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Roboto',
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Roboto',
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Roboto',
        color: Colors.white70,
        height: 1.5,
      ),
      bodyMedium: TextStyle(fontFamily: 'Roboto', color: Colors.white60),
      titleLarge: TextStyle(
        fontFamily: 'Roboto',
        color: Color(0xFFFBC02D),
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
  );
}
