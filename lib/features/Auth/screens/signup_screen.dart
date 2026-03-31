import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';
import '../../navigation/main_scaffold.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  final UserRole selectedRole;

  const SignUpScreen({super.key, required this.selectedRole});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // 1. Controllers to get text from fields
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 2. Logic to handle the Sign Up action
  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // TODO: Connect your Firebase/Django Backend here
      // For now, we simulate a network delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        // 3. Navigate and clear the stack so they can't go back to Auth
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainScaffold(role: widget.selectedRole),
          ),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.navyDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Create Account",
                  style: GoogleFonts.urbanist(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.navyDark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text("Join Bluelink as a ", style: GoogleFonts.urbanist(color: Colors.grey[600])),
                    Text(
                      widget.selectedRole.name.toUpperCase(),
                      style: GoogleFonts.urbanist(
                        color: AppTheme.vibrantBlue,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // --- Input Fields ---
                _buildTextField(
                  controller: _nameController,
                  label: "Full Name",
                  icon: Icons.person_outline_rounded,
                  validator: (v) => v!.isEmpty ? "Enter your name" : null,
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: _emailController,
                  label: "Email Address",
                  icon: Icons.email_outlined,
                  validator: (v) => !v!.contains("@") ? "Enter a valid email" : null,
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                  obscure: _obscurePassword,
                  onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
                  validator: (v) => v!.length < 6 ? "Password too short" : null,
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  controller: _confirmPasswordController,
                  label: "Repeat Password",
                  icon: Icons.lock_reset_rounded,
                  isPassword: true,
                  obscure: _obscurePassword,
                  validator: (v) => v != _passwordController.text ? "Passwords don't match" : null,
                ),

                const SizedBox(height: 40),

                // --- Action Button ---
                _buildPrimaryButton(),

                const SizedBox(height: 30),
                _buildSocialDivider(),
                const SizedBox(height: 30),

                _buildGoogleButton(),

                const SizedBox(height: 40),
                _buildSignInRedirect(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper UI Widgets ---

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onSuffixTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, color: AppTheme.navyDark),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.vibrantBlue, size: 22),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
          onPressed: onSuffixTap,
        )
            : null,
        labelStyle: GoogleFonts.urbanist(color: Colors.grey[500], fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF8FBFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[100]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppTheme.vibrantBlue, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.vibrantBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text("SIGN UP", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, letterSpacing: 1.2)),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton.icon(
        onPressed: () {
          // TEMPORARY BYPASS: Navigate directly to user screens
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Bypassing Auth for Demo..."),
              duration: Duration(milliseconds: 800),
            ),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainScaffold(role: widget.selectedRole),
            ),
                (route) => false,
          );
        },
        icon: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
          height: 24,
          errorBuilder: (c, e, s) => const Icon(Icons.g_mobiledata, size: 30, color: Colors.red),
        ),
        label: Text(
          "Sign up with Google",
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, color: AppTheme.navyDark),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[200]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }

  Widget _buildSocialDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[200])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text("OR", style: GoogleFonts.urbanist(color: Colors.grey[400], fontWeight: FontWeight.w600, fontSize: 12)),
        ),
        Expanded(child: Divider(color: Colors.grey[200])),
      ],
    );
  }

  Widget _buildSignInRedirect() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 14),
            children: [
              const TextSpan(text: "Already have an account? "),
              TextSpan(text: "Sign In", style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.vibrantBlue)),
            ],
          ),
        ),
      ),
    );
  }
}