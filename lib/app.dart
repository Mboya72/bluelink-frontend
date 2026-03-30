import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

class BluelinkApp extends StatelessWidget {
  const BluelinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing the enum from AppTheme to ensure type consistency
    // ignore: unused_local_variable
    final initialRole = UserRole.fisherman;

    return MaterialApp(
      title: 'Bluelink',
      debugShowCheckedModeBanner: false,

      // Theme configuration using Urbanist font
      theme: AppTheme.getTheme(),

      // Starting with the new animated onboarding flow
      home: const OnboardingScreen(),

      // Builder can be used here later to inject global overlays or providers
    );
  }
}