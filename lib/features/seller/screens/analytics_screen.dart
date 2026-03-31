import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SellerAnalyticsScreen extends StatefulWidget {
  const SellerAnalyticsScreen({super.key});

  @override
  State<SellerAnalyticsScreen> createState() => _SellerAnalyticsScreenState();
}

class _SellerAnalyticsScreenState extends State<SellerAnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F8FE),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Refactored Professional Sticky Header
            _buildStickyHeader(),

            // 2. Main Content Area
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildUserGreeting(),
                  const SizedBox(height: 10),
                  _buildMetricsGrid(),
                  const SizedBox(height: 10),
                  _buildMainDiscoveryCard(),
                  const SizedBox(height: 10),
                  _buildAudienceSection(),
                  const SizedBox(height: 10),
                  _buildRegionalDistribution(),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyHeader() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white.withValues(alpha: 0.8),
      surfaceTintColor: Colors.transparent,
      expandedHeight: 0, // Keep it compact and professional
      toolbarHeight: 60,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
      title: Text(
        "Analytics",
        style: GoogleFonts.urbanist(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF1A237E),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF1A237E)),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildUserGreeting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello,",
                style: GoogleFonts.urbanist(
                    fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w600)),
            Row(
              children: [
                Text("Justin Alex",
                    style: GoogleFonts.urbanist(
                        fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF1A237E))),
                const SizedBox(width: 6),
                const Text("👋", style: TextStyle(fontSize: 20)),
              ],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
          ),
          child: const CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=justin'),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.zero, // Removed automatic padding
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.45,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _statTile("Followers", "43.4k", "26.84%", Icons.groups_rounded, const Color(0xFFE8EAF6), const Color(0xFF5C6BC0)),
        _statTile("Engagements", "50.6k", "26.84%", Icons.auto_graph_rounded, const Color(0xFFE0F2F1), const Color(0xFF26A69A)),
        _statTile("Total Views", "59.7k", "26.84%", Icons.insights_rounded, const Color(0xFFE1F5FE), const Color(0xFF29B6F6)),
        _statTile("Total Likes", "76.9k", "26.84%", Icons.favorite_rounded, const Color(0xFFFFF3E0), const Color(0xFFFFA726)),
      ],
    );
  }

  Widget _statTile(String label, String value, String growth, IconData icon, Color bg, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.urbanist(fontSize: 17, fontWeight: FontWeight.w900, color: const Color(0xFF1A237E))),
              Text(label, style: GoogleFonts.urbanist(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainDiscoveryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4C6FFF), Color(0xFF3F51B5)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Profile Discovery", style: GoogleFonts.urbanist(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
              _buildBadge("Monthly"),
            ],
          ),
          const SizedBox(height: 2),
          Text("26.84% (From last month)", style: GoogleFonts.urbanist(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
          const SizedBox(height: 12),
          SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (index) {
                double h = [25, 45, 30, 60, 35, 65, 70, 40, 55, 25, 60, 45][index].toDouble();
                return Container(
                  width: 6, height: h,
                  decoration: BoxDecoration(
                    color: index == 6 ? Colors.yellowAccent : Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAudienceSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Audience Breakdown", style: GoogleFonts.urbanist(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
              const Icon(Icons.tune_rounded, color: Colors.white70, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildRingChart(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _audienceMetric("Man", "2,487", Colors.tealAccent),
                    const SizedBox(height: 6),
                    _audienceMetric("Woman", "1,745", Colors.yellowAccent),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRingChart() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 60, height: 60,
          child: CircularProgressIndicator(
            value: 0.7, strokeWidth: 5, strokeCap: StrokeCap.round,
            color: Colors.tealAccent, backgroundColor: Colors.white10,
          ),
        ),
        SizedBox(
          width: 60, height: 60,
          child: CircularProgressIndicator(
            value: 0.4, strokeWidth: 5, strokeCap: StrokeCap.round,
            color: Colors.yellowAccent, backgroundColor: Colors.transparent,
          ),
        ),
        Text("45%", style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
      ],
    );
  }

  Widget _audienceMetric(String label, String count, Color color) {
    return Row(
      children: [
        Container(width: 5, height: 5, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.urbanist(color: Colors.white60, fontSize: 10)),
            Text(count, style: GoogleFonts.urbanist(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
          ],
        ),
        const Spacer(),
        const Icon(Icons.arrow_outward_rounded, color: Colors.greenAccent, size: 12),
      ],
    );
  }

  Widget _buildRegionalDistribution() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Data Distribution", style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF1A237E))),
          const SizedBox(height: 10),
          _distributionItem("Nairobi", "862", Colors.indigoAccent),
          _distributionItem("Mombasa", "375", Colors.cyan),
          _distributionItem("Kisumu", "657", Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _distributionItem(String city, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          CircleAvatar(radius: 3, backgroundColor: color),
          const SizedBox(width: 10),
          Text(city, style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, color: Colors.grey[700], fontSize: 12)),
          const Spacer(),
          Text(value, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, color: const Color(0xFF1A237E), fontSize: 13)),
          const SizedBox(width: 6),
          const Icon(Icons.auto_graph_rounded, size: 12, color: Colors.blueGrey),
        ],
      ),
    );
  }



  Widget _buildBadge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)),
    child: Text(text, style: GoogleFonts.urbanist(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700)),
  );
}
