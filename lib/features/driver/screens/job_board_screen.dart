import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

class DriverJobBoardScreen extends StatefulWidget {
  const DriverJobBoardScreen({super.key});

  @override
  State<DriverJobBoardScreen> createState() => _DriverJobBoardScreenState();
}

class _DriverJobBoardScreenState extends State<DriverJobBoardScreen> {
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
            // 1. Main Scrollable List
            ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 160, // Adjusted for larger profile header
                left: 20,
                right: 20,
                bottom: 60,
              ),
              children: [
                _buildSectionLabel("Live Opportunities"),
                const SizedBox(height: 15),
                _buildJobCard(
                  cargoType: "Fresh Tuna (200kg)",
                  pickup: "Mombasa Port - Dock 4",
                  dropoff: "Nyali Fresh Market",
                  price: "KES 4,500",
                  distance: "12.4 km",
                  time: "Pickup: 2:00 PM",
                  color: AppTheme.vibrantBlue,
                ),
                _buildJobCard(
                  cargoType: "Boat Engine Parts",
                  pickup: "Marine Supply Co.",
                  dropoff: "Kilindini Harbour",
                  price: "KES 2,800",
                  distance: "5.2 km",
                  time: "Pickup: ASAP",
                  color: Colors.orangeAccent,
                ),
                _buildJobCard(
                  cargoType: "Ice & Storage Crates",
                  pickup: "Ice Plant North",
                  dropoff: "Shimoni Pier",
                  price: "KES 8,200",
                  distance: "45.0 km",
                  time: "Pickup: Tomorrow",
                  color: Colors.teal,
                ),
              ],
            ),

            // 2. Blurred Profile & Greeting Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 10,
                      bottom: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      border: Border(
                        bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05), width: 1),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDriverGreetingRow(),
                        const SizedBox(height: 20),
                        _buildFilterTabs(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverGreetingRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Driver Avatar with Online Status
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.vibrantBlue.withValues(alpha: 0.3), width: 2),
                ),
                child: const CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400"),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  height: 14, width: 14,
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
          // Greeting Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Good Morning,",
                    style: GoogleFonts.urbanist(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13)),
                Text("Hassan Ali",
                    style: GoogleFonts.urbanist(color: AppTheme.navyDark, fontWeight: FontWeight.w900, fontSize: 22)),
              ],
            ),
          ),
          // Notification/Quick Actions
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: const Icon(Icons.notifications_none_rounded, color: AppTheme.navyDark, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(text,
        style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.navyDark, letterSpacing: 0.5));
  }

  Widget _buildFilterTabs() {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          _filterChip("All Loads", true),
          _filterChip("Urgent", false),
          _filterChip("High Pay", false),
          _filterChip("Nearby", false),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.navyDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? Colors.transparent : Colors.grey.shade200),
      ),
      child: Text(label,
          style: GoogleFonts.urbanist(
              color: isActive ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.w700,
              fontSize: 12
          )),
    );
  }

  Widget _buildJobCard({
    required String cargoType,
    required String pickup,
    required String dropoff,
    required String price,
    required String distance,
    required String time,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navyDark.withValues(alpha: 0.03),
            blurRadius: 25,
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(cargoType,
                    style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 11, color: color, letterSpacing: 0.5)),
              ),
              Text(price,
                  style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 19, color: AppTheme.navyDark)),
            ],
          ),
          const SizedBox(height: 25),
          _buildLocationRow(Icons.circle_outlined, pickup, isLast: false),
          Padding(
            padding: const EdgeInsets.only(left: 11),
            child: Container(width: 1, height: 25, color: Colors.grey.shade200),
          ),
          _buildLocationRow(Icons.location_on_rounded, dropoff, isLast: true),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.speed_rounded, size: 16, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(distance, style: GoogleFonts.urbanist(color: Colors.grey, fontWeight: FontWeight.w700, fontSize: 12)),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navyDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  elevation: 0,
                ),
                child: Text("Accept Load", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, String address, {required bool isLast}) {
    return Row(
      children: [
        Icon(icon, size: 22, color: isLast ? Colors.redAccent : AppTheme.vibrantBlue),
        const SizedBox(width: 15),
        Expanded(
          child: Text(address,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.navyDark)),
        ),
      ],
    );
  }
}