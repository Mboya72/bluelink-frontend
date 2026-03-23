import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Centralized Role Definition
enum UserRole { fisherman, buyer, seller, driver, storage, admin }

class AppTheme {
  static const Color vibrantBlue = Color(0xFF1E88E5);
  static const Color navyDark = Color(0xFF0D47A1);
  static const Color softBlueBg = Color(0xFFE6F2FF);

  static Color? get paleAzure => null;

  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: softBlueBg,
      primaryColor: vibrantBlue,
      // This applies Urbanist globally to avoid info warnings in other files
      fontFamily: GoogleFonts.urbanist().fontFamily,
      textTheme: GoogleFonts.urbanistTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: vibrantBlue,
        surface: softBlueBg,
      ),
    );
  }
}