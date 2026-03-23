import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

class BluelinkApp extends StatelessWidget {
  const BluelinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, we use a default role.
    // Later, this will be driven by a State Provider (Riverpod/Bloc)
    const initialRole = UserRole.fisherman;

    return MaterialApp(
      title: 'Bluelink',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.getTheme(initialRole),

      // Entry point of the UI flow
      home: const OnboardingScreen(),

      // Optional: Define named routes here as the app grows
      // routes: {
      //   '/login': (context) => const LoginScreen(),
      //   '/dashboard': (context) => const DashboardScreen(),
      // },
    );
  }
}