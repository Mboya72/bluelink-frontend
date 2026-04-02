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
  bool _showCameraFeed = false;
  bool _isCameraLoading = false;
  double _animationValue = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _animationValue = 1.0);
    });
  }

  void _toggleCamera() {
    setState(() {
      _showCameraFeed = !_showCameraFeed;
      if (_showCameraFeed) _isCameraLoading = true;
    });
    if (_showCameraFeed) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) setState(() => _isCameraLoading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _buildMapMock(),
            _buildCameraOverlay(),
            _buildRefinedHeader(context),
            _buildDraggableTrackingSheet(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapMock() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F4F9),
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?w=1200'),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Stack(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.15, end: 0.50),
            duration: const Duration(seconds: 20),
            builder: (context, value, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height * value,
                left: MediaQuery.of(context).size.width * 0.45,
                child: _buildLiveMarker(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMarker() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            _buildPulseCircle(1.2),
            _buildPulseCircle(1.8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Color(0xFF1A237E),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]),
              child: const Icon(Icons.local_shipping, color: Colors.white, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
          child: Text("KBZ 442Y",
              style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF1A237E))),
        )
      ],
    );
  }

  Widget _buildPulseCircle(double scale) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value * scale * 2,
          child: Opacity(
            opacity: 1 - value,
            child: Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1A237E), width: 1.5),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCameraOverlay() {
    if (!_showCameraFeed) return const SizedBox.shrink();
    return Positioned(
      top: MediaQuery.of(context).padding.top + 90,
      right: 20,
      child: Container(
        width: 150, height: 90,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network('https://images.unsplash.com/photo-1586191582151-f7377390288c?w=400', fit: BoxFit.cover),
              if (_isCameraLoading) const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
              Positioned(
                top: 8, left: 8,
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.red, size: 8),
                    const SizedBox(width: 4),
                    Text("BAY 01", style: GoogleFonts.urbanist(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRefinedHeader(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return Positioned(
      top: topPadding + 10, left: 15, right: 15,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                _actionButton(
                  _showCameraFeed ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                  onTap: _toggleCamera,
                  iconColor: _showCameraFeed ? Colors.redAccent : const Color(0xFF1A237E),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Live Tracking", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 16, color: const Color(0xFF0D1231))),
                      Row(
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Text("Active Shipment", style: GoogleFonts.urbanist(fontSize: 10, color: Colors.blueGrey[400], fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
                _actionButton(Icons.tune_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableTrackingSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.18,
      maxChildSize: 0.9,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
            boxShadow: [BoxShadow(color: const Color(0xFF1A237E).withOpacity(0.12), blurRadius: 30, offset: const Offset(0, -10))],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildRouteSummary(),
                      const SizedBox(height: 25),
                      _buildDriverCard(),
                      const SizedBox(height: 25),

                      // --- NEW: Temperature Analytics Section ---
                      _buildSectionLabel("Cold Chain Monitoring"),
                      const SizedBox(height: 15),
                      _buildTemperatureCard(),

                      const SizedBox(height: 25),
                      _buildSectionLabel("Delivery Progress"),
                      const SizedBox(height: 15),
                      _buildFulfillmentStep("Handover Complete", "Lamu Hub • 09:30 AM", true),
                      _buildFulfillmentStep("In Transit", "Garsen Checkpoint", true, isCurrent: true),
                      _buildFulfillmentStep("Payment Release", "Pending Arrival", false),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(child: _secondaryButton("Manifest")),
                          const SizedBox(width: 12),
                          Expanded(flex: 2, child: _primaryButton("Contact Hub")),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTemperatureCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F4F9)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Internal Temp", style: GoogleFonts.urbanist(fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.w600)),
                  Text("3.4°C", style: GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFF1A237E))),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(12)),
                child: Text("OPTIMAL", style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.green[700])),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Simple Visual Sparkline
          SizedBox(
            height: 40,
            width: double.infinity,
            child: CustomPaint(painter: SparklinePainter()),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FD), borderRadius: BorderRadius.circular(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRouteNode("Origin", "Lamu Hub", Icons.anchor_rounded, true),
          const Icon(Icons.arrow_forward_rounded, color: Colors.blueGrey, size: 16),
          _buildRouteNode("Destination", "Oceanic Rest.", Icons.restaurant_rounded, false),
        ],
      ),
    );
  }

  Widget _buildDriverCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFF1F4F9)), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const CircleAvatar(radius: 24, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400')),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Samuel Kamau", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 15)),
                Text("KBZ 442Y • Cold-Storage Active", style: GoogleFonts.urbanist(fontSize: 12, color: Colors.blueGrey[400])),
              ],
            ),
          ),
          _actionButton(Icons.call_rounded, iconColor: Colors.green[700]),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) => Align(
    alignment: Alignment.centerLeft,
    child: Text(label, style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.blueGrey[300], letterSpacing: 0.5)),
  );

  Widget _buildRouteNode(String label, String value, IconData icon, bool isPrimary) => Column(
    crossAxisAlignment: isPrimary ? CrossAxisAlignment.start : CrossAxisAlignment.end,
    children: [
      Text(label, style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.blueGrey[300])),
      const SizedBox(height: 4),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isPrimary ? const Color(0xFF1A237E) : Colors.blueGrey[300]),
          const SizedBox(width: 5),
          Text(value, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 13, color: const Color(0xFF0D1231))),
        ],
      ),
    ],
  );

  Widget _buildFulfillmentStep(String title, String status, bool isDone, {bool isCurrent = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Row(
      children: [
        Icon(isDone ? Icons.check_circle_rounded : Icons.radio_button_off_rounded, size: 20, color: isDone ? const Color(0xFF1A237E) : Colors.grey[300]),
        const SizedBox(width: 15),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.urbanist(fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w700, fontSize: 14)),
          Text(status, style: GoogleFonts.urbanist(fontSize: 12, color: Colors.blueGrey[400])),
        ]),
      ],
    ),
  );

  Widget _primaryButton(String text) => ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), minimumSize: const Size(0, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 0),
    child: Text(text, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: Colors.white)),
  );

  Widget _secondaryButton(String text) => OutlinedButton(
    onPressed: () {},
    style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF1A237E)), minimumSize: const Size(0, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
    child: Text(text, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: const Color(0xFF1A237E))),
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

// Sparkline Painter for the Temperature Graph
class SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A237E).withOpacity(0.4)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.4, size.width * 0.4, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.8, size.width * 0.8, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}