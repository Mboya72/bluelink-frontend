import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFF),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildProfileHeader(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildStatsGrid(),
                    const SizedBox(height: 25),
                    _buildSectionTitle("Subscription Plan"),
                    _buildPricingCarousel(),
                    const SizedBox(height: 25),
                    _buildSectionTitle("Business Management"),
                    _buildMenuCard([
                      _menuItem(Icons.receipt_long_rounded, "Order History", "View all past purchases"),
                      _menuItem(Icons.account_balance_wallet_rounded, "Payments & Refunds", "Manage your wallet"),
                      _menuItem(Icons.verified_user_rounded, "Business Verification", "KRA Pin & Licenses", isWarning: true),
                    ]),
                    const SizedBox(height: 25),
                    _buildSectionTitle("Settings"),
                    _buildMenuCard([
                      _menuItem(Icons.notifications_active_outlined, "Notification Settings", "Alerts for new landings"),
                      _menuItem(Icons.security_rounded, "Privacy & Security", "Password and 2FA"),
                      _menuItem(Icons.help_outline_rounded, "Support Center", "Contact Bluelink help"),
                    ]),
                    const SizedBox(height: 30),
                    _buildLogoutButton(),
                    const SizedBox(height: 100), // Clearance for bottom nav
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40)
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("My Profile", style: GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.w900)),
              _actionIcon(Icons.settings_outlined),
            ],
          ),
          const SizedBox(height: 25),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF1A237E), width: 2),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Color(0xFF1A237E), shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text("Elvis Mboya", style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w900)),
          Text("Oceanic Fine Dining Ltd.", style: GoogleFonts.urbanist(fontSize: 14, color: Colors.blueGrey[400], fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFE8EAF6), borderRadius: BorderRadius.circular(20)),
            child: Text("PLATINUM BUYER", style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFF1A237E), letterSpacing: 1)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        _statItem("12", "Active Orders"),
        const SizedBox(width: 15),
        _statItem("Ksh 240k", "Monthly Spend"),
      ],
    );
  }

  Widget _statItem(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A237E),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: const Color(0xFF1A237E).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
            Text(label, style: GoogleFonts.urbanist(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCarousel() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 0, right: 0),
        children: [
          _pricingCard(
            plan: "Basic",
            price: "Free",
            color: const Color(0xFF9FA8DA),
            features: "3 active orders/mo",
            isActive: false,
          ),
          _pricingCard(
            plan: "Business",
            price: "Ksh 4,500",
            color: const Color(0xFF1A237E),
            features: "Unlimited orders • Analytics",
            isActive: true,
          ),
          _pricingCard(
            plan: "Enterprise",
            price: "Custom",
            color: const Color(0xFF0D1231),
            features: "API Access • Priority Support",
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _pricingCard({
    required String plan,
    required String price,
    required Color color,
    required String features,
    required bool isActive,
  }) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 15, bottom: 10, top: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          if (isActive)
            BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(plan.toUpperCase(),
                  style: GoogleFonts.urbanist(color: Colors.white70, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.2)),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                  child: Text("CURRENT", style: GoogleFonts.urbanist(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(price, style: GoogleFonts.urbanist(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(features, style: GoogleFonts.urbanist(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 12),
        child: Text(title, style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF0D1231))),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E5F2).withValues(alpha: 0.5)),
      ),
      child: Column(children: items),
    );
  }

  Widget _menuItem(IconData icon, String title, String sub, {bool isWarning = false}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFFF1F4F9), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: isWarning ? Colors.orange[800] : const Color(0xFF1A237E), size: 22),
      ),
      title: Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 15)),
      subtitle: Text(sub, style: GoogleFonts.urbanist(fontSize: 12, color: Colors.blueGrey[400])),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.blueGrey),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: Color(0xFFD32F2F), size: 20),
            const SizedBox(width: 10),
            Text("Logout Account", style: GoogleFonts.urbanist(color: const Color(0xFFD32F2F), fontWeight: FontWeight.w800, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _actionIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFFF1F4F9), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, size: 20, color: const Color(0xFF1A237E)),
    );
  }
}
