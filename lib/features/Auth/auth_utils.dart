import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';
// Ensure this import points to your actual SignUpScreen
// import 'package:bluelink_frontend/features/Auth/screens/signup_screen.dart';

class AuthUtils {
  static void showRoleSelection(BuildContext context) {
    UserRole? localSelectedRole;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          backgroundColor: AppTheme.softBlueBg,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 32),
                    // Ensure your asset path is correct in pubspec.yaml
                    const Icon(Icons.waves_rounded, color: AppTheme.vibrantBlue, size: 35),
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
                const SizedBox(height: 32),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2),
                  // Logic to filter out Admin from selection
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
                      Navigator.pop(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen(selectedRole: localSelectedRole!)));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.vibrantBlue,
                        disabledBackgroundColor: Colors.grey[300],
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
    // Formatting the name: "coldStorage" -> "Cold Storage"
    String displayName = role.name;
    if (displayName == "coldStorage") {
      displayName = "Cold Storage";
    } else {
      displayName = displayName[0].toUpperCase() + displayName.substring(1);
    }

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
              ? [BoxShadow(color: AppTheme.vibrantBlue.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getRoleIcon(role),
                color: isSelected ? AppTheme.vibrantBlue : AppTheme.navyDark.withValues(alpha: 0.4),
                size: 32),
            const SizedBox(height: 10),
            Text(displayName,
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
      case UserRole.fisherman:   return Icons.anchor_rounded;
      case UserRole.buyer:       return Icons.shopping_bag_outlined;
      case UserRole.seller:      return Icons.storefront_rounded;
      case UserRole.driver:      return Icons.local_shipping_outlined;
      case UserRole.storage: return Icons.warehouse_outlined; // Updated case
      case UserRole.admin:       return Icons.admin_panel_settings_outlined;
    }
  }
}