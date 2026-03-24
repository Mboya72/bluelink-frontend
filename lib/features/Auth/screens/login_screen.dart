import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';
import '../auth_utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/logo.png', height: 60),
              const SizedBox(height: 50),
              _buildTextField(label: "Email", icon: Icons.email_outlined),
              const SizedBox(height: 20),
              _buildTextField(label: "Password", icon: Icons.lock_outline, isPassword: true),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot Password?",
                    style: GoogleFonts.urbanist(
                      color: AppTheme.vibrantBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildPrimaryButton("LOGIN", () {}),
              const SizedBox(height: 25),
              _buildSocialDivider(),
              const SizedBox(height: 25),
              _buildGoogleButton("Login with Google", () {}),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () => AuthUtils.showRoleSelection(context),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 14),
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.vibrantBlue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Methods Moved Outside the Build Method ---

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
          borderRadius: BorderRadius.circular(60),
          borderSide: BorderSide.none,
        ),
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
        // Using a standard Flutter icon as a placeholder for the Google logo
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