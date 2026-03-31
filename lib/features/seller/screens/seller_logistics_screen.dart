import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

class SellerLogisticsScreen extends StatefulWidget {
  const SellerLogisticsScreen({super.key});

  @override
  State<SellerLogisticsScreen> createState() => _SellerLogisticsScreenState();
}

class _SellerLogisticsScreenState extends State<SellerLogisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isDeviceConnected = true; // Mock connection state

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBFF),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 100),
                _buildShipmentTabs(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildActiveShipments(),
                      _buildShipmentHistory(),
                    ],
                  ),
                ),
              ],
            ),
            _buildBlurHeader(),
            _buildCustomFloatingButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBlurHeader() {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 20, left: 20, right: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Fleet & Logistics",
                            style: GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
                        const SizedBox(width: 8),
                        // Connection Indicator
                        Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            color: isDeviceConnected ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    Text("3 active deliveries",
                        style: GoogleFonts.urbanist(fontSize: 13, color: AppTheme.vibrantBlue, fontWeight: FontWeight.w700)),
                  ],
                ),
                _roundIconButton(Icons.map_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Shipment Detail Panel (The "X" fix) ---
  void _openShipmentDetails(String id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Shipment $id", style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w900)),
                // THE X BUTTON: Ensure this only pops the sheet
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  style: IconButton.styleFrom(backgroundColor: const Color(0xFFF8FBFF)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Mock content for details
            _detailRow(Icons.thermostat, "Sensor Status", "Live - 4.2°C"),
            _detailRow(Icons.battery_charging_full, "Tracker Battery", "88%"),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.navyDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text("CONTACT DRIVER", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.vibrantBlue),
          const SizedBox(width: 15),
          Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, color: Colors.grey[600])),
          const Spacer(),
          Text(value, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
        ],
      ),
    );
  }

  Widget _buildShipmentTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 50,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade100)),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(color: AppTheme.vibrantBlue, borderRadius: BorderRadius.circular(12)),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        labelStyle: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [Tab(text: "Active"), Tab(text: "Delivered")],
      ),
    );
  }

  Widget _buildActiveShipments() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      physics: const BouncingScrollPhysics(),
      children: [
        GestureDetector(
          onTap: () => _openShipmentDetails("#TRK-9921"),
          child: _shipmentCard(
            id: "#TRK-9921",
            status: "In Transit",
            item: "Premium King Prawns (40kg)",
            origin: "Old Port Station",
            destination: "City Market Wholesaler",
            driver: "James Mwangi",
            temp: "4.2°C",
            progress: 0.65,
          ),
        ),
      ],
    );
  }

  Widget _buildShipmentHistory() => Center(child: Text("History logs will appear here", style: GoogleFonts.urbanist(color: Colors.grey)));

  Widget _shipmentCard({required String id, required String status, required String item, required String origin, required String destination, required String driver, required String temp, required double progress}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: Colors.grey)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.vibrantBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: GoogleFonts.urbanist(color: AppTheme.vibrantBlue, fontWeight: FontWeight.w800, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(item, style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
          const SizedBox(height: 20),
          _routePoint(Icons.radio_button_checked, origin, "Origin"),
          Padding(padding: const EdgeInsets.only(left: 11), child: Container(width: 2, height: 20, color: Colors.grey.shade100)),
          _routePoint(Icons.location_on, destination, "Destination"),
          const SizedBox(height: 20),
          LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade100, color: AppTheme.vibrantBlue, minHeight: 6, borderRadius: BorderRadius.circular(10)),
        ],
      ),
    );
  }

  Widget _routePoint(IconData icon, String city, String label) {
    return Row(
      children: [
        Icon(icon, size: 24, color: label == "Origin" ? Colors.grey : AppTheme.vibrantBlue),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: GoogleFonts.urbanist(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w700)),
          Text(city, style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.navyDark)),
        ])
      ],
    );
  }

  Widget _buildCustomFloatingButton() {
    return Positioned(
      bottom: 110,
      right: 20,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: AppTheme.vibrantBlue, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppTheme.vibrantBlue.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))]),
          child: const Icon(Icons.local_shipping_outlined, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _roundIconButton(IconData icon) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF8FBFF), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: AppTheme.navyDark, size: 20));
}