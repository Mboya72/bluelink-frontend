import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class StorageSettingsScreen extends StatefulWidget {
  const StorageSettingsScreen({super.key});

  @override
  State<StorageSettingsScreen> createState() => _StorageSettingsScreenState();
}

class _StorageSettingsScreenState extends State<StorageSettingsScreen> {
  bool _isPublic = true;
  bool _tempAlerts = true;

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
              Text("Facility Settings",
                  style: GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF0D1231))),
              _headerIcon(Icons.save_as_rounded),
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
        bottom: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 30),
          _buildSectionTitle("Operational Controls"),
          _settingsTile("Storage Pricing", "KSh 150 / kg / Day", Icons.payments_outlined, Colors.green),
          _settingsTile("Operational Hours", "06:00 AM - 10:00 PM", Icons.schedule_rounded, Colors.blue),
          _switchTile("Public Marketplace", "Allow others to see/book space", _isPublic, (v) => setState(() => _isPublic = v)),

          const SizedBox(height: 25),
          _buildSectionTitle("Infrastructure & Safety"),
          _settingsTile("Zone Configuration", "3 Active Zones (Cold/Dry)", Icons.layers_outlined, Colors.orange),
          _settingsTile("Hardware Sync", "6 IoT Sensors Connected", Icons.sensors_rounded, Colors.cyan),
          _switchTile("Temperature Alerts", "Notify on ±2.0°C variance", _tempAlerts, (v) => setState(() => _tempAlerts = v)),

          const SizedBox(height: 25),
          _buildSectionTitle("Account & Legal"),
          _settingsTile("Business Documentation", "KRA & Health Permits", Icons.description_outlined, Colors.purple),
          _settingsTile("Security Protocols", "Gate Access & Staff PINs", Icons.lock_person_outlined, Colors.red),

          const SizedBox(height: 30),
          _buildLogoutBtn(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF1F4F9)),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Color(0xFF1A237E), shape: BoxShape.circle),
                child: const Icon(Icons.edit_rounded, color: Colors.white, size: 12),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Lamu North Facility", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 18)),
                Text("ID: BL-9920-STORAGE", style: GoogleFonts.urbanist(color: Colors.blueGrey[300], fontSize: 12, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          _smallActionBtn("Edit"),
        ],
      ),
    );
  }

  Widget _settingsTile(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F4F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
                Text(subtitle, style: GoogleFonts.urbanist(fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.blueGrey),
        ],
      ),
    );
  }

  Widget _switchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F4F9)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
                Text(subtitle, style: GoogleFonts.urbanist(fontSize: 11, color: Colors.blueGrey[400], fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF1A237E),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(title, style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.blueGrey[400], letterSpacing: 0.5)),
    );
  }

  Widget _buildLogoutBtn() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withValues(alpha: 0.1)),
      ),
      child: Center(
        child: Text("Logout Facility", style: GoogleFonts.urbanist(color: Colors.red[700], fontWeight: FontWeight.w800, fontSize: 15)),
      ),
    );
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

  Widget _smallActionBtn(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFF1F4F9), borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: GoogleFonts.urbanist(color: const Color(0xFF1A237E), fontSize: 12, fontWeight: FontWeight.w800)),
    );
  }
}