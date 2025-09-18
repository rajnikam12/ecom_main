import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color constants for consistent theming
class AppColors {
  static const Color primaryLight = Color(0xFF1E88E5); // Blue for light theme
  static const Color primaryDark = Color(0xFF0288D1); // Darker blue for dark theme
  static const Color secondary = Color(0xFFFFA726); // Orange accent
  static const Color backgroundLight = Color(0xFFF5F5F5); // Light gray
  static const Color backgroundDark = Color(0xFF121212); // Dark gray
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFF212121);
  static const Color textDark = Color(0xFFE0E0E0);
  static const Color error = Color(0xFFD32F2F);
}

// Defines light and dark themes with full color scheme
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: AppColors.textLight,
      displayColor: AppColors.textLight,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textLight),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textLight,
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.textLight),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondary,
      background: AppColors.backgroundLight,
      surface: AppColors.surfaceLight,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: AppColors.textLight,
      onSurface: AppColors.textLight,
      error: AppColors.error,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: AppColors.textDark,
      displayColor: AppColors.textDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textDark),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.textDark),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondary,
      background: AppColors.backgroundDark,
      surface: AppColors.surfaceDark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: AppColors.textDark,
      onSurface: AppColors.textDark,
      error: AppColors.error,
    ),
  );
}