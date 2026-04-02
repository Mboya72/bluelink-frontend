import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyerMarketplaceScreen extends StatefulWidget {
  const BuyerMarketplaceScreen({super.key});

  @override
  State<BuyerMarketplaceScreen> createState() => _BuyerMarketplaceScreenState();
}

class _BuyerMarketplaceScreenState extends State<BuyerMarketplaceScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FBFF), // Soft blue-tinted white
        bottomNavigationBar: _buildBottomNav(),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildBluelinkHeader(),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 20),
                    _buildSearchBar(),
                    const SizedBox(height: 25),
                    _buildMarinePromo(),
                    const SizedBox(height: 25),
                    _buildCategoryGrid(),
                    const SizedBox(height: 30),
                    _buildSectionHeader("Certified Suppliers"),
                    const SizedBox(height: 15),
                    _buildSupplierLogos(),
                    const SizedBox(height: 30),
                    _buildSectionHeader("Fresh Daily Catch"),
                    const SizedBox(height: 15),
                    _buildProductGrid(),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBluelinkHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFF1A237E),
              child: Icon(Icons.person, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Maina Chengo",
                        style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: Colors.blue, size: 14),
                  ],
                ),
                Text("Mombasa, Kenya",
                    style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const Spacer(),
            _iconButton(Icons.anchor_rounded), // Themed icon
            const SizedBox(width: 10),
            _iconBadgeButton(Icons.notifications_none_rounded, "5"),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF1A237E).withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.indigo[200]),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for Tuna, Prawns, or Hooks...",
                hintStyle: GoogleFonts.urbanist(color: Colors.grey[400], fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.tune_rounded, color: const Color(0xFF1A237E), size: 20),
        ],
      ),
    );
  }

  Widget _buildMarinePromo() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF283593)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10, bottom: -10,
            child: Icon(Icons.waves_rounded, size: 180, color: Colors.white.withValues(alpha: 0.05)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("BULK BUYER OFFERS", style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white70, letterSpacing: 1.2)),
                const SizedBox(height: 8),
                Text("Yellowfin Tuna", style: GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                Text("15% OFF Bulk Orders", style: GoogleFonts.urbanist(fontSize: 14, color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w600)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text("Order Now", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {"n": "Fresh Fish", "i": "🐟"},
      {"n": "Shellfish", "i": "🦞"},
      {"n": "Fishing Gear", "i": "🪝"},
      {"n": "Ice & Cold", "i": "🧊"},
      {"n": "Boats", "i": "🚤"},
    ];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categories.map((c) => _categoryCircle(c['n']!, c['i']!)).toList(),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFF1A237E).withValues(alpha: 0.08)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.dashboard_customize_rounded, color: Color(0xFF1A237E), size: 18),
              const SizedBox(width: 8),
              Text("View All Marketplace", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: const Color(0xFF1A237E))),
            ],
          ),
        )
      ],
    );
  }

  Widget _categoryCircle(String name, String icon) {
    return Column(
      children: [
        Container(
          height: 55, width: 55,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: const Color(0xFF1A237E).withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]
          ),
          alignment: Alignment.center,
          child: Text(icon, style: const TextStyle(fontSize: 24)),
        ),
        const SizedBox(height: 8),
        Text(name, style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF1A237E))),
      ],
    );
  }

  Widget _buildSupplierLogos() {
    final suppliers = ["Lamu Fresh", "Mombasa Sea", "Watamu Ice", "Kilifi Net", "Diani Hook"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: suppliers.map((s) => _supplierIcon(s)).toList(),
      ),
    );
  }

  Widget _supplierIcon(String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 18),
      child: Column(
        children: [
          CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFE8EAF6),
              child: Text(name[0], style: const TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.w900))
          ),
          const SizedBox(height: 8),
          Text(name, style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Row(
      children: [
        Expanded(child: _fishCard("Giant Prawns", "Ksh 2,400/kg", "https://images.unsplash.com/photo-1559742811-822873691df0?q=80&w=1000&auto=format&fit=crop")),
        const SizedBox(width: 15),
        Expanded(child: _fishCard("Red Snapper", "Ksh 850/kg", "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?q=80&w=1000&auto=format&fit=crop")),
      ],
    );
  }

  Widget _fishCard(String name, String price, String url) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Image.network(url, height: 110, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  left: 8, top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF1A237E), borderRadius: BorderRadius.circular(8)),
                    child: const Text("Daily Catch", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(name, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 14, color: const Color(0xFF1A237E))),
          const SizedBox(height: 4),
          Text(price, style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.indigo[400])),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.urbanist(fontSize: 17, fontWeight: FontWeight.w900, color: const Color(0xFF1A237E))),
        Text("View all", style: GoogleFonts.urbanist(fontSize: 12, color: Colors.indigo, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _iconButton(IconData icon) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF1A237E).withValues(alpha: 0.1))), child: Icon(icon, size: 20, color: const Color(0xFF1A237E)));

  Widget _iconBadgeButton(IconData icon, String count) => Stack(children: [ _iconButton(icon), Positioned(right: 0, top: 0, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle), child: Text(count, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))))]);

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF1A237E),
      unselectedItemColor: Colors.grey[400],
      showSelectedLabels: true,
      elevation: 20,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: "Market"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "Orders"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }
}
