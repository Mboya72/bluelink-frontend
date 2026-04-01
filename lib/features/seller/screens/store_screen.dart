import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SellerStoreScreen extends StatefulWidget {
  const SellerStoreScreen({super.key});

  @override
  State<SellerStoreScreen> createState() => _SellerStoreScreenState();
}

class _SellerStoreScreenState extends State<SellerStoreScreen> {
  bool isOnline = true;
  bool pushNotifications = true;
  int selectedPlanIndex = 0;


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F8FE),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildHeader(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildStoreProfileCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Inventory & Capacity"),
                  const SizedBox(height: 12),
                  _buildCapacityCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Account Settings"),
                  const SizedBox(height: 12),
                  _buildSettingsGroup([
                    _settingsTile(Icons.payments_outlined, "Payout Settings", "Manage M-Pesa & Bank details", Colors.green),
                    _settingsTile(Icons.verified_user_outlined, "Business Verification", "Level 2 Verified", Colors.blue),
                    _settingsTile(Icons.history_edu_outlined, "Tax Information", "KRA PIN: P051...12Z", Colors.orange),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Preferences"),
                  const SizedBox(height: 12),
                  _buildToggleCard("Store Visibility", "Currently appearing to buyers", isOnline, (val) => setState(() => isOnline = val)),
                  const SizedBox(height: 12),
                  _buildToggleCard("Push Notifications", "Critical shipment alerts", pushNotifications, (val) => setState(() => pushNotifications = val)),
                  const SizedBox(height: 25),
                  _buildPricingSection(),
                  const SizedBox(height: 40),
                  _buildLogoutButton(),
                  const SizedBox(height: 100), // Padding for Bottom Nav
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 120,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Text(
          "My Store",
          style: GoogleFonts.urbanist(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1A237E),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit_note_rounded, color: Color(0xFF1A237E)),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Subscription Plan"),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _pricingCard(
                index: 0,
                title: "Starter",
                price: "1,500",
                features: ["5 Shipments/mo", "Basic Tracking"],
                color: Colors.teal,
              ),
              _pricingCard(
                index: 1,
                title: "Pro",
                price: "4,500",
                features: ["Unlimited Ships", "IoT Temp Logs", "Priority"],
                color: const Color(0xFF1A237E),
              ),
              _pricingCard(
                index: 2,
                title: "Enterprise",
                price: "12,000",
                features: ["Custom Fleet", "API Access", "Dedicated Ops"],
                color: Colors.purple,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildActivePlanSummary(),
      ],
    );
  }

  Widget _pricingCard({
    required int index,
    required String title,
    required String price,
    required List<String> features,
    required Color color,
  }) {
    bool isSelected = selectedPlanIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedPlanIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.transparent : color.withValues(alpha: 0.1),
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: isSelected ? Colors.white : color,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ksh ", style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? Colors.white70 : Colors.grey)),
                Text(price, style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w900, color: isSelected ? Colors.white : Colors.black87)),
              ],
            ),
            const SizedBox(height: 16),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text("• $f", style: GoogleFonts.urbanist(fontSize: 10, color: isSelected ? Colors.white70 : Colors.grey[600], fontWeight: FontWeight.w600)),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePlanSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.indigo, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "You are currently on the ${selectedPlanIndex == 1 ? 'Pro' : selectedPlanIndex == 0 ? 'Starter' : 'Enterprise'} plan. Billing cycle ends in 24 days.",
              style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text("Invoice", style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.indigo)),
          )
        ],
      ),
    );
  }

  Widget _planFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.indigo),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=9"),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mombasa DeepSea Ltd",
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Premium Seller • Joined Feb 2026",
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 28),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _profileStat("4.9", "Rating"),
              _profileStat("1.2k", "Sales"),
              _profileStat("Active", "Status"),
            ],
          )
        ],
      ),
    );
  }

  Widget _profileStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(label, style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white60)),
      ],
    );
  }

  Widget _buildCapacityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Cold Storage Usage", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
              Text("840kg / 1000kg", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.indigo)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.84,
              minHeight: 8,
              backgroundColor: Color(0xFFF3F8FE),
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(children: children),
    );
  }

  Widget _settingsTile(IconData icon, String title, String subtitle, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
      subtitle: Text(subtitle, style: GoogleFonts.urbanist(fontSize: 11, color: Colors.grey[500])),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
    );
  }

  Widget _buildToggleCard(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF1A237E),
        title: Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
        subtitle: Text(subtitle, style: GoogleFonts.urbanist(fontSize: 11, color: Colors.grey[500])),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.urbanist(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Colors.grey[500],
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
        label: Text(
          "Logout from Bluelink",
          style: GoogleFonts.urbanist(color: Colors.redAccent, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
