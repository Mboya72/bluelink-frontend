import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

void main() {
  // Ensure Flutter is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BluelinkApp());
}

class BluelinkApp extends StatelessWidget {
  const BluelinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluelink',
      debugShowCheckedModeBanner: false,

      // Updated: Removed the UserRole argument since we
      // simplified the theme to a unified Sky Blue.
      theme: AppTheme.getTheme(),

      // Entry point of the UI flow
      home: const OnboardingScreen(),

      // Optional: Add routes here as you build the Login/Register screens
      // routes: {
      //   '/login': (context) => const LoginScreen(),
      // },
    );
  }
}