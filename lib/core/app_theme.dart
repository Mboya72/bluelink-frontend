import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Ensure this matches your project's role requirements
enum UserRole { fisherman, buyer, seller, driver, storage, admin }

class AppTheme {
  // --- Updated Palette ---
  static const Color vibrantBlue = Color(0xFF1E88E5);
  static const Color navyDark = Color(0xFF0D47A1);

  // Your requested background color
  static const Color softBlueBg = Color(0xFFE6F2FF);

  static Color getRoleColor(UserRole role) => vibrantBlue;

  static ThemeData getTheme() {
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

      // Applied your requested color here
      scaffoldBackgroundColor: softBlueBg,

      primaryColor: vibrantBlue,
      textTheme: textTheme,
      fontFamily: GoogleFonts.urbanist().fontFamily,

      colorScheme: ColorScheme.fromSeed(
        seedColor: vibrantBlue,
        primary: vibrantBlue,
        secondary: navyDark,
        // Applied to cards and sheets for a unified look
        surface: softBlueBg,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: vibrantBlue,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}