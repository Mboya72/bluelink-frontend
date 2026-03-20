import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/Onboarding/screens/onboarding_screen.dart';

void main() {
  runApp(const BluelinkApp());
}

class BluelinkApp extends StatelessWidget {
  const BluelinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, we default to Fisherman theme until a role is selected
    // Once you have a selection saved, you'd load it here.
    return MaterialApp(
      title: 'Bluelink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(UserRole.fisherman),
      home: const OnboardingScreen(), // This is the key line
    );
  }
}