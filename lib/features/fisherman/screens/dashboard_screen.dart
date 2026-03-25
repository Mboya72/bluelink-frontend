import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

class FishermanDashboard extends StatelessWidget {
  const FishermanDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF), // Soft azure background
      appBar: _buildAppBar(),
      // REMOVED bottomNavigationBar: Logic now lives in MainScaffold
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeatherCard(),
            const SizedBox(height: 25),
            _buildSectionHeader("Quick Actions"),
            const SizedBox(height: 15),
            _buildQuickActionsGrid(),
            const SizedBox(height: 30),
            _buildSectionHeader("Active Sales"), // Updated label per your table
            const SizedBox(height: 15),
            _buildActiveListings(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent, // Blends better with the background
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Good Morning,",
              style: GoogleFonts.urbanist(fontSize: 14, color: Colors.grey[600])),
          Text("Captain Nemo",
              style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.navyDark),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.vibrantBlue, AppTheme.vibrantBlue.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.vibrantBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Calm Seas",
                  style: GoogleFonts.urbanist(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("High Tide at 2:30 PM",
                  style: GoogleFonts.urbanist(color: Colors.white70, fontSize: 13)),
            ],
          ),
          const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 42),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.navyDark)),
        TextButton(
            onPressed: () {},
            child: Text("View all",
                style: GoogleFonts.urbanist(color: AppTheme.vibrantBlue, fontWeight: FontWeight.w700))),
      ],
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.4,
      children: [
        _actionCard("Post Catch", Icons.add_circle_outline, AppTheme.vibrantBlue),
        _actionCard("Earnings", Icons.payments_outlined, Colors.purple), // Per Table
        _actionCard("Inventory", Icons.inventory_2_outlined, Colors.teal),
        _actionCard("Sea Logs", Icons.waves, Colors.orange), // Per Table (Weather/Tides)
      ],
    );
  }

  Widget _actionCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 10),
          Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildActiveListings() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
                'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=100&h=100&fit=crop',
                width: 60, height: 60, fit: BoxFit.cover
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Yellowfin Tuna", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 16)),
                Text("12kg • Active Sale", style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
          Text("\$120",
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, color: AppTheme.vibrantBlue, fontSize: 18)),
        ],
      ),
    );
  }
}