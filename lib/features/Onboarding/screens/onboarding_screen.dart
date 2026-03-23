// lib/features/onboarding/screens/onboarding_screen.dart

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  UserRole? selectedRole;
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Discover the Blue Market",
      "subtitle": "Connecting fishermen with local and global buyers seamlessly.",
    },
    {
      "title": "Smart Logistics Tracking",
      "subtitle": "Monitor your equipment and cold storage in real-time.",
    },
    {
      "title": "Fast & Secure Payments",
      "subtitle": "Experience secure transactions within the Bluelink ecosystem.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPage == onboardingData.length;
    final Color primaryBlue = AppTheme.skyBluePrimary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. The Sky Blue Wave Background
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.8),
            painter: WavePainter(primaryBlue),
          ),

          // 2. Top "Skip" Button
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => _pageController.jumpToPage(onboardingData.length),
                child: const Text("Skip", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ),

          // 3. Page Content
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (v) => setState(() => _currentPage = v),
                  itemCount: onboardingData.length + 1,
                  itemBuilder: (context, index) {
                    if (index < onboardingData.length) {
                      return _buildContentPage(onboardingData[index]);
                    } else {
                      return _buildRoleSelection();
                    }
                  },
                ),
              ),

              // 4. Navigation Bar (Exact match to second image)
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    _navButton(
                      icon: Icons.arrow_back,
                      visible: _currentPage > 0,
                      onTap: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                    ),

                    // Centered Indicator
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: onboardingData.length + 1,
                      effect: ScaleDotsEffect(
                        activeDotColor: primaryBlue,
                        dotColor: primaryBlue.withValues(alpha: 0.2),
                        dotHeight: 10,
                        dotWidth: 10,
                      ),
                    ),

                    // Next/Finish Button
                    _navButton(
                      icon: isLastPage ? Icons.check : Icons.arrow_forward,
                      isPrimary: true,
                      onTap: () {
                        if (!isLastPage) {
                          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                        } else {
                          _finish();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentPage(Map<String, String> data) {
    return Column(
      children: [
        const Expanded(flex: 5, child: SizedBox()), // Space for background visual
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Text(data['title']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF003049))),
                const SizedBox(height: 20),
                Text(data['subtitle']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _navButton({required IconData icon, required VoidCallback onTap, bool visible = true, bool isPrimary = false}) {
    if (!visible) return const SizedBox(width: 50);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.skyBluePrimary : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.skyBluePrimary.withValues(alpha: 0.2)),
          boxShadow: [if (isPrimary) BoxShadow(color: AppTheme.skyBluePrimary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Icon(icon, color: isPrimary ? Colors.white : AppTheme.skyBluePrimary),
      ),
    );
  }

  // Use the same Role Card logic from before, but styled for the new white background
  Widget _buildRoleSelection() { ... }

  void _finish() {
    if (selectedRole != null) {
      developer.log("Role: $selectedRole");
    } else {
      // Show error
    }
  }
}

class WavePainter extends CustomPainter {
  final Color color;
  WavePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color..style = PaintingStyle.fill;
    var path = Path();

    path.lineTo(0, size.height * 0.7); // Start of curve
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.9, // Peak of curve
      size.width, size.height * 0.7,      // End of curve
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}