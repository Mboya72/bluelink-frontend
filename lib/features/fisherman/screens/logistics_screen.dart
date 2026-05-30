import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mbm;
import 'package:mapbox_search/mapbox_search.dart' as mbs hide Color;
import '../../../core/app_theme.dart';

class LiveTrackingMapScreen extends StatefulWidget {
  final String trackingId;
  final Color color;
  const LiveTrackingMapScreen({super.key, required this.trackingId, required this.color});

  @override
  State<LiveTrackingMapScreen> createState() => _LiveTrackingMapScreenState();
}

class _LiveTrackingMapScreenState extends State<LiveTrackingMapScreen> {
  mbm.MapboxMap? mapboxMap;
  mbm.PointAnnotationManager? pointAnnotationManager;
  mbm.PolylineAnnotationManager? polylineAnnotationManager;

  final TextEditingController _searchController = TextEditingController();
  late mbs.GeoCodingApi _geoCoding;
  List<mbs.MapBoxPlace> _predictions = [];

  final mbm.Position _nairobi = mbm.Position(36.8219, -1.2921);

  // Mock Route for the "Trailing" effect
  final List<mbm.Position> _truckRoute = [
    mbm.Position(36.8219, -1.2921),
    mbm.Position(36.8235, -1.2935),
    mbm.Position(36.8250, -1.2950),
  ];

  @override
  void initState() {
    super.initState();
    _geoCoding = mbs.GeoCodingApi(
      apiKey: "pk.eyJ1IjoiZWx2aW5kaW8iLCJhIjoiY21vMWpmcWpjMGZzeDJwcXdwOXp4N3ZrMiJ9.Mc5Blk8BDRdFHWBLkc25Aw",
      limit: 5,
      country: "KE",
    );
  }

  // --- SEARCH LOGIC ---
  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() => _predictions = []);
      return;
    }

    final response = await _geoCoding.getPlaces(query);
    setState(() {
      final success = response.success;
      if (success is List<mbs.MapBoxPlace>) {
        _predictions = success;
      } else {
        _predictions = [];
      }
    });
  }

  void _moveToLocation(mbs.MapBoxPlace place) {
    final center = place.center;
    if (center != null) {
      mapboxMap?.flyTo(
        mbm.CameraOptions(
          center: mbm.Point(coordinates: mbm.Position(center.long, center.lat)),
          zoom: 15.0,
        ),
        mbm.MapAnimationOptions(duration: 2000),
      );

      setState(() {
        _predictions = [];
        _searchController.text = place.text ?? "";
      });
      FocusScope.of(context).unfocus();
    }
  }

  // --- MAP VISUALS ---
  void _onMapCreated(mbm.MapboxMap controller) async {
    mapboxMap = controller;
    pointAnnotationManager = await controller.annotations.createPointAnnotationManager();
    polylineAnnotationManager = await controller.annotations.createPolylineAnnotationManager();
    _setupLiveVisuals();
  }

  void _setupLiveVisuals() async {
    // 1. Draw the "Road Trail"
    polylineAnnotationManager?.create(
      mbm.PolylineAnnotationOptions(
        geometry: mbm.LineString(coordinates: _truckRoute),
        lineColor: Colors.black.toARGB32(), // Fixed deprecation
        lineWidth: 4.0,
        lineOpacity: 0.8,
      ),
    );

    // 2. Add the Realistic Truck Marker
    try {
      final ByteData bytes = await rootBundle.load('assets/images/truck_top_view.png');
      final Uint8List list = bytes.buffer.asUint8List();

      pointAnnotationManager?.create(
        mbm.PointAnnotationOptions(
          geometry: mbm.Point(coordinates: _truckRoute.last),
          image: list,
          iconSize: 0.5,
          iconRotate: 45.0,
        ),
      );
    } catch (e) {
      debugPrint("Error loading truck asset: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: mbm.MapWidget(
                key: const ValueKey("mapWidget"),
                onMapCreated: _onMapCreated,
                cameraOptions: mbm.CameraOptions(
                  center: mbm.Point(coordinates: _nairobi),
                  zoom: 14.0,
                  pitch: 45.0,
                ),
                styleUri: mbm.MapboxStyles.MAPBOX_STREETS,
              ),
            ),
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  _buildSearchBar(),
                  if (_predictions.isNotEmpty) _buildSuggestionsList(),
                ],
              ),
            ),
            Positioned(
              top: 130,
              left: 20,
              child: _buildStatusBadge(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildDriverCard(),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI WIDGETS ---
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15)],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: "Search Nairobi places...",
          prefixIcon: const Icon(Icons.search, color: Colors.black54),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _searchController.clear();
                setState(() => _predictions = []);
              })
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: _predictions.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final place = _predictions[index];
          return ListTile(
            leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
            title: Text(place.text ?? "", style: GoogleFonts.urbanist(fontWeight: FontWeight.w700)),
            subtitle: Text(place.placeName ?? "", maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.urbanist(fontSize: 12)),
            onTap: () => _moveToLocation(place),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 18, color: widget.color),
          const SizedBox(width: 10),
          Text("Arriving in 12 min", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildDriverCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
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