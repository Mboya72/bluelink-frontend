import 'package:flutter/material.dart';
import 'core/app_theme.dart';

void main() {
  runApp(const BluelinkApp());
}

class BluelinkApp extends StatelessWidget {
  const BluelinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    // This 'role' would typically come from your Auth provider or Database
    const UserRole currentRole = UserRole.fisherman;

    return MaterialApp(
      title: 'Bluelink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(currentRole),
    );
  }
}