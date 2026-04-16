import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
// Import Mapbox
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'core/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

void main() {
  // 1. Initialize Flutter Bindings
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // 2. Preserve the native splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 3. SET MAPBOX ACCESS TOKEN HERE (CRITICAL FOR ANDROID)
  // Replace this string with your actual 'pk....' token from Mapbox dashboard
  MapboxOptions.setAccessToken("pk.eyJ1IjoiZWx2aW5kaW8iLCJhIjoiY21vMWpmcWpjMGZzeDJwcXdwOXp4N3ZrMiJ9.Mc5Blk8BDRdFHWBLkc25Aw");

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
    // 4. Simulate initialization or Auth check
    await Future.delayed(const Duration(seconds: 2));

    // 5. Remove the splash screen
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluelink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      home: const OnboardingScreen(),
    );
  }
}