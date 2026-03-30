import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

class FishermanDashboard extends StatelessWidget {
  const FishermanDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 110, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(),
            const SizedBox(height: 20),
            _buildSectionHeader("Quick Actions", showViewAll: false),
            const SizedBox(height: 8),
            _buildQuickActionsGrid(),
            const SizedBox(height: 20),
            _buildSectionHeader("Active Sales"),
            const SizedBox(height: 8),
            _buildHorizontalActiveSales(), // Horizontal style from image
            const SizedBox(height: 20),
            _buildSectionHeader("Recent Transactions"),
            const SizedBox(height: 8),
            _buildTransactionList(), // Vertical list from image
            const SizedBox(height: 20),
            _buildSectionHeader("In Transit"),
            const SizedBox(height: 8),
            _buildInTransitCard(),
          ],
        ),
      ),
    );
  }

  // --- APP BAR (FROSTED GLASS) ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      backgroundColor: Colors.white.withValues(alpha: 0.1),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              image: const DecorationImage(
                image: NetworkImage('https://plus.unsplash.com/premium_photo-1705418263346-d46342de49ca?q=80&w=687&auto=format&fit=crop'),
                fit: BoxFit.cover,
                alignment: Alignment(0, -0.4),
              ),
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Hello,", style: GoogleFonts.urbanist(fontSize: 12, color: Colors.grey[600])),
          Text("Captain Nemo!", style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded, color: AppTheme.navyDark)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.navyDark)),
        const SizedBox(width: 10),
      ],
    );
  }

  // --- BALANCE CARD (MODERN GRADIENT) ---
  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.vibrantBlue, AppTheme.vibrantBlue.withValues(alpha: 0.7)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: AppTheme.vibrantBlue.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Current Balance", style: GoogleFonts.urbanist(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 4),
              Text("\$4,570.80", style: GoogleFonts.urbanist(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  // --- QUICK ACTIONS GRID ---
  Widget _buildQuickActionsGrid() {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _actionCard("Post Catch", Icons.add_circle_outline, AppTheme.vibrantBlue),
        _actionCard("Earnings", Icons.payments_outlined, Colors.purple),
        _actionCard("Inventory", Icons.inventory_2_outlined, Colors.teal),
        _actionCard("Sea Logs", Icons.waves, Colors.orange),
      ],
    );
  }

  Widget _actionCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }

  // --- HORIZONTAL ACTIVE SALES (LIKE "UPCOMING PAYMENTS") ---
  Widget _buildHorizontalActiveSales() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _activeSaleCard("Yellowfin Tuna", "\$120", "2 days left", AppTheme.vibrantBlue, true),
          _activeSaleCard("Red Snapper", "\$85", "5 hours left", Colors.white, false),
          _activeSaleCard("King Prawns", "\$210", "1 day left", Colors.white, false),
        ],
      ),
    );
  }

  Widget _activeSaleCard(String title, String price, String time, Color bg, bool isPrimary) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: isPrimary ? null : Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.waves, color: isPrimary ? Colors.white70 : AppTheme.vibrantBlue),
          const Spacer(),
          Text(title, style: GoogleFonts.urbanist(color: isPrimary ? Colors.white : AppTheme.navyDark, fontWeight: FontWeight.w800, fontSize: 15)),
          Text(price, style: GoogleFonts.urbanist(color: isPrimary ? Colors.white : AppTheme.navyDark, fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 4),
          Text(time, style: GoogleFonts.urbanist(color: isPrimary ? Colors.white60 : Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  // --- RECENT TRANSACTIONS (VERTICAL LIST) ---
  Widget _buildTransactionList() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          _transactionItem("Local Market Sale", "21 Sep, 03:02 PM", "+\$230.50", true),
          const Divider(height: 1, indent: 70, endIndent: 20, color: Color(0xFFF1F1F1)),
          _transactionItem("Fuel Station", "21 Sep, 01:15 PM", "-\$85.00", false),
          const Divider(height: 1, indent: 70, endIndent: 20, color: Color(0xFFF1F1F1)),
          _transactionItem("Equipment Repair", "20 Sep, 11:45 AM", "-\$40.20", false),
        ],
      ),
    );
  }

  Widget _transactionItem(String title, String date, String amount, bool isProfit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.softBlueBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(isProfit ? Icons.arrow_downward : Icons.arrow_upward, color: AppTheme.navyDark, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
              Text(date, style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 11)),
            ]),
          ),
          Text(amount, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 14, color: isProfit ? Colors.green : Colors.red[400])),
        ],
      ),
    );
  }

  // --- IN TRANSIT CARD ---
  Widget _buildInTransitCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.local_shipping_rounded, color: Colors.orange, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Order #8821", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
                  Text("Red Snapper (5kg)", style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 12)),
                ]),
              ),
              Text("In 15 mins", style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, color: AppTheme.vibrantBlue, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: 0.7, backgroundColor: Colors.grey[200], valueColor: AlwaysStoppedAnimation<Color>(AppTheme.vibrantBlue), minHeight: 6),
          ),
        ],
      ),
    );
  }

  // --- HELPERS ---
  Widget _buildSectionHeader(String title, {bool showViewAll = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.navyDark)),
        if (showViewAll)
          SizedBox(
            height: 30,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Text("See all", style: GoogleFonts.urbanist(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
      ],
    );
  }
}