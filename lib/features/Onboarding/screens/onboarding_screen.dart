import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';
import '../../Auth/screens/login_screen.dart';
import '../../Auth/screens/signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _current = 0;
  UserRole? _selectedRole;

  final List<Map<String, String>> _pages = const [
    {
      'image': 'assets/images/logo.png',
      'title': 'Welcome to Blue Link',
      'subtitle': 'The digital home for the blue economy. Connecting boats to businesses.',
    },
    {
      'image': 'assets/images/market.png',
      'title': 'Direct Market Access',
      'subtitle': 'Skip the middlemen. Connect directly with buyers and premium logistics.',
    },
    {
      'image': 'assets/images/payment.png',
      'title': 'Instant Payouts', // Focus on "Getting Paid" rather than "Security"
      'subtitle': 'Track your earnings and receive payments instantly upon delivery.',
    },
  ];

  void _showRoleSelection() {
    final selectableRoles = UserRole.values.where((r) => r != UserRole.admin).toList();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          backgroundColor: const Color(0xFFE6F2FF),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 32),
                    Image.asset('assets/images/logo.png', height: 35),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                      color: AppTheme.vibrantBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text("Blue Link Ecosystem",
                      style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.vibrantBlue,
                          fontSize: 12,
                          letterSpacing: 1.1)),
                ),
                const SizedBox(height: 24),
                Text("Choose your role",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                        fontSize: 30, fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
                const SizedBox(height: 12),
                Text("Select a role to tailor your experience.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(color: Colors.black54, fontWeight: FontWeight.w500)),
                const SizedBox(height: 32),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2),
                  itemCount: selectableRoles.length,
                  itemBuilder: (context, i) {
                    final role = selectableRoles[i];
                    return _roleCard(role, _selectedRole == role,
                            () => setDialogState(() => _selectedRole = role));
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _selectedRole == null ? null : () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(selectedRole: _selectedRole!),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.vibrantBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    child: Text("CONTINUE",
                        style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.2)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleCard(UserRole role, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
          border: Border.all(
              color: isSelected ? AppTheme.vibrantBlue : Colors.transparent, width: 2.5),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [
            BoxShadow(
                color: AppTheme.vibrantBlue.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getRoleIcon(role),
                color: isSelected ? AppTheme.vibrantBlue : AppTheme.navyDark.withValues(alpha: 0.4),
                size: 32),
            const SizedBox(height: 10),
            Text(role.name[0].toUpperCase() + role.name.substring(1),
                style: GoogleFonts.urbanist(
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                    fontSize: 14,
                    color: isSelected ? AppTheme.vibrantBlue : AppTheme.navyDark)),
          ],
        ),
      ),
    );
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.fisherman: return Icons.anchor_rounded;
      case UserRole.buyer:     return Icons.shopping_bag_outlined;
      case UserRole.seller:    return Icons.storefront_rounded;
      case UserRole.driver:    return Icons.local_shipping_outlined;
      case UserRole.storage:   return Icons.warehouse_outlined;
      case UserRole.admin:     return Icons.admin_panel_settings_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFE6F2FF),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (_, i) {
                  final String currentImagePath = _pages[i]['image']!;
                  final bool isLogo = i == 0;
                  final bool isFisher = i == 1;
                  final bool isPayout = i == 2;

                  return Column(
                    children: [
                      const SizedBox(height: 90),
                      // 1. Remove double.infinity and use a Center + Constrained Container
                      Center(
                        child: SizedBox(
                          // Use 85% of screen width for a clean "inset" look
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: isLogo
                              ? screenHeight * 0.25
                              : (isFisher || isPayout ? screenHeight * 0.45 : screenHeight * 0.35),
                          child: Padding(
                            padding: EdgeInsets.all(isPayout ? 30.0 : 0.0), // Internal padding for the "card"
                            child: Image.asset(
                              currentImagePath,
                              // BoxFit.contain is much safer for "objects" like payment cards
                              fit: (isLogo || isFisher || isPayout) ? BoxFit.contain : BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.payments_outlined, size: 50),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            Text(_pages[i]['title']!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0080FF),
                                    height: 1.1)),
                            const SizedBox(height: 20),
                            Text(_pages[i]['subtitle']!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        _pages.length,
                            (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _current == i ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _current == i ? AppTheme.vibrantBlue : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 55, // Slightly increased height for better tap target
                    child: ElevatedButton(
                      onPressed: _current == _pages.length - 1
                          ? _showRoleSelection
                          : () => _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOutCubic),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.vibrantBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        elevation: 0,
                      ),
                      child: Text(
                        _current == _pages.length - 1 ? 'Get Started' : 'Next',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 14),
                        children: [
                          const TextSpan(text: "Already have an account? "),
                          TextSpan(
                            text: "Sign in",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AppTheme.vibrantBlue,
                            ),
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