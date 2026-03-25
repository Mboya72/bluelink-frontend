import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // Add this
import 'core/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

void main() {
  // 1. Initialize Flutter Bindings
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // 2. Preserve the native splash screen while the app prepares
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const BluelinkApp());
}

class BluelinkApp extends StatefulWidget {
  const BluelinkApp({super.key});

  @override
  State<BluelinkApp> createState() => _BluelinkAppState();
}

class _BluelinkAppState extends State<BluelinkApp> {

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // 3. Simulate initialization (e.g., checking Firebase Auth or Local Storage)
    // You can replace this delay with your actual auth-check logic later.
    await Future.delayed(const Duration(seconds: 2));

    // 4. Remove the splash screen and show the app
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluelink',
      debugShowCheckedModeBanner: false,

      // Using your unified AppTheme
      theme: AppTheme.getTheme(),

      // Entry point of the UI flow
      home: const OnboardingScreen(),

      // Example of how you'll handle navigation later
      // routes: {
      //   '/login': (context) => const LoginScreen(),
      //   '/dashboard': (context) => const MainScaffold(role: UserRole.fisherman),
      // },
    );
  }
}