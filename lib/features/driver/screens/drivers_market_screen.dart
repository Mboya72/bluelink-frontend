import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

class DriversMarketScreen extends StatefulWidget {
  const DriversMarketScreen({super.key});

  @override
  State<DriversMarketScreen> createState() => _DriversMarketScreenState();
}

class _DriversMarketScreenState extends State<DriversMarketScreen> {
  int activeTab = 0; // 0: Spares, 1: Services

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBFF),
        body: Column(
          children: [
            _buildMarketHeader(),
            _buildCategoryTabs(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: activeTab == 0 ? _buildSparesGrid() : _buildServicesList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20, right: 20, bottom: 25,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
      ),
      child: Column(
        children: [
          // 1. Top Row: Title & Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Truck Shop", style: GoogleFonts.urbanist(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
                  Text("Pro Spares & Services", style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
                ],
              ),
              Row(
                children: [
                  _actionIcon(Icons.favorite_outline_rounded, Colors.redAccent, "5"),
                  const SizedBox(width: 8),
                  _actionIcon(Icons.shopping_bag_outlined, AppTheme.vibrantBlue, "2"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),

          // 2. Wallet & Balance Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.navyDark,
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                image: const NetworkImage("https://www.transparenttextures.com/patterns/carbon-fibre.png"),
                opacity: 0.1,
                repeat: ImageRepeat.repeat,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("AVAILABLE BALANCE", style: GoogleFonts.urbanist(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Text("KES 42,500.00", style: GoogleFonts.urbanist(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.vibrantBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text("PAY VIA WALLET", style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color, String count) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFF8FBFF), shape: BoxShape.circle),
          child: Icon(icon, color: AppTheme.navyDark, size: 22),
        ),
        Positioned(
          right: 0, top: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
            child: Text(count, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _tabButton("Truck Spares", 0, Icons.settings_outlined),
          const SizedBox(width: 15),
          _tabButton("Pro Services", 1, Icons.build_circle_outlined),
        ],
      ),
    );
  }

  Widget _tabButton(String label, int index, IconData icon) {
    bool isActive = activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => activeTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.navyDark : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isActive ? Colors.transparent : Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? Colors.white : Colors.grey, size: 18),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.urbanist(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.w800, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildSparesGrid() {
    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      crossAxisCount: 2,
      childAspectRatio: 0.72,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _spareCard("Heavy Duty Tire", "KES 12,500", "https://images.unsplash.com/photo-1549434842-12759e66380a?w=400", "4.8"),
        _spareCard("Engine Oil 5L", "KES 3,200", "https://images.unsplash.com/photo-1621570160413-5471909787bc?w=400", "5.0"),
        _spareCard("LED Headlight", "KES 1,800", "https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=400", "4.5"),
        _spareCard("Brake Pads Set", "KES 4,500", "https://images.unsplash.com/photo-1517524204709-440d890428de?w=400", "4.9"),
      ],
    );
  }

  Widget _buildServicesList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _serviceCard("Full Engine Checkup", "KES 5,000", "Certified Marine Mechanics", Icons.verified_user_rounded),
        _serviceCard("Oil Change & Filter", "KES 2,500", "Express Service Center", Icons.bolt),
        _serviceCard("Suspension Tuning", "KES 8,000", "Elite Truck Garage", Icons.shutter_speed_rounded),
      ],
    );
  }

  Widget _spareCard(String title, String price, String img, String rating) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: GoogleFonts.urbanist(color: AppTheme.vibrantBlue, fontWeight: FontWeight.w900, fontSize: 13)),
                    const Icon(Icons.favorite_border_rounded, size: 16, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceCard(String title, String price, String provider, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.grey.shade100)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppTheme.vibrantBlue.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: AppTheme.vibrantBlue),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 15)),
                Text(provider, style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
              const Icon(Icons.favorite_border_rounded, size: 16, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: const Color(0xFFF8FBFF), borderRadius: BorderRadius.circular(15)),
      child: const TextField(
        decoration: InputDecoration(hintText: "Search parts or services...", border: InputBorder.none, icon: Icon(Icons.search, color: Colors.grey, size: 20)),
      ),
    );
  }
}