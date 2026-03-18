import 'package:flutter/material.dart';

enum UserRole { fisherman, buyer, seller, driver, storage, admin }

class AppTheme {
  // Define Brand Colors for each role
  static Color getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.fisherman: return const Color(0xFF0077B6); // Deep Sea Blue
      case UserRole.buyer:     return const Color(0xFF2D6A4F); // Fresh Green
      case UserRole.seller:    return const Color(0xFFE85D04); // Equipment Orange
      case UserRole.driver:    return const Color(0xFF7209B7); // Logistics Purple
      case UserRole.storage:   return const Color(0xFF4895EF); // Ice Blue
      case UserRole.admin:     return const Color(0xFF1B263B); // Dark Slate
    }
  }

  static ThemeData getTheme(UserRole role) {
    final primaryColor = getRoleColor(role);

    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      // Automatically styles our CustomButton if it uses Theme.of(context).primaryColor
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}