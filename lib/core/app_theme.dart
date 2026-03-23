import 'package:flutter/material.dart';

enum UserRole { fisherman, buyer, seller, driver, storage, admin }

class AppTheme {
  // 1. Define our Base Sky Blue Brand Colors
  static const Color skyBluePrimary = Color(0xFF00B4D8); // Vibrant Sky Blue
  static const Color skyBlueLight = Color(0xFFCAF0F8);   // Very Pale Blue
  static const Color skyBlueDark = Color(0xFF0077B6);    // Deep Ocean Blue

  static Color getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.fisherman: return const Color(0xFF0077B6); // Ocean Blue
      case UserRole.buyer:     return const Color(0xFF00B4D8); // Sky Blue
      case UserRole.seller:    return const Color(0xFF48CAE4); // Cyan Blue
      case UserRole.driver:    return const Color(0xFF90E0EF); // Light Sky
      case UserRole.storage:   return const Color(0xFFADE8F4); // Ice Blue
      case UserRole.admin:     return const Color(0xFF03045E); // Navy (Admin)
    }
  }

  static ThemeData getTheme(UserRole role) {
    // During onboarding, we'll likely use skyBluePrimary.
    // Once logged in, we use the specific role color.
    final primaryColor = getRoleColor(role);

    return ThemeData(
      useMaterial3: true,
      // Setting scaffold to primaryColor matches the full-screen color in your image
      scaffoldBackgroundColor: primaryColor,
      primaryColor: primaryColor,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: skyBlueDark,
        surface: Colors.white,
      ),

      // Styling for the white bottom persistent bar and buttons
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 28,
          letterSpacing: -0.5,
        ),
        bodyLarge: TextStyle(
          color: Colors.white70,
          fontSize: 16,
          height: 1.5,
        ),
      ),

      // Ensure buttons inside the white bar use the role color for icons
      iconTheme: IconThemeData(color: primaryColor),
    );
  }
}