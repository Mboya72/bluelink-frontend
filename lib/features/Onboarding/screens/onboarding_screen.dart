// lib/features/onboarding/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _current = 0;

  final List<Map<String, String>> _pages = const [
    {
      'image': 'assets/images/logo_main.png', // Or use your Bluelink 1.png logo
      'title': 'Welcome to Blue Link',
      'subtitle': 'Streamlining the entire blue economy from boat to business.',
    },
    {
      'image': 'assets/images/onboard_connect.png',
      'title': 'Connected Experts',
      'subtitle': 'Interact with market leaders, logistics providers, and buyers in real-time.',
    },
    {
      'image': 'assets/images/onboard_secure.png',
      'title': 'Secure Transactions',
      'subtitle': 'Fast, audited payments within the Blue Link ecosystem.',
    },
  ];

  void _showRoleSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Who are you?",
              style: GoogleFonts.urbanist(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppTheme.navyDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Select your primary role in the ecosystem",
              style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 15),
            ),
            const SizedBox(height: 32),

            // Role Grid (Fisherman, Buyer, Seller, Driver, Storage, Admin)
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: UserRole.values.length,
                itemBuilder: (context, i) {
                  final role = UserRole.values[i];
                  return _roleCard(role);
                },
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.vibrantBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: Text(
                  "CONTINUE",
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleCard(UserRole role) {
    return InkWell(
      onTap: () => setState(() => /* Update Global State Here */ {}),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getRoleIcon(role), color: AppTheme.vibrantBlue, size: 32),
            const SizedBox(height: 10),
            Text(
              role.name.toUpperCase(),
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: AppTheme.navyDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.fisherman: return Icons.anchor;
      case UserRole.buyer: return Icons.shopping_basket_outlined;
      case UserRole.seller: return Icons.storefront;
      case UserRole.driver: return Icons.local_shipping_outlined;
      case UserRole.storage: return Icons.warehouse_outlined;
      case UserRole.admin: return Icons.admin_panel_settings_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (_, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Responsive image sizing like your tailor example
                        Image.asset(page['image']!, height: i == 0 ? 120 : 260, fit: BoxFit.contain),
                        const SizedBox(height: 40),
                        Text(
                          page['title']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.navyDark,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['subtitle']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Animated Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _current == i ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _current == i ? AppTheme.vibrantBlue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                  const SizedBox(height: 40),

                  // Primary Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _current == _pages.length - 1
                          ? _showRoleSelection
                          : () => _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.vibrantBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      child: Text(
                        _current == _pages.length - 1 ? 'GET STARTED' : 'NEXT',
                        style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1.1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Secondary Sign In Link
                  TextButton(
                    onPressed: () {},
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 14),
                        children: [
                          const TextSpan(text: "Already have an account? "),
                          TextSpan(
                            text: "Sign in",
                            style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.vibrantBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}