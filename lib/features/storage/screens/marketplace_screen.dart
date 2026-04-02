import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class StorageShopScreen extends StatefulWidget {
  const StorageShopScreen({super.key});

  @override
  State<StorageShopScreen> createState() => _StorageShopScreenState();
}

class _StorageShopScreenState extends State<StorageShopScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
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
            // 1. Main Shop Content
            _buildScrollingContent(),

            // 2. Sticky Glass Header
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
            bottom: 15,
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hardware Hub",
                      style: GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF0D1231))),
                  _cartButton(2),
                ],
              ),
              const SizedBox(height: 15),
              _buildSearchBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: "Search machine parts, tools, or crates...",
          hintStyle: GoogleFonts.urbanist(color: Colors.blueGrey[300], fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.blueGrey[400], size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildScrollingContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: MediaQuery.of(context).padding.top + 145,
        bottom: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMaintenanceBanner(),
          const SizedBox(height: 25),
          _buildSectionHeader("Machine Categories"),
          const SizedBox(height: 15),
          _buildCategoryGrid(),
          const SizedBox(height: 25),
          _buildSectionHeader("Facility Essentials"),
          const SizedBox(height: 15),
          _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildMaintenanceBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E),
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=800'),
          fit: BoxFit.cover,
          opacity: 0.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
            child: Text("SERVICE ALERT", style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10)),
          ),
          const SizedBox(height: 12),
          Text("Prevent Downtime", style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
          const SizedBox(height: 6),
          Text("Stock up on compressor filters and coolant seals before the peak season.",
              style: GoogleFonts.urbanist(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, height: 1.5, fontWeight: FontWeight.w500)),
          const SizedBox(height: 18),
          _smallWhiteBtn("Order Parts"),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _categoryItem("Cooling", Icons.ac_unit_rounded, Colors.blue),
          _categoryItem("Sensors", Icons.settings_input_component_rounded, Colors.orange),
          _categoryItem("Storage", Icons.inventory_2_rounded, Colors.cyan),
          _categoryItem("Cleaning", Icons.sanitizer_rounded, Colors.green),
        ],
      ),
    );
  }

  Widget _categoryItem(String name, IconData icon, Color color) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF1F4F9)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(name, style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF0D1231))),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 0.78,
      children: [
        _productCard("IoT Temp Node", "KSh 4,500", "https://images.unsplash.com/photo-1558346490-a72e53ae2d4f?w=400"),
        _productCard("Insulated Crate", "KSh 2,200", "https://images.unsplash.com/photo-1586864387967-d02ef85d93e8?w=400"),
        _productCard("Ventilation Fan", "KSh 15,800", "https://images.unsplash.com/photo-1591132807083-30c18000b9d0?w=400"),
        _productCard("Pallet Jack", "KSh 24,000", "https://images.unsplash.com/photo-1587293855946-b21d3a436100?w=400"),
      ],
    );
  }

  Widget _productCard(String name, String price, String url) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFF1F4F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 13, color: const Color(0xFF0D1231))),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 14, color: const Color(0xFF1A237E))),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: const Color(0xFF1A237E), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w900, color: const Color(0xFF0D1231)));
  }

  Widget _smallWhiteBtn(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: GoogleFonts.urbanist(color: const Color(0xFF1A237E), fontSize: 12, fontWeight: FontWeight.w900)),
    );
  }

  Widget _cartButton(int count) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F4F9))
          ),
          child: const Icon(Icons.build_circle_outlined, color: Color(0xFF1A237E), size: 20),
        ),
        if (count > 0)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }
}