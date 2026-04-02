import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFE),
        body: Stack(
          children: [
            // 1. Main List View
            _buildBookingsList(),

            // 2. Sticky Glass Header with Search and Tabs
            _buildStickyHeader(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyHeader(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: topPadding + 10,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Manage Bookings",
                      style: GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF0D1231))),
                  _headerIcon(Icons.calendar_month_rounded),
                ],
              ),
              const SizedBox(height: 15),

              // --- SEARCH BAR ---
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4F9).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: "Search by ID, Truck or Product...",
                    hintStyle: GoogleFonts.urbanist(color: Colors.blueGrey[300], fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.blueGrey[400], size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF1A237E),
                unselectedLabelColor: Colors.blueGrey[300],
                indicatorColor: const Color(0xFF1A237E),
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.transparent,
                labelStyle: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 13),
                tabs: const [
                  Tab(text: "Upcoming"),
                  Tab(text: "Active"),
                  Tab(text: "History"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsList() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildListByStatus("upcoming"),
        _buildListByStatus("active"),
        _buildListByStatus("history"),
      ],
    );
  }

  Widget _buildListByStatus(String status) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: MediaQuery.of(context).padding.top + 195, // Increased padding for search bar
        bottom: 40,
      ),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        return _bookingCard(status);
      },
    );
  }

  Widget _bookingCard(String status) {
    final bool isUpcoming = status == "upcoming";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _productAvatar('https://images.unsplash.com/photo-1534113414509-0eec2bfb493f?w=400'),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Premium Red Snapper",
                        style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 16)),
                    Text("ID: #BL-98231",
                        style: GoogleFonts.urbanist(fontSize: 12, color: Colors.blueGrey[300], fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              _statusBadge(isUpcoming ? "PENDING" : "STORED", isUpcoming),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: const Color(0xFFF1F4F9), thickness: 1),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoDetail(Icons.scale_rounded, "450 Kg"),
              _infoDetail(Icons.ac_unit_rounded, "-18.0°C"),
              _infoDetail(Icons.timer_outlined, isUpcoming ? "In 2 hrs" : "4 Days left"),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: isUpcoming ? () => _showAssignBaySheet(context) : null,
                  child: _actionBtn(
                      isUpcoming ? "Assign Bay" : "Details",
                      const Color(0xFF1A237E),
                      Colors.white
                  ),
                ),
              ),
              if (!isUpcoming) const SizedBox(width: 10),
              if (!isUpcoming)
                _iconActionBtn(Icons.print_rounded),
            ],
          ),
        ],
      ),
    );
  }

  // --- ASSIGN BAY BOTTOM SHEET ---
  void _showAssignBaySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A237E).withValues(alpha: 0.1),
                    blurRadius: 40,
                    offset: const Offset(0, -10),
                  )
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        _productAvatar('https://images.unsplash.com/photo-1534113414509-0eec2bfb493f?w=400'),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Assign Loading Bay",
                                  style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 18)),
                              Text("Red Snapper • 450 Kg • -18°C",
                                  style: GoogleFonts.urbanist(fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Available Bays (Lamu North)",
                              style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.blueGrey[300])),
                          const SizedBox(height: 15),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              final bayNum = index + 1;
                              bool isOccupied = index == 2 || index == 5;
                              bool isSelected = index == 0;

                              return _baySelector(bayNum.toString(), isOccupied, isSelected);
                            },
                          ),
                          const SizedBox(height: 30),
                          _buildSafetyNotice(),
                        ],
                      ),
                    ),
                  ),

                  _buildActionFooter(context),
                ],
              ),
            );
          }
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _baySelector(String num, bool isOccupied, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1A237E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF1A237E) : Colors.black.withValues(alpha: 0.05),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("BAY", style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.w900, color: isSelected ? Colors.white70 : Colors.blueGrey[300])),
          Text(num, style: GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.w900, color: isSelected ? Colors.white : (isOccupied ? Colors.grey[400] : const Color(0xFF1A237E)))),
          const SizedBox(height: 4),
          Icon(
            isOccupied ? Icons.lock_outline : Icons.check_circle_outline,
            size: 14,
            color: isSelected ? Colors.white70 : (isOccupied ? Colors.grey[400] : Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyNotice() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Ensure Bay 01 is pre-cooled to -18°C before truck arrival.",
              style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.orange[900]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ETA: 14:30 PM", style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.blueGrey[400])),
                Text("Truck KBZ 442Y", style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF0D1231))),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: _primaryButton("Confirm Assignment", () => Navigator.pop(context)),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF1A237E),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: const Color(0xFF1A237E).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))
          ],
        ),
        child: Text(text, style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
      ),
    );
  }

  Widget _productAvatar(String url) {
    return Container(
      width: 50, height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  Widget _statusBadge(String label, bool isAlert) {
    final color = isAlert ? Colors.orange : const Color(0xFF1A237E);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label,
          style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.w900, color: color)),
    );
  }

  Widget _infoDetail(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.blueGrey[300]),
        const SizedBox(width: 6),
        Text(value, style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF0D1231))),
      ],
    );
  }

  Widget _actionBtn(String text, Color bg, Color textCol) {
    return Container(
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(15)),
      child: Text(text, style: GoogleFonts.urbanist(color: textCol, fontWeight: FontWeight.w800, fontSize: 13)),
    );
  }

  Widget _iconActionBtn(IconData icon) {
    return Container(
      height: 45, width: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: const Color(0xFF1A237E), size: 18),
    );
  }

  Widget _headerIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF1F4F9))
      ),
      child: Icon(icon, color: const Color(0xFF1A237E), size: 20),
    );
  }
}