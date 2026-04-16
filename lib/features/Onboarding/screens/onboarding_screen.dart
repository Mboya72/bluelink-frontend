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
  UserRole? _selectedRole;

  // Single page data as requested
  final Map<String, String> _pageData = const {
    'image': 'assets/images/fish.png',
    'title': 'Empowering Kenya’s Blue Economy:\nOne Click at a Time',
    'subtitle': 'Simplifying the complex. Connecting the disconnected.',
  };

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  // Centered Illustration
                  Container(
                    height: screenHeight * 0.4,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      _pageData['image']!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Text Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Text(
                          _pageData['title']!,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.urbanist(
                            fontSize: 38,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0080FF),
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          _pageData['subtitle']!,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.urbanist(
                            fontSize: 20,
                            color: const Color(0xFF00A3FF),
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Section
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 60),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: _showRoleSelection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0080FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Get Started',
                        style: GoogleFonts.urbanist(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen())
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 15),
                        children: [
                          const TextSpan(text: "Already have an account? "),
                          TextSpan(
                            text: "Sign in",
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0080FF),
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

  void _showRoleSelection() {
    final selectableRoles = UserRole.values.where((r) => r != UserRole.admin).toList();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.4), // Dim the background
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const SizedBox(), // Placeholder
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: StatefulBuilder(
              builder: (context, setDialogState) => Dialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                backgroundColor: const Color(0xFFF0F7FF), // Very light airy blue
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 40),
                          // Small Blue Link Branding
                          Column(
                            children: [
                              Image.asset('assets/images/logo.png', height: 50),
                            ],
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close_rounded, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Text(
                        "Join as a Partner",
                        style: GoogleFonts.urbanist(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0D1231),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Select your role to personalize your dashboard",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: Colors.blueGrey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Grid of Roles
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: selectableRoles.length,
                        itemBuilder: (context, i) {
                          final role = selectableRoles[i];
                          return _roleCard(
                            role,
                            _selectedRole == role,
                                () => setDialogState(() => _selectedRole = role),
                          );
                        },
                      ),
                      const SizedBox(height: 30),

                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _selectedRole == null
                              ? null
                              : () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(selectedRole: _selectedRole!),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0080FF),
                            disabledBackgroundColor: Colors.grey[200],
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            "CONTINUE",
                            style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: 15,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _roleCard(UserRole role, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFF0080FF) : Colors.white.withValues(alpha: 0.8),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFF0080FF).withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with soft background circle when selected
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0080FF).withValues(alpha: 0.1) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getRoleIcon(role),
                color: isSelected ? const Color(0xFF0080FF) : const Color(0xFF0D1231).withValues(alpha: 0.3),
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              role.name[0].toUpperCase() + role.name.substring(1),
              style: GoogleFonts.urbanist(
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 14,
                color: isSelected ? const Color(0xFF0080FF) : const Color(0xFF0D1231),
              ),
            ),
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
}