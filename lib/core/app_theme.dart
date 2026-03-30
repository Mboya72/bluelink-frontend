import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Centralized Role Definition - Updated to match MainScaffold
enum UserRole { fisherman, buyer, seller, driver, storage, admin }

class AppTheme {
  static const Color vibrantBlue = Color(0xFF1E88E5);
  static const Color navyDark = Color(0xFF0D47A1);
  static const Color softBlueBg = Color(0xFFE6F2FF);

  // Added a fallback for paleAzure if you use it in other UI parts
  static const Color paleAzure = Color(0xFFB3E5FC);

  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: softBlueBg,
      primaryColor: vibrantBlue,
      fontFamily: GoogleFonts.urbanist().fontFamily,
      textTheme: GoogleFonts.urbanistTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: vibrantBlue,
        surface: softBlueBg,
      ),
    );
  }
}