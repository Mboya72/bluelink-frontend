import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

// --- MAIN SHOP SCREEN ---
class MyShopScreen extends StatefulWidget {
  const MyShopScreen({super.key});

  @override
  State<MyShopScreen> createState() => _MyShopScreenState();
}

// REMOVED SingleTickerProviderStateMixin here to fix the 'NoSuchMethodError'
class _MyShopScreenState extends State<MyShopScreen> {
  final ScrollController _shopScrollController = ScrollController();

  void _openMarketplace() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const EquipmentMarketplaceScreen(),
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
        appBar: _buildShopAppBar(),
        body: SingleChildScrollView(
          controller: _shopScrollController,
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShopHeader(),
              const SizedBox(height: 25),
              _buildShopStats(),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _openMarketplace,
                child: _buildMarketplaceLinkCard(),
              ),
              const SizedBox(height: 35),
              _buildSectionHeader("My Inventory", "Manage"),
              const SizedBox(height: 15),
              _buildInventoryGrid(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildShopAppBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text("My Shop",
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.navyDark)),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined, color: AppTheme.navyDark)),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildShopHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20)],
      ),
      child: Row(children: [
        Container(
          width: 65, height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1551963831-b3b1ca40c98e?w=200'), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Nemo's Deep Sea", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.navyDark)),
          Text("Port Terminal A, Dock 4", style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 13)),
        ])),
        IconButton(onPressed: () {}, icon: const Icon(Icons.edit_note, color: AppTheme.vibrantBlue)),
      ]),
    );
  }

  Widget _buildShopStats() {
    return Row(children: [
      _statBox("4.9", "Rating", const Color(0xFFFFF8E1), Icons.star_rounded, Colors.orange),
      const SizedBox(width: 12),
      _statBox("124", "Orders", const Color(0xFFEFFFFD), Icons.shopping_bag_rounded, Colors.teal),
      const SizedBox(width: 12),
      _statBox("98%", "Reliability", const Color(0xFFF4F2FF), Icons.verified_user_rounded, Colors.purpleAccent),
    ]);
  }

  Widget _statBox(String val, String lab, Color bg, IconData ic, Color col) {
    return Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24)), child: Column(children: [
      Icon(ic, color: col, size: 20),
      const SizedBox(height: 8),
      Text(val, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.navyDark)),
      Text(lab, style: GoogleFonts.urbanist(fontSize: 11, color: Colors.grey[700])),
    ])));
  }

  Widget _buildMarketplaceLinkCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.vibrantBlue, AppTheme.navyDark]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppTheme.vibrantBlue.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(children: [
        const CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.shopping_cart_outlined, color: Colors.white)),
        const SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Equipment Market", style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
          Text("Upgrade your gear (Full Screen)", style: GoogleFonts.urbanist(color: Colors.white70, fontSize: 12)),
        ])),
        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
      ]),
    );
  }

  Widget _buildInventoryGrid() {
    return GridView.count(
      padding: EdgeInsets.zero, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15, childAspectRatio: 0.9,
      children: [
        _invCard("Blue Lobster", "\$45/kg", "https://images.unsplash.com/photo-1559737558-2f5a35f4523b?w=300"),
        _invCard("Tiger Prawns", "\$22/kg", "https://images.unsplash.com/photo-1551972251-12070d63502a?w=300"),
      ],
    );
  }

  Widget _invCard(String n, String p, String img) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.network(img, width: double.infinity, fit: BoxFit.cover))),
        const SizedBox(height: 10),
        Text(n, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
        Text(p, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, color: AppTheme.vibrantBlue, fontSize: 14)),
      ]),
    );
  }

  Widget _buildSectionHeader(String t, String a) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(t, style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.navyDark)),
      Text(a, style: GoogleFonts.urbanist(color: AppTheme.vibrantBlue, fontSize: 13, fontWeight: FontWeight.w700)),
    ]);
  }
}

// ---------------------------------------------------------------------------
// VIEW 2: EQUIPMENT MARKETPLACE (TRANSPARENT TOP BAR, DARK ICONS)
// ---------------------------------------------------------------------------

class EquipmentMarketplaceScreen extends StatelessWidget {
  const EquipmentMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        extendBodyBehindAppBar: true,
        appBar: _buildMarketplaceAppBar(context),
        body: Column(
          children: [
            const SizedBox(height: 100),
            _buildMarketplaceSearchHeader(),
            Expanded(child: _buildEquipmentGrid(context)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildMarketplaceAppBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 16),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text("Search tools",
          style: GoogleFonts.urbanist(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 17)),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded, color: Colors.black)),
      ],
    );
  }

  Widget _buildMarketplaceSearchHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(children: [
        Row(children: [
          Expanded(child: Container(height: 55, padding: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15)]), child: Row(children: [const Icon(Icons.search, color: Colors.grey, size: 20), const SizedBox(width: 12), Text("Search", style: GoogleFonts.urbanist(color: Colors.grey))]))),
          const SizedBox(width: 12),
          Container(height: 55, width: 55, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade100)), child: const Icon(Icons.tune_rounded, color: Colors.black)),
        ]),
        const SizedBox(height: 25),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Popular", style: GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.w900)), Text("See All", style: GoogleFonts.urbanist(color: Colors.grey, fontWeight: FontWeight.w600))]),
      ]),
    );
  }

  Widget _buildEquipmentGrid(BuildContext context) {
    final equipment = [
      {"name": "Power Drill", "price": "\$5", "rating": "4.9", "img": "https://images.unsplash.com/photo-1504148455328-c376907d081c?w=500"},
      {"name": "Generator", "price": "\$29", "rating": "4.8", "img": "https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500"},
    ];
    return GridView.builder(
      padding: const EdgeInsets.all(20), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20, childAspectRatio: 0.78),
      itemCount: equipment.length,
      itemBuilder: (context, index) {
        final item = equipment[index];
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EquipmentDetailScreen(item: item))),
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFFF6F5F0), borderRadius: BorderRadius.circular(28)),
            child: Stack(children: [
              Positioned(top: 12, right: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Row(children: [const Icon(Icons.star, size: 10), const SizedBox(width: 4), Text(item['rating']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))]))),
              Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 20),
                Expanded(child: Center(child: Icon(Icons.build_circle_outlined, size: 60, color: Colors.grey.shade400))),
                Text(item['name']!, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
                Text("${item['price']}/Per Day", style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 11)),
                const Spacer(),
                Align(alignment: Alignment.bottomRight, child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle), child: const Icon(Icons.arrow_outward, color: Colors.white, size: 18))),
              ])),
            ]),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// VIEW 3: EQUIPMENT DETAIL (TRANSPARENT TOP BAR, DARK ICONS)
// ---------------------------------------------------------------------------

class EquipmentDetailScreen extends StatelessWidget {
  final Map<String, String> item;
  const EquipmentDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 18), onPressed: () => Navigator.pop(context)),
          actions: [IconButton(icon: const Icon(Icons.favorite_border_rounded, color: Colors.black), onPressed: () {})],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Container(
              height: 300, width: double.infinity,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFFF6F5F0), borderRadius: BorderRadius.circular(30)),
              child: const Center(child: Icon(Icons.handyman_rounded, size: 120, color: Colors.grey)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(item['name']!, style: GoogleFonts.urbanist(fontSize: 28, fontWeight: FontWeight.w900)),
                  Text(item['price']!, style: GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.vibrantBlue)),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  const Icon(Icons.star, color: Colors.orange, size: 18),
                  const SizedBox(width: 5),
                  Text("${item['rating']} (120 Reviews)", style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, color: Colors.grey)),
                ]),
                const SizedBox(height: 25),
                Text("About", style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(
                  "This professional-grade ${item['name']} is designed for marine tasks. Features ergonomic grip and extreme durability.",
                  style: GoogleFonts.urbanist(color: Colors.grey[600], height: 1.6),
                ),
              ]),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5))]),
              child: Row(children: [
                Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFFF6F5F0), borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.chat_bubble_outline_rounded)),
                const SizedBox(width: 15),
                Expanded(child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  child: Text("Book Now", style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                )),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}