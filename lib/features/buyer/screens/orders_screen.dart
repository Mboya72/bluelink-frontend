import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyerOrdersScreen extends StatefulWidget {
  const BuyerOrdersScreen({super.key});

  @override
  State<BuyerOrdersScreen> createState() => _BuyerOrdersScreenState();
}

class _BuyerOrdersScreenState extends State<BuyerOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFF),
        body: Column(
          children: [
            _buildProfessionalHeader(context),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrdersList(),
                  _buildLogisticsAssignment(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalHeader(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          color: Colors.white.withOpacity(0.85),
          padding: EdgeInsets.fromLTRB(20, topPadding + 15, 20, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Orders",
                    style: GoogleFonts.urbanist(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D1231),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Row(
                    children: [
                      _headerActionIcon(Icons.search_rounded),
                      const SizedBox(width: 12),
                      _headerActionIcon(Icons.tune_rounded),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // --- FIXED TAB BAR ---
              Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  controller: _tabController,
                  // The 'indicator' is the white sliding pill
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  // Ensures no underline is visible
                  dividerColor: Colors.transparent,
                  // Active text color
                  labelColor: const Color(0xFF1A237E),
                  // Inactive text color
                  unselectedLabelColor: Colors.blueGrey[400],
                  labelStyle: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  tabs: const [
                    Tab(text: "Active Track"),
                    Tab(text: "Assign Logistics"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: 3,
      itemBuilder: (context, index) {
        return _proOrderCard(
          title: index == 0 ? "Premium Yellowfin Tuna" : "Fresh King Prawns",
          weight: index == 0 ? "42.5 kg" : "18.0 kg",
          id: "ORD-BK-882${index + 1}",
          status: index == 0 ? "In Transit" : "Awaiting Pickup",
          statusColor: index == 0 ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
          icon: index == 0 ? Icons.local_shipping_outlined : Icons.inventory_2_outlined,
        );
      },
    );
  }

  Widget _buildLogisticsAssignment() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        _buildSectionLabel("PENDING ASSIGNMENT"),
        _unassignedParcelCard("Blue Marlin - 30kg", "Kibarani Hub, Mombasa"),
        const SizedBox(height: 24),
        _buildSectionLabel("LOGISTICS PARTNERS"),
        _proServiceCard("Express Cold-Link", "Truck #KBZ 442Y • 4.8★", Icons.local_shipping_rounded, "Ksh 120/km"),
        _proServiceCard("Sea-Freeze Canning", "Industrial Zone • Certified", Icons.factory_rounded, "Ksh 1,500/unit"),
        _proServiceCard("BlueLine Logistics", "Driver: Samuel K. • 5.0★", Icons.delivery_dining_rounded, "Ksh 80/km"),
      ],
    );
  }

  // --- Professional UI Primitives ---

  Widget _proOrderCard({
    required String title,
    required String weight,
    required String id,
    required String status,
    required Color statusColor,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E5F2)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 48, width: 48,
                  decoration: BoxDecoration(color: const Color(0xFFF5F7FF), borderRadius: BorderRadius.circular(14)),
                  child: Icon(icon, color: const Color(0xFF1A237E), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 15, color: const Color(0xFF0D1231))),
                      const SizedBox(height: 2),
                      Text("$id • $weight", style: GoogleFonts.urbanist(color: Colors.blueGrey[400], fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
                      child: Text(status, style: GoogleFonts.urbanist(color: statusColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFF),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: Colors.blueGrey),
                    const SizedBox(width: 5),
                    Text("Est. Delivery: Today, 4 PM", style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.blueGrey[600])),
                  ],
                ),
                Text("Manage", style: GoogleFonts.urbanist(color: const Color(0xFF1A237E), fontWeight: FontWeight.w800, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _proServiceCard(String name, String sub, IconData icon, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E5F2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1A237E), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 15)),
                Text(sub, style: GoogleFonts.urbanist(fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, color: const Color(0xFF2E7D32), fontSize: 13)),
              const SizedBox(height: 8),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text("Assign", style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w800)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _unassignedParcelCard(String name, String location) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14, color: const Color(0xFFC62828))),
                Text(location, style: GoogleFonts.urbanist(fontSize: 12, color: Colors.red[300], fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 10, top: 10),
    child: Text(
        text,
        style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w900,
            fontSize: 11,
            color: Colors.blueGrey[300],
            letterSpacing: 1.2
        )
    ),
  );

  Widget _headerActionIcon(IconData icon) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFF1F3F9),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, size: 20, color: const Color(0xFF1A237E)),
  );
}