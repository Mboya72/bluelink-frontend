import 'package:bluelink_frontend/features/Auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

class AuthUtils {
  static void showRoleSelection(BuildContext context) {
    // We define this variable here so it persists while the dialog is open
    UserRole? localSelectedRole;

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
                      color: AppTheme.vibrantBlue.withOpacity(0.1),
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
                const SizedBox(height: 32),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2),
                  itemCount: UserRole.values.where((r) => r != UserRole.admin).length,
                  itemBuilder: (context, i) {
                    final selectableRoles = UserRole.values.where((r) => r != UserRole.admin).toList();
                    final role = selectableRoles[i];

                    return _roleCard(
                        role,
                        localSelectedRole == role,
                            () => setDialogState(() => localSelectedRole = role)
                    );
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: localSelectedRole == null ? null : () {
                      Navigator.pop(context); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(selectedRole: localSelectedRole!),
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

  static Widget _roleCard(UserRole role, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
          border: Border.all(
              color: isSelected ? AppTheme.vibrantBlue : Colors.transparent, width: 2.5),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [BoxShadow(color: AppTheme.vibrantBlue.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getRoleIcon(role),
                color: isSelected ? AppTheme.vibrantBlue : AppTheme.navyDark.withOpacity(0.4),
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

  static IconData _getRoleIcon(UserRole role) {
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