import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import this

enum UserRole { fisherman, buyer, seller, driver, storage, admin }

class AppTheme {
  static const Color vibrantBlue = Color(0xFF1E88E5);
  static const Color paleAzure = Color(0xFFE3F2FD);
  static const Color navyDark = Color(0xFF0D47A1);

  static Color getRoleColor(UserRole role) => vibrantBlue;

  static ThemeData getTheme() {
    // We create the base text theme using Urbanist
    final textTheme = GoogleFonts.urbanistTextTheme().copyWith(
      headlineMedium: GoogleFonts.urbanist(
        color: navyDark,
        fontWeight: FontWeight.bold,
        fontSize: 28,
        letterSpacing: -0.5,
      ),
      bodyLarge: GoogleFonts.urbanist(
        color: Colors.grey[700],
        fontSize: 16,
        height: 1.6,
      ),
      labelLarge: GoogleFonts.urbanist(
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paleAzure,
      primaryColor: vibrantBlue,

      // This applies Urbanist to every widget in the app
      textTheme: textTheme,

      // Specifically for buttons and input fields
      fontFamily: GoogleFonts.urbanist().fontFamily,

      colorScheme: ColorScheme.fromSeed(
        seedColor: vibrantBlue,
        primary: vibrantBlue,
        secondary: navyDark,
        surface: Colors.white,
      ),

      // Update button themes to match the new font weight
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}