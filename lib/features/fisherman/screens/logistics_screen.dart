import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../core/app_theme.dart';

class LiveTrackingMapScreen extends StatefulWidget {
  final String trackingId;
  final Color color;
  const LiveTrackingMapScreen({super.key, required this.trackingId, required this.color});

  @override
  State<LiveTrackingMapScreen> createState() => _LiveTrackingMapScreenState();
}

class _LiveTrackingMapScreenState extends State<LiveTrackingMapScreen> {
  MapboxMap? mapboxMap;
  PolylineAnnotationManager? polylineAnnotationManager;
  PointAnnotationManager? pointAnnotationManager;

  // Mapbox uses Position(longitude, latitude)
  final List<Position> _routePath = [
    Position(-74.0060, 40.7128), // Start
    Position(-74.0050, 40.7135),
    Position(-74.0040, 40.7145),
    Position(-74.0030, 40.7150), // End
  ];

  _onMapCreated(MapboxMap controller) async {
    mapboxMap = controller;

    // 1. Initialize Managers
    polylineAnnotationManager = await controller.annotations.createPolylineAnnotationManager();
    pointAnnotationManager = await controller.annotations.createPointAnnotationManager();

    // 2. Draw the Route & Marker
    _drawRoute();
    _addMarker();
  }

  void _drawRoute() {
    polylineAnnotationManager?.create(
      PolylineAnnotationOptions(
        geometry: LineString(coordinates: _routePath),
        // FIXED: Using toARGB32() to resolve deprecation
        lineColor: widget.color.toARGB32(),
        lineWidth: 5.0,
        lineOpacity: 0.8,
        lineJoin: LineJoin.ROUND,
      ),
    );
  }

  void _addMarker() {
    pointAnnotationManager?.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: _routePath.first),
        // marker-15 is a standard Mapbox icon. "truck-icon" requires a custom upload.
        iconImage: "marker-15",
        iconSize: 2.0,
      ),
    );
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
            // Ensure MapWidget takes full screen
            Positioned.fill(
              child: MapWidget(
                key: const ValueKey("mapWidget"),
                onMapCreated: _onMapCreated,
                styleUri: MapboxStyles.MAPBOX_STREETS,
                cameraOptions: CameraOptions(
                  center: Point(coordinates: _routePath.first),
                  zoom: 14.0,
                ),
              ),
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
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 18, color: widget.color),
                    const SizedBox(width: 10),
                    Text("Arriving in 12 min",
                        style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
                  ],
                ),
              ),
            ),

            // Bottom Driver Details Card
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildDriverCard(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1), // Modern withValues syntax
              blurRadius: 25,
              offset: const Offset(0, -5)
          )
        ],
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
                    Text("Truck ID: TK-204 • 4.9 ★",
                        style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
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
              child: Text("Contact Driver",
                  style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
            ),
          )
        ],
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