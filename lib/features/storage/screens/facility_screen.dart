import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class FacilityDashboardScreen extends StatefulWidget {
  const FacilityDashboardScreen({super.key});

  @override
  State<FacilityDashboardScreen> createState() => _FacilityDashboardScreenState();
}

class _FacilityDashboardScreenState extends State<FacilityDashboardScreen> {
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
            // 1. Main Scrolling Content
            _buildScrollingContent(),

            // 2. Sticky Glass Header with .withValues()
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
            color: Colors.white.withValues(alpha: 0.7),
            border: Border(
              bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Lamu North Facility",
                        style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF0D1231))),
                    Text("Welcome back, Alex",
                        style: GoogleFonts.urbanist(fontSize: 11, color: Colors.blueGrey[400], fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              _iconButton(Icons.qr_code_scanner_rounded),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatGrid(),
          const SizedBox(height: 25),
          _buildSectionHeader("Volume Analytics", "Last 7 Days"),
          const SizedBox(height: 15),
          _buildAnalyticsChart(),
          const SizedBox(height: 25),
          _buildSectionHeader("Active Storage Zones", "Live Feed"),
          const SizedBox(height: 15),
          _buildZoneCards(),
          const SizedBox(height: 25),
          _buildSectionHeader("Pending Handovers", "3 Actions"),
          const SizedBox(height: 15),
          _buildPendingTasks(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildStatGrid() {
    return Row(
      children: [
        Expanded(child: _statCard("Total Items", "4,280", Icons.inventory_2_outlined, Colors.blue)),
        const SizedBox(width: 15),
        Expanded(child: _statCard("Revenue", "KSh 124K", Icons.payments_outlined, Colors.green)),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 15),
          Text(value, style: GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF0D1231))),
          Text(label, style: GoogleFonts.urbanist(fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildAnalyticsChart() {
    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Occupancy Trend", style: GoogleFonts.urbanist(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
              Text("+12% vs last week", style: GoogleFonts.urbanist(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          SizedBox(height: 80, width: double.infinity, child: CustomPaint(painter: ChartPainter())),
        ],
      ),
    );
  }

  Widget _buildZoneCards() {
    return SizedBox(
      height: 130,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _zoneItem("Deep Freeze", "-18.5°C", 0.85, Colors.blue),
          _zoneItem("Chilled Zone", "2.1°C", 0.40, Colors.cyan),
          _zoneItem("Dry Bay", "24.0°C", 0.65, Colors.orange),
        ],
      ),
    );
  }

  Widget _zoneItem(String name, String temp, double fill, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F4F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
          Row(
            children: [
              Icon(Icons.thermostat_rounded, size: 12, color: color),
              const SizedBox(width: 4),
              Text(temp, style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(value: fill, backgroundColor: color.withValues(alpha: 0.1), color: color, minHeight: 4),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTasks() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(Icons.local_shipping_outlined, color: Colors.orange[800], size: 20),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Inbound: Truck KBZ 442Y", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
                    Text("Arriving in 14 mins", style: GoogleFonts.urbanist(fontSize: 12, color: Colors.blueGrey[400])),
                  ],
                ),
              ),
              _smallActionBtn("Assign Bay"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w900, color: const Color(0xFF0D1231))),
            Text(subtitle, style: GoogleFonts.urbanist(fontSize: 12, color: Colors.blueGrey[300], fontWeight: FontWeight.w700)),
          ],
        ),
        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.blueGrey),
      ],
    );
  }

  Widget _iconButton(IconData icon) {
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

  Widget _smallActionBtn(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF1A237E), borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: GoogleFonts.urbanist(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
    );
  }
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white.withValues(alpha: 0.2), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.2, size.height * 0.6);
    path.lineTo(size.width * 0.4, size.height * 0.75);
    path.lineTo(size.width * 0.6, size.height * 0.4);
    path.lineTo(size.width * 0.8, size.height * 0.5);
    path.lineTo(size.width, size.height * 0.2);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}