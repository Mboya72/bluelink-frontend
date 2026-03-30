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
            const SizedBox(height: 25),

            // --- UPDATED ASYMMETRIC OVERVIEW SECTION ---
            _buildSectionHeader("Overview", showViewAll: false),
            const SizedBox(height: 10),
            _buildAsymmetricOverview(),

            const SizedBox(height: 25),
            _buildSectionHeader("Active Sales"),
            const SizedBox(height: 10),
            _buildHorizontalActiveSales(),

            const SizedBox(height: 25),
            _buildSectionHeader("In Transit"),
            const SizedBox(height: 10),
            _buildInTransitCard(),

            const SizedBox(height: 25),
            _buildSectionHeader("Recent Transactions"),
            const SizedBox(height: 10),
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  // --- NEW: ASYMMETRIC OVERVIEW (CHART + 4 ACTIONS) ---
  Widget _buildAsymmetricOverview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT: Activity Chart Card
        Expanded(
          flex: 1,
          child: Container(
            height: 200, // Matches the height of the 2x2 grid on the right
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9F9), // Light mint from image
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [ _bar(30), _bar(60), _bar(90), _bar(50), _bar(25) ],
                ),
                const SizedBox(height: 20),
                Text("Activity", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.navyDark)),
                Text("Current Week", style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // RIGHT: 2x2 Mini-Grid for your 4 Quick Actions
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 200,
            child: GridView.count(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0, // Ensures perfect squares
              children: [
                _miniActionCard("Post", Icons.add_circle_outline, AppTheme.vibrantBlue, const Color(0xFFF4F2FF)),
                _miniActionCard("Pay", Icons.payments_outlined, Colors.purple, const Color(0xFFFDF2FF)),
                _miniActionCard("Stock", Icons.inventory_2_outlined, Colors.teal, const Color(0xFFEFFFFD)),
                _miniActionCard("Logs", Icons.waves, Colors.orange, const Color(0xFFFFF8E1)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _miniActionCard(String title, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 6),
          Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 12, color: AppTheme.navyDark)),
        ],
      ),
    );
  }

  Widget _bar(double height) => Container(width: 8, height: height / 2, decoration: BoxDecoration(color: const Color(0xFFA2D2D2), borderRadius: BorderRadius.circular(4)));

  // --- REMAINING PREVIOUS CONTENT ---

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.vibrantBlue, AppTheme.vibrantBlue.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
          Container(padding: const EdgeInsets.all(12), decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: const Icon(Icons.add, color: Colors.white, size: 28)),
        ],
      ),
    );
  }

  Widget _buildHorizontalActiveSales() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _activeSaleCard("Yellowfin Tuna", "\$120", "2 days left", AppTheme.vibrantBlue, true),
          _activeSaleCard("Red Snapper", "\$85", "5 hours left", Colors.white, false),
        ],
      ),
    );
  }

  Widget _activeSaleCard(String title, String price, String time, Color bg, bool isPrimary) {
    return Container(
      width: 155, margin: const EdgeInsets.only(right: 15), padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24), border: isPrimary ? null : Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.waves, color: isPrimary ? Colors.white70 : AppTheme.vibrantBlue),
          const Spacer(),
          Text(title, style: GoogleFonts.urbanist(color: isPrimary ? Colors.white : AppTheme.navyDark, fontWeight: FontWeight.w800, fontSize: 15)),
          Text(price, style: GoogleFonts.urbanist(color: isPrimary ? Colors.white : AppTheme.navyDark, fontWeight: FontWeight.w900, fontSize: 18)),
          Text(time, style: GoogleFonts.urbanist(color: isPrimary ? Colors.white60 : Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildInTransitCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Color(0xFFFFF8E1), shape: BoxShape.circle), child: const Icon(Icons.local_shipping_rounded, color: Colors.orange, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Order #8821", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
                Text("Destination: Port Terminal A", style: GoogleFonts.urbanist(color: Colors.grey[600], fontSize: 12)),
              ])),
              Text("15m away", style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, color: AppTheme.vibrantBlue, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: 0.7, backgroundColor: Colors.grey[100], color: AppTheme.vibrantBlue, minHeight: 6)),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Container(
      padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          _transactionItem("Local Market Sale", "21 Sep, 03:02 PM", "+\$230.50", true),
          const Divider(height: 1, indent: 60, endIndent: 20, color: Color(0xFFF5F5F5)),
          _transactionItem("Fuel Station", "21 Sep, 01:15 PM", "-\$85.00", false),
        ],
      ),
    );
  }

  Widget _transactionItem(String title, String date, String amount, bool isProfit) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppTheme.softBlueBg, borderRadius: BorderRadius.circular(12)), child: Icon(isProfit ? Icons.arrow_downward : Icons.arrow_upward, color: AppTheme.navyDark, size: 18)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 14)),
            Text(date, style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 11)),
          ])),
          Text(amount, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 14, color: isProfit ? Colors.green : Colors.red[400])),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.light),
      backgroundColor: Colors.white.withValues(alpha: 0.1),
      elevation: 0, scrolledUnderElevation: 0,
      flexibleSpace: ClipRect(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: Container(color: Colors.transparent))),
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Center(
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), image: const DecorationImage(image: NetworkImage('https://plus.unsplash.com/premium_photo-1705418263346-d46342de49ca?q=80&w=687&auto=format&fit=crop'), fit: BoxFit.cover, alignment: Alignment(0, -0.4))),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _buildSectionHeader(String title, {bool showViewAll = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.navyDark)),
        if (showViewAll) Text("See all", style: GoogleFonts.urbanist(color: Colors.grey[400], fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }
}