import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

class DriversDashboardScreen extends StatefulWidget {
  const DriversDashboardScreen({super.key});

  @override
  State<DriversDashboardScreen> createState() => _DriversDashboardScreenState();
}

class _DriversDashboardScreenState extends State<DriversDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBFF),
        body: Stack(
          children: [
            // 1. Main Scrollable Content
            ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 130, // Space for the fixed greeting
                left: 20,
                right: 20,
                bottom: 40,
              ),
              children: [
                _buildEarningsCard(),
                const SizedBox(height: 30),
                _buildSectionHeader("Live Opportunities"),
                const SizedBox(height: 15),
                _buildJobCard(
                  cargoType: "Fresh Tuna (200kg)",
                  pickup: "Mombasa Port - Dock 4",
                  dropoff: "Nyali Fresh Market",
                  price: "KES 4,500",
                  distance: "12.4 km",
                  color: AppTheme.vibrantBlue,
                ),
                _buildJobCard(
                  cargoType: "Boat Engine Parts",
                  pickup: "Marine Supply Co.",
                  dropoff: "Kilindini Harbour",
                  price: "KES 2,800",
                  distance: "5.2 km",
                  color: Colors.orangeAccent,
                ),
                _buildJobCard(
                  cargoType: "Ice & Storage Crates",
                  pickup: "Ice Plant North",
                  dropoff: "Shimoni Pier",
                  price: "KES 8,200",
                  distance: "45.0 km",
                  color: Colors.teal,
                ),
              ],
            ),

            // 2. Fixed Glassmorphism Header
            _buildBlurredHeader(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBlurredHeader(BuildContext context) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 20,
              left: 20, right: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              border: Border(bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
            ),
            child: _buildDriverGreetingRow(),
          ),
        ),
      ),
    );
  }

  Widget _buildDriverGreetingRow() {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.vibrantBlue.withValues(alpha: 0.3), width: 2),
              ),
              child: const CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400"),
              ),
            ),
            Positioned(
              bottom: 2, right: 2,
              child: Container(
                height: 12, width: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF00C853),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Good Morning,", style: GoogleFonts.urbanist(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13)),
              Text("Hassan Ali", style: GoogleFonts.urbanist(color: AppTheme.navyDark, fontWeight: FontWeight.w900, fontSize: 20)),
            ],
          ),
        ),
        _buildNotificationIcon(),
      ],
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppTheme.navyDark,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: AppTheme.navyDark.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Weekly Revenue", style: GoogleFonts.urbanist(color: Colors.white60, fontWeight: FontWeight.w600, fontSize: 13)),
              Text("+12.5%", style: GoogleFonts.urbanist(color: Colors.greenAccent, fontWeight: FontWeight.w700, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Text("KES 42,500.00", style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28)),
          const SizedBox(height: 25),
          _buildMiniChart(), // The Statistics Bar Graph
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem("Trips", "24"),
              _statItem("Hours", "38h"),
              _statItem("Distance", "412km"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChart() {
    final heights = [30.0, 45.0, 25.0, 50.0, 60.0, 35.0, 45.0];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (index) => Container(
        width: (MediaQuery.of(context).size.width - 140) / 7,
        height: heights[index],
        decoration: BoxDecoration(
          color: index == 4 ? AppTheme.vibrantBlue : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
      )),
    );
  }

  Widget _buildJobCard({required String cargoType, required String pickup, required String dropoff, required String price, required String distance, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
        boxShadow: [BoxShadow(color: AppTheme.navyDark.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _badge(cargoType, color),
              Text(price, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.navyDark)),
            ],
          ),
          const SizedBox(height: 20),
          _locationRow(Icons.circle_outlined, pickup, AppTheme.vibrantBlue),
          _vLine(),
          _locationRow(Icons.location_on_rounded, dropoff, Colors.redAccent),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(distance, style: GoogleFonts.urbanist(color: Colors.grey, fontWeight: FontWeight.w700, fontSize: 12)),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navyDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text("Accept Load", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _statItem(String label, String value) => Column(children: [
    Text(value, style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
    Text(label, style: GoogleFonts.urbanist(color: Colors.white38, fontWeight: FontWeight.w600, fontSize: 11)),
  ]);

  Widget _badge(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
    child: Text(text, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 11, color: color)),
  );

  Widget _locationRow(IconData icon, String text, Color color) => Row(children: [
    Icon(icon, size: 18, color: color),
    const SizedBox(width: 12),
    Expanded(child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 14))),
  ]);

  Widget _vLine() => Padding(padding: const EdgeInsets.only(left: 8.5), child: Container(width: 1, height: 20, color: Colors.grey.shade200));

  Widget _buildSectionHeader(String title) => Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.navyDark));

  Widget _buildNotificationIcon() => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
    child: const Icon(Icons.notifications_none_rounded, color: AppTheme.navyDark, size: 20),
  );
}