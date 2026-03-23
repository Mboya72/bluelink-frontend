import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';
import 'login_screen.dart'; // Ensure you import your LoginScreen here

class SignUpScreen extends StatelessWidget {
  final UserRole selectedRole;

  const SignUpScreen({super.key, required this.selectedRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.navyDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Account",
              style: GoogleFonts.urbanist(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppTheme.navyDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Join as a ${selectedRole.name.toUpperCase()}",
              style: GoogleFonts.urbanist(
                fontSize: 16,
                color: AppTheme.vibrantBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 35),
            _buildTextField(label: "Full Name", icon: Icons.person_outline),
            const SizedBox(height: 20),
            _buildTextField(label: "Email Address", icon: Icons.email_outlined),
            const SizedBox(height: 20),
            _buildTextField(label: "Password", icon: Icons.lock_outline, isPassword: true),
            const SizedBox(height: 20),
            // NEW: Repeat Password Field
            _buildTextField(label: "Repeat Password", icon: Icons.lock_reset_outlined, isPassword: true),
            const SizedBox(height: 35),
            _buildPrimaryButton("SIGN UP", () {}),
            const SizedBox(height: 25),
            _buildSocialDivider(),
            const SizedBox(height: 25),
            _buildGoogleButton("Sign up with Google", () {}),
            const SizedBox(height: 30),
            // NEW: Already have an account navigation
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
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
                        text: "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppTheme.vibrantBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Methods ---

  Widget _buildTextField({required String label, required IconData icon, bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword,
      style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.vibrantBlue),
        labelStyle: GoogleFonts.urbanist(color: Colors.grey[600]),
        filled: true,
        fillColor: const Color(0xFFF5F9FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.vibrantBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
          elevation: 0,
        ),
        child: Text(
          text,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.g_mobiledata, size: 40, color: Colors.red),
        label: Text(
          text,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w700,
            color: AppTheme.navyDark,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        ),
      ),
    );
  }

  Widget _buildSocialDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "OR",
            style: GoogleFonts.urbanist(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}