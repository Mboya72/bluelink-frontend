import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isAvailable = true;
  double baseRate = 2500;
  double perKmRate = 150;
  bool hasColdStorage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  _buildAvailabilityCard(),

                  const SizedBox(height: 30),
                  _buildSectionHeader("Business Pricing", Icons.payments_outlined),
                  const SizedBox(height: 15),
                  _buildPricingCard(),

                  const SizedBox(height: 30),
                  _buildSectionHeader("My Rig & Documents", Icons.local_shipping_outlined),
                  const SizedBox(height: 15),
                  _buildDocumentGrid(),

                  const SizedBox(height: 30),
                  _buildSectionHeader("Account Settings", Icons.settings_outlined),
                  const SizedBox(height: 15),
                  _buildSettingTile(Icons.person_outline, "Personal Info", "Hassan Ali • +254 712..."),
                  _buildSettingTile(Icons.notifications_none_outlined, "Notifications", "Enabled"),

                  const SizedBox(height: 40),
                  _buildLogoutButton(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 30, left: 25, right: 25,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("My Profile", style: GoogleFonts.urbanist(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
              const Icon(Icons.qr_code_scanner_rounded, color: AppTheme.navyDark),
            ],
          ),
          const SizedBox(height: 25),
          Stack(
            children: [
              const CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400"),
              ),
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: AppTheme.vibrantBlue, shape: BoxShape.circle),
                  child: const Icon(Icons.verified_rounded, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text("Hassan Ali", style: GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
          Text("Tier 1 Logistics Partner", style: GoogleFonts.urbanist(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildAvailabilityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isAvailable ? AppTheme.vibrantBlue.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: isAvailable ? AppTheme.vibrantBlue.withValues(alpha: 0.2) : Colors.transparent),
      ),
      child: Row(
        children: [
          Icon(Icons.radar_rounded, color: isAvailable ? AppTheme.vibrantBlue : Colors.grey),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Work Status", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 16)),
                Text(isAvailable ? "Online & accepting loads" : "Currently Offline", style: GoogleFonts.urbanist(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Switch.adaptive(
            value: isAvailable,
            activeTrackColor: AppTheme.vibrantBlue,
            onChanged: (v) => setState(() => isAvailable = v),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        children: [
          _priceSlider("Base Load Rate", baseRate, "per trip", (v) => setState(() => baseRate = v), 1000, 5000),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
          _priceSlider("Distance Rate", perKmRate, "per KM", (v) => setState(() => perKmRate = v), 50, 500),
          const SizedBox(height: 15),
          _coldStorageToggle(),
        ],
      ),
    );
  }

  Widget _priceSlider(String label, double val, String unit, Function(double) onChanged, double min, double max) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 14)),
            Text("KES ${val.toInt()} $unit", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, color: AppTheme.vibrantBlue)),
          ],
        ),
        Slider(value: val, min: min, max: max, activeColor: AppTheme.vibrantBlue, onChanged: onChanged),
      ],
    );
  }

  Widget _coldStorageToggle() {
    return GestureDetector(
      onTap: () => setState(() => hasColdStorage = !hasColdStorage),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: hasColdStorage ? AppTheme.vibrantBlue.withValues(alpha: 0.05) : const Color(0xFFF8FBFF),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(Icons.ac_unit_rounded, color: hasColdStorage ? AppTheme.vibrantBlue : Colors.grey, size: 20),
            const SizedBox(width: 12),
            Text("Cold Storage Equipped", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 13, color: hasColdStorage ? AppTheme.navyDark : Colors.grey)),
            const Spacer(),
            Icon(hasColdStorage ? Icons.check_circle_rounded : Icons.radio_button_off_rounded, color: hasColdStorage ? AppTheme.vibrantBlue : Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _docTile("License", Icons.badge_outlined, true),
        _docTile("Insurance", Icons.gavel_rounded, true),
        _docTile("Truck Front", Icons.camera_alt_outlined, false),
        _docTile("Health Cert", Icons.health_and_safety_outlined, false),
      ],
    );
  }

  Widget _docTile(String label, IconData icon, bool isVerified) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isVerified ? AppTheme.vibrantBlue : Colors.grey),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 13)),
          Text(isVerified ? "Verified" : "Upload", style: GoogleFonts.urbanist(fontSize: 10, color: isVerified ? Colors.green : AppTheme.vibrantBlue, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.navyDark, size: 22),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 15)),
            Text(sub, style: GoogleFonts.urbanist(fontSize: 12, color: Colors.grey)),
          ])),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(children: [
      Icon(icon, size: 18, color: AppTheme.navyDark),
      const SizedBox(width: 10),
      Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 17, color: AppTheme.navyDark)),
    ]);
  }

  Widget _buildLogoutButton() {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text("Sign Out of Account", style: GoogleFonts.urbanist(color: Colors.redAccent, fontWeight: FontWeight.w800, fontSize: 15)),
      ),
    );
  }
}