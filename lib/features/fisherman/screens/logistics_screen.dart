import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/app_theme.dart';

class LogisticsScreen extends StatefulWidget {
  const LogisticsScreen({super.key});

  @override
  State<LogisticsScreen> createState() => _LogisticsScreenState();
}

class _LogisticsScreenState extends State<LogisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _openLiveTracking(String id, Color themeColor) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => LiveTrackingMapScreen(trackingId: id, color: themeColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBFF),
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            const SizedBox(height: 110),
            _buildStatusOverview(),
            const SizedBox(height: 25),
            _buildTabSelector(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveShipments(),
                  _buildPastDeliveries(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text("Logistics",
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.navyDark)),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.navyDark)),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildStatusOverview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.navyDark,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: AppTheme.navyDark.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("In Transit", style: GoogleFonts.urbanist(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text("04 Shipments", style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(18)),
            child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 30),
          )
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 54,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]
        ),
        labelColor: AppTheme.navyDark,
        unselectedLabelColor: Colors.grey,
        labelStyle: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [Tab(text: "Active"), Tab(text: "History")],
      ),
    );
  }

  Widget _buildActiveShipments() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildLogisticsCard(
          id: "#TRK-8821",
          status: "On the way",
          destination: "Main Port Terminal",
          time: "Arrival in 45 mins",
          progress: 0.65,
          color: Colors.blueAccent,
        ),
        _buildLogisticsCard(
          id: "#TRK-9042",
          status: "Picking up",
          destination: "Nemo's Deep Sea",
          time: "Scheduled 2:00 PM",
          progress: 0.2,
          color: Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _buildPastDeliveries() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHistoryItem("Order #7712", "Delivered on March 28", "\$450.00"),
        _buildHistoryItem("Order #7690", "Delivered on March 25", "\$1,200.00"),
      ],
    );
  }

  Widget _buildLogisticsCard({required String id, required String status, required String destination, required String time, required double progress, required Color color}) {
    return GestureDetector(
      onTap: () => _openLiveTracking(id, color),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(id, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: Colors.grey, fontSize: 13)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text(status, style: GoogleFonts.urbanist(color: color, fontWeight: FontWeight.w800, fontSize: 11)),
                )
              ],
            ),
            const SizedBox(height: 15),
            Text(destination, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 17, color: AppTheme.navyDark)),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade100, color: color, minHeight: 8),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(time, style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
                const Spacer(),
                const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String title, String subtitle, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.grey.shade100)),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: Color(0xFFF6F5F0), child: Icon(Icons.check_circle, color: Colors.green, size: 20)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 15)),
                Text(subtitle, style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(amount, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// VIEW 2: LIVE TRACKING MAP (INTEGRATED WITH GOOGLE MAPS)
// ---------------------------------------------------------------------------

class LiveTrackingMapScreen extends StatefulWidget {
  final String trackingId;
  final Color color;

  const LiveTrackingMapScreen({super.key, required this.trackingId, required this.color});

  @override
  State<LiveTrackingMapScreen> createState() => _LiveTrackingMapScreenState();
}

class _LiveTrackingMapScreenState extends State<LiveTrackingMapScreen> {
  late GoogleMapController mapController;

  // Example coordinates (Port Area)
  final LatLng _driverPos = const LatLng(40.7128, -74.0060);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black, size: 18),
                  onPressed: () => Navigator.pop(context)
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _driverPos, zoom: 14.5),
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              markers: {
                Marker(
                  markerId: const MarkerId("driver"),
                  position: _driverPos,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                ),
              },
            ),

            // Arriving Status Badge
            Positioned(
              top: 110,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 18, color: Colors.blueAccent),
                    const SizedBox(width: 10),
                    Text("Arriving in 12 min", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
                  ],
                ),
              ),
            ),

            // Bottom Driver Details Card
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 25, offset: const Offset(0, -5))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage("https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200")
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Marco Rossi", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 18)),
                              Text("Truck ID: TK-204 • 4.9 ★", style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(color: Color(0xFFF6F5F0), shape: BoxShape.circle),
                          child: const Icon(Icons.chat_bubble_rounded, color: Colors.black, size: 20),
                        )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoItem("Distance", "2.4 km"),
                        _infoItem("Storage", "Cold (2°C)"),
                        _infoItem("ETA", "14:45 PM"),
                      ],
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                        child: Text("Contact Driver", style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 5),
        Text(value, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 15, color: AppTheme.navyDark)),
      ],
    );
  }
}