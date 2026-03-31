import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

class ActiveTripScreen extends StatefulWidget {
  const ActiveTripScreen({super.key});

  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> {
  // Tracking which stops are finished
  List<bool> stopCompleted = [false, false, false];

  // Mock data for manifests (Items per station)
  final List<List<Map<String, String>>> _manifestData = [
    [
      {'name': 'Fresh Snapper Crate', 'id': 'SN-001'},
      {'name': 'Kingfish Bulk', 'id': 'KF-042'},
    ],
    [
      {'name': 'Yamaha Engine Oil', 'id': 'OIL-99'},
      {'name': 'Propeller Blade', 'id': 'PRP-02'},
      {'name': 'Hydraulic Fluid', 'id': 'HYD-07'},
    ],
    [
      {'name': 'Standard Ice Box', 'id': 'ICE-10'},
      {'name': 'Plastic Crates (Empty)', 'id': 'CRT-88'},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBFF),
        body: Stack(
          children: [
            // 1. Map View (Placeholder)
            _buildMapPlaceholder(),

            // 2. Fixed Route Navigation Info
            _buildNavigationHeader(),

            // 3. Proactive Arrival Notification (Triggered 30 mins before)
            if (!stopCompleted[1]) _buildArrivalNotification(),

            // 4. Draggable Manifest / Stop List
            _buildDraggableManifest(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationHeader() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 15, right: 15,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppTheme.navyDark,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15)],
        ),
        child: Row(
          children: [
            const Icon(Icons.directions_boat_filled, color: Colors.cyanAccent, size: 28),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CURRENT ROUTE", style: GoogleFonts.urbanist(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  Text("Port Terminal ➔ North Jetty", style: GoogleFonts.urbanist(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            _infoBadge("3 STOPS", Colors.white10),
          ],
        ),
      ),
    );
  }

  Widget _buildArrivalNotification() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 95,
      left: 20, right: 20,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppTheme.vibrantBlue.withValues(alpha: 0.2), width: 2),
          boxShadow: [BoxShadow(color: AppTheme.vibrantBlue.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 5)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppTheme.vibrantBlue.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.notifications_active_rounded, color: AppTheme.vibrantBlue, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Approaching Station B", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 15, color: AppTheme.navyDark)),
                  Text("ETA: 28 mins • Prepare 3 items", style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.green, size: 20),
              style: IconButton.styleFrom(backgroundColor: Colors.green.withValues(alpha: 0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableManifest() {
    return DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.25,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              children: [
                Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 25),
                Text("Route Manifest", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 20, color: AppTheme.navyDark)),
                Text("Tap a stop to verify packages", style: GoogleFonts.urbanist(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 25),

                _buildStopItem(0, "Station A: Old Port", "Fresh Snapper (2 items)", "Contact: Omar .F", Colors.blue),
                _buildStopDivider(),
                _buildStopItem(1, "Station B: Marine Depot", "Engine Lubricants (3 items)", "Contact: Sarah .K", Colors.orange),
                _buildStopDivider(),
                _buildStopItem(2, "Final: North Jetty", "Ice & Crates (2 items)", "Contact: Ali .M", Colors.teal),

                const SizedBox(height: 30),
                _buildActionButton(),
              ],
            ),
          );
        }
    );
  }

  Widget _buildStopItem(int index, String station, String goods, String contact, Color accent) {
    bool isDone = stopCompleted[index];
    return GestureDetector(
      onTap: () => _showPackageDetails(station, _manifestData[index], index),
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: isDone ? 0.5 : 1.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(isDone ? Icons.check_circle : Icons.radio_button_checked, color: isDone ? Colors.green : accent, size: 24),
                if (index != 2) Container(width: 2, height: 50, color: Colors.grey[100]),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(station, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.navyDark)),
                  const SizedBox(height: 4),
                  Text(goods, style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 13, color: accent)),
                  Text(contact, style: GoogleFonts.urbanist(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            if (!isDone)
              const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  void _showPackageDetails(String station, List<Map<String, String>> items, int stopIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 25),
            Text("Manifest for $station", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 22, color: AppTheme.navyDark)),
            const SizedBox(height: 10),
            Text("Verify all items before unloading at this stop.", style: GoogleFonts.urbanist(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 25),

            ...items.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FBFF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.vibrantBlue.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_outlined, color: AppTheme.vibrantBlue, size: 20),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name']!, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
                        Text("SKU: ${item['id']}", style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_box_outline_blank_rounded, color: Colors.grey, size: 20),
                ],
              ),
            )),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => stopCompleted[stopIndex] = true);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navyDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: Text("CONFIRM STOP COMPLETION", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    bool allDone = !stopCompleted.contains(false);
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: allDone ? () => Navigator.pop(context) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: allDone ? const Color(0xFF00C853) : Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: Text(allDone ? "FINISH TRIP & GET PAID" : "COMPLETE ALL STOPS FIRST",
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.white)),
      ),
    );
  }

  Widget _buildMapPlaceholder() => Container(color: Colors.grey[200], child: const Center(child: Icon(Icons.map_outlined, size: 100, color: Colors.white)));
  Widget _infoBadge(String text, Color bg) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)), child: Text(text, style: GoogleFonts.urbanist(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)));
  Widget _buildStopDivider() => const SizedBox(height: 10);
}