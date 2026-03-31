import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'new_delivery_screen.dart';

class SellerLogisticsScreen extends StatefulWidget {
  const SellerLogisticsScreen({super.key});

  @override
  State<SellerLogisticsScreen> createState() => _SellerLogisticsScreenState();
}

class _SellerLogisticsScreenState extends State<SellerLogisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bool isDeviceConnected = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- FEATURE: Live Map Overlay ---
  void _showLiveMap() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Map",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, _, __) => Scaffold(
        body: Stack(
          children: [
            Container(
              color: const Color(0xFFE5E5E5),
              child: const Center(child: Icon(Icons.map_rounded, size: 100, color: Colors.white)),
            ),
            Positioned(
              top: 50, left: 20,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1A237E)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Positioned(
              bottom: 40, left: 20, right: 20,
              child: _shipmentCard(
                id: "MAP-9921",
                item: "On Map: King Prawns",
                weight: "40kg",
                status: "Moving",
                temp: "4.2°C",
                driver: "James Mwangi",
                progress: 0.65,
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- FEATURE: Detailed Bottom Sheet ---
  void _openShipmentDetails(String id, String temp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Shipment $id", style: GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF1A237E))),
                _buildTempBadge(temp),
              ],
            ),
            const SizedBox(height: 30),
            _detailItem(Icons.thermostat_rounded, "Sensor Status", "Live Monitoring", Colors.orange),
            _detailItem(Icons.battery_charging_full_rounded, "IoT Battery", "88%", Colors.green),
            _detailItem(Icons.timer_rounded, "Est. Arrival", "14:30 PM", Colors.blue),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text("CONTACT DRIVER", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F8FE),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildStickyHeader(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildFleetOverview(),
                  const SizedBox(height: 24),
                  _buildSearchAndFilter(),
                  const SizedBox(height: 20),
                  _buildTabToggle(),
                  const SizedBox(height: 16),
                  _tabController.index == 0 ? _buildActiveShipmentsList() : _buildShipmentHistory(),
                ]),
              ),
            ),
          ],
        ),
        floatingActionButton: _buildFab(),
      ),
    );
  }

  Widget _buildStickyHeader() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white.withValues(alpha: 0.8),
      toolbarHeight: 65,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Fleet & Logistics", style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFF1A237E))),
              const SizedBox(width: 8),
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                    color: isDeviceConnected ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.3), blurRadius: 4, spreadRadius: 2)]
                ),
              ),
            ],
          ),
          Text("System Online", style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey[500])),
        ],
      ),
      actions: [
        IconButton(onPressed: _showLiveMap, icon: const Icon(Icons.map_outlined, color: Color(0xFF1A237E))),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildFleetOverview() {
    return Row(
      children: [
        _miniStatusCard("Active Vans", "08", Icons.local_shipping_rounded, Colors.indigo),
        const SizedBox(width: 12),
        _miniStatusCard("Cold Storage", "94%", Icons.ac_unit_rounded, Colors.cyan),
      ],
    );
  }

  Widget _miniStatusCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w900, color: const Color(0xFF1A237E))),
                Text(label, style: GoogleFonts.urbanist(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          ),
          child: TextField(
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 14),
            decoration: InputDecoration(
              icon: const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
              hintText: "Search shipment ID or driver...",
              hintStyle: GoogleFonts.urbanist(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _filterChip("All", true),
              _filterChip("In Transit", false),
              _filterChip("Loading", false),
              _filterChip("High Temp", false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterChip(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1A237E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w800, color: isActive ? Colors.white : Colors.grey[600])),
    );
  }

  Widget _buildTabToggle() {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: const Color(0xFF1A237E).withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF1A237E),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: const Color(0xFF1A237E).withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[400],
        labelStyle: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 14),
        tabs: const [Tab(text: "Active"), Tab(text: "History")],
      ),
    );
  }

  Widget _buildActiveShipmentsList() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _openShipmentDetails("BLU-9921", "4.2°C"),
          child: _shipmentCard(id: "BLU-9921", item: "Premium King Prawns", weight: "40kg", status: "In Transit", temp: "4.2°C", driver: "James Mwangi", progress: 0.65),
        ),
        GestureDetector(
          onTap: () => _openShipmentDetails("BLU-8842", "2.8°C"),
          child: _shipmentCard(id: "BLU-8842", item: "Yellowfin Tuna", weight: "120kg", status: "Loading", temp: "2.8°C", driver: "Sarah Kamau", progress: 0.15),
        ),
      ],
    );
  }

  Widget _buildShipmentHistory() => Padding(padding: const EdgeInsets.symmetric(vertical: 60), child: Center(child: Text("No history found", style: GoogleFonts.urbanist(color: Colors.grey))));

  Widget _shipmentCard({required String id, required String item, required String weight, required String status, required String temp, required String driver, required double progress}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFF3F8FE), borderRadius: BorderRadius.circular(8)), child: Text(id, style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.indigo))),
              _buildTempBadge(temp),
            ],
          ),
          const SizedBox(height: 16),
          Text(item, style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w900, color: const Color(0xFF1A237E))),
          Text("$weight • $driver", style: GoogleFonts.urbanist(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: const Color(0xFFF3F8FE), color: const Color(0xFF3F51B5))),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(status, style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.green)),
              Text("${(progress * 100).toInt()}%", style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTempBadge(String temp) => Row(children: [const Icon(Icons.ac_unit, size: 14, color: Colors.cyan), const SizedBox(width: 4), Text(temp, style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.cyan))]);

  Widget _detailItem(IconData icon, String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 16),
          Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, color: Colors.grey[600])),
          const Spacer(),
          Text(value, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, color: const Color(0xFF1A237E))),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return Padding(
      // Adjust the bottom value based on your specific Nav Bar height
      padding: const EdgeInsets.only(bottom: 95, right: 5),
      child: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Crucial for keyboard handling
            backgroundColor: Colors.transparent,
            builder: (context) => const NewDeliverySheet(),
          );
        },
        elevation: 4,
        backgroundColor: const Color(0xFF1A237E),
        icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
        label: Text(
          "New Delivery",
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}