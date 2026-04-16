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
  final TextEditingController _searchController = TextEditingController();

  // Nairobi Coordinates (Long, Lat)
  final Position _nairobiCenter = Position(36.8219, -1.2921);

  final List<Position> _routePath = [
    Position(36.8219, -1.2921),
    Position(36.8230, -1.2910),
    Position(36.8250, -1.2890),
    Position(36.8280, -1.2870),
  ];

  _onMapCreated(MapboxMap controller) async {
    mapboxMap = controller;
    polylineAnnotationManager = await controller.annotations.createPolylineAnnotationManager();
    pointAnnotationManager = await controller.annotations.createPointAnnotationManager();

    _drawRoute();
    _addMarker();
  }

  // --- NEW SEARCH LOGIC ---
  void _handleSearch(String value) {
    if (value.toLowerCase() == "nairobi") {
      mapboxMap?.flyTo(
        CameraOptions(center: Point(coordinates: _nairobiCenter), zoom: 14.0),
        MapAnimationOptions(duration: 2000),
      );
    }
    // Note: To search real addresses, you will eventually integrate Mapbox Geocoding API
  }

  void _drawRoute() {
    polylineAnnotationManager?.create(
      PolylineAnnotationOptions(
        geometry: LineString(coordinates: _routePath),
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
        body: Stack(
          children: [
            Positioned.fill(
              child: MapWidget(
                key: const ValueKey("mapWidget"),
                onMapCreated: _onMapCreated,
                styleUri: MapboxStyles.MAPBOX_STREETS,
                cameraOptions: CameraOptions(
                  center: Point(coordinates: _nairobiCenter),
                  zoom: 12.0,
                ),
              ),
            ),

            // Floating Search Bar
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: _buildSearchBar(),
            ),

            Positioned(
              top: 130,
              left: 20,
              child: _buildStatusBadge(),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: _buildDriverCard(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15)],
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: _handleSearch, // Trigger search on enter
        decoration: InputDecoration(
          hintText: "Search Nairobi...",
          prefixIcon: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _handleSearch(_searchController.text),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  // Helper UI methods
  Widget _buildStatusBadge() {
    return Container(
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
          Text("Arriving in 12 min", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildDriverCard() {
    return Container(
      margin: const EdgeInsets.all(50),
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