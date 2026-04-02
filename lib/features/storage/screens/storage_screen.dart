import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFE),
        body: Stack(
          children: [
            _buildScrollingContent(),
            _buildStickyHeader(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyHeader(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: topPadding + 10,
            bottom: 15,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Welcome back,",
                      style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey[400])),
                  Text("Lamu Cold Storage",
                      style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFF0D1231))),
                ],
              ),
              _headerIcon(Icons.notifications_none_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrollingContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: MediaQuery.of(context).padding.top + 90,
        bottom: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCapacityCard(),
          const SizedBox(height: 25),
          _buildSectionHeader("Climate Monitor"),
          const SizedBox(height: 15),
          _buildLiveTempGrid(),
          const SizedBox(height: 25),
          _buildSectionHeader("Quick Statistics"),
          const SizedBox(height: 15),
          _buildStatsRow(),
          const SizedBox(height: 25),
          _buildSectionHeader("Recent Photos"),
          const SizedBox(height: 15),
          _buildFacilityPhotos(),
        ],
      ),
    );
  }

  Widget _buildCapacityCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: const Color(0xFF1A237E).withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Capacity", style: GoogleFonts.urbanist(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text("78%", style: GoogleFonts.urbanist(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                Text("1,240kg / 1,600kg used", style: GoogleFonts.urbanist(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80, width: 80,
                child: CircularProgressIndicator(
                  value: 0.78,
                  strokeWidth: 10,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                  strokeCap: StrokeCap.round,
                ),
              ),
              const Icon(Icons.inventory_2_rounded, color: Colors.white, size: 24),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLiveTempGrid() {
    return Row(
      children: [
        _tempIndicator("Cold Room A", "-18.4°C", Colors.blue, Icons.ac_unit_rounded),
        const SizedBox(width: 15),
        _tempIndicator("Dry Bay B1", "22.1°C", Colors.orange, Icons.wb_sunny_outlined),
      ],
    );
  }

  Widget _tempIndicator(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F4F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 15),
            Text(value, style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFF0D1231))),
            Text(label, style: GoogleFonts.urbanist(fontSize: 12, color: Colors.blueGrey[300], fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _miniStat("12", "Active Bookings"),
        _miniStat("4", "Arrivals Today"),
        _miniStat("KSh 42k", "Weekly Rev"),
      ],
    );
  }

  Widget _miniStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 18, color: const Color(0xFF1A237E))),
        Text(label, style: GoogleFonts.urbanist(fontSize: 11, color: Colors.blueGrey[400], fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildFacilityPhotos() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: NetworkImage("https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=400"),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w900, color: const Color(0xFF0D1231)));
  }

  Widget _headerIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF1F4F9))
      ),
      child: Icon(icon, color: const Color(0xFF1A237E), size: 20),
    );
  }
}