import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

class FisherProfileScreen extends StatelessWidget {
  const FisherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFDFF),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildPremiumHeader(context),
              Transform.translate(
                offset: const Offset(0, -35),
                child: _buildOverlappingStats(),
              ),
              _buildSectionHeader("Vessel & Operations"),
              _buildVesselCard(),
              const SizedBox(height: 25),
              _buildSectionHeader("Service Plans"),
              _buildPricingSection(),
              const SizedBox(height: 25),
              _buildSectionHeader("Account Management"),
              _buildProfessionalMenu(),
              const SizedBox(height: 30),
              _buildLogoutSection(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.navyDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 22),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildProfileAvatar(),
            const SizedBox(height: 15),
            Text(
              "Capt. Elias Mwana",
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 24,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_rounded, color: Colors.white60, size: 14),
                const SizedBox(width: 4),
                Text(
                  "Mombasa Deep Sea Sector",
                  style: GoogleFonts.urbanist(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70), // Safe space for overlapping card
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
          ),
          child: const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white10,
            backgroundImage: NetworkImage("https://images.unsplash.com/photo-1544348817-5f2cf14b88c8?w=400"),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: Color(0xFF00C853), shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlappingStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navyDark.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statTile("1.2t", "Harvested"),
          _vDivider(),
          _statTile("4.9", "Rating"),
          _vDivider(),
          _statTile("Active", "License"),
        ],
      ),
    );
  }

  Widget _statTile(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.navyDark)),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.urbanist(color: Colors.grey, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5)),
      ],
    );
  }

  Widget _vDivider() => Container(height: 30, width: 1, color: Colors.grey.shade100);

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.navyDark)),
          Text("Edit", style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.vibrantBlue)),
        ],
      ),
    );
  }

  Widget _buildVesselCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            height: 60, width: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F5F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.directions_boat_rounded, color: AppTheme.navyDark, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("The Sea Voyager", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 4),
                Text("Vessel ID: BL-9902 • Trawler", style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return SizedBox(
      height: 165,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          _pricingCard("Standard", "Free", "5% commission per sale. Local port access.", Icons.anchor_rounded, Colors.blueGrey),
          _pricingCard("Pro Fleet", "\$29/mo", "2% commission. Priority docking & fuel.", Icons.bolt_rounded, AppTheme.vibrantBlue),
          _pricingCard("Enterprise", "Custom", "Volume logistics. Fleet management tools.", Icons.business_rounded, AppTheme.navyDark),
        ],
      ),
    );
  }

  Widget _pricingCard(String title, String price, String subtitle, IconData icon, Color color) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 15, bottom: 5),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const Spacer(),
          Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14, color: AppTheme.navyDark)),
          Text(price, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 18, color: color)),
          const SizedBox(height: 4),
          Text(subtitle, style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w600, height: 1.2), maxLines: 2),
        ],
      ),
    );
  }

  Widget _buildProfessionalMenu() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _proMenuItem(Icons.assignment_ind_outlined, "Identity Verification", "Verified on 12/2025"),
          _proMenuItem(Icons.account_balance_wallet_outlined, "Payout & Earnings", "\$4,250.00 pending"),
          _proMenuItem(Icons.history_toggle_off_rounded, "Operational Logs", "Review past trips"),
          _proMenuItem(Icons.gpp_good_outlined, "Insurance & Security", "Active Protection", isLast: true),
        ],
      ),
    );
  }

  Widget _proMenuItem(IconData icon, String title, String subtitle, {bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF8FBFF), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppTheme.navyDark, size: 20),
          ),
          title: Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 15)),
          subtitle: Text(subtitle, style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
          onTap: () {},
        ),
        if (!isLast) Divider(height: 1, color: Colors.grey.shade50, indent: 70),
      ],
    );
  }

  Widget _buildLogoutSection() {
    return Column(
      children: [
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(foregroundColor: Colors.redAccent.shade700),
          child: Text("Sign Out of Session", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
        ),
        const SizedBox(height: 5),
        Text("App Version 2.0.4 - Bluelink Enterprise", style: GoogleFonts.urbanist(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}