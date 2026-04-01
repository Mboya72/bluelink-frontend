import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SellerTrackingScreen extends StatefulWidget {
  const SellerTrackingScreen({super.key});

  @override
  State<SellerTrackingScreen> createState() => _SellerTrackingScreenState();
}

class _SellerTrackingScreenState extends State<SellerTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _buildMapMock(),
            _buildTopOverlay(context),
            _buildSellerTrackingSheet(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapMock() {
    return Container(
      color: const Color(0xFFF1F4F9),
      child: Center(
        child: Icon(Icons.map_rounded, size: 200, color: const Color(0xFF1A237E).withOpacity(0.05)),
      ),
    );
  }

  Widget _buildTopOverlay(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return Positioned(
      top: topPadding + 10, left: 20, right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _actionButton(Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.pop(context)),
          Text("Outbound Shipment", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 16, color: const Color(0xFF0D1231))),
          _actionButton(Icons.more_vert_rounded),
        ],
      ),
    );
  }

  Widget _buildSellerTrackingSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 45, height: 5, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 25),

            // --- Logistics Chain Summary ---
            Row(
              children: [
                _buildRouteNode("Origin", "Lamu Landing Site", Icons.anchor_rounded, true),
                Expanded(child: Container(height: 1, color: Colors.grey[200], margin: const EdgeInsets.symmetric(horizontal: 10))),
                _buildRouteNode("Buyer", "Oceanic Restaurant", Icons.restaurant_rounded, false),
              ],
            ),

            const Divider(height: 40, thickness: 1, color: Color(0xFFF8F9FD)),

            // --- Transporter Details ---
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFE8EAF6), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.local_shipping_outlined, color: Color(0xFF1A237E)),
                ),
                const SizedBox(width: 15),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Samuel Kamau", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 15)),
                    Text("KBZ 442Y • Cold-Storage Active", style: GoogleFonts.urbanist(fontSize: 12, color: Colors.blueGrey[400])),
                  ],
                )),
                _actionButton(Icons.call_rounded, iconColor: Colors.green[700]),
              ],
            ),

            const SizedBox(height: 25),

            // --- Fulfillment Timeline ---
            _buildFulfillmentStep("Handover Complete", "Lamu Hub • 09:30 AM", true),
            _buildFulfillmentStep("In Transit to Buyer", "Current Location: Garsen", true, isCurrent: true),
            _buildFulfillmentStep("Payment Release", "Pending Delivery Confirmation", false),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF1A237E)),
                      minimumSize: const Size(0, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text("View Manifest", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: const Color(0xFF1A237E))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      minimumSize: const Size(0, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: Text("Contact Buyer", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteNode(String label, String value, IconData icon, bool isOrigin) => Column(
    children: [
      Icon(icon, size: 22, color: isOrigin ? const Color(0xFF1A237E) : Colors.blueGrey[300]),
      const SizedBox(height: 6),
      Text(label, style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.blueGrey[300], letterSpacing: 0.5)),
      Text(value, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 13, color: const Color(0xFF0D1231))),
    ],
  );

  Widget _buildFulfillmentStep(String title, String status, bool isDone, {bool isCurrent = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Row(
      children: [
        Icon(
            isDone ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
            size: 20,
            color: isDone ? const Color(0xFF1A237E) : Colors.grey[300]
        ),
        const SizedBox(width: 15),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.urbanist(fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w700, fontSize: 14)),
              Text(status, style: GoogleFonts.urbanist(fontSize: 12, color: Colors.blueGrey[400])),
            ]
        ),
      ],
    ),
  );

  Widget _actionButton(IconData icon, {VoidCallback? onTap, Color? iconColor}) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FD), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, size: 20, color: iconColor ?? const Color(0xFF1A237E)),
    ),
  );
}