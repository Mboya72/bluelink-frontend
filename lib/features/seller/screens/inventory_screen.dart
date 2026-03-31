import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

class InventoryDashboardScreen extends StatefulWidget {
  const InventoryDashboardScreen({super.key});

  @override
  State<InventoryDashboardScreen> createState() => _InventoryDashboardScreenState();
}

class _InventoryDashboardScreenState extends State<InventoryDashboardScreen> {
  int selectedCategory = 0;
  final List<String> categories = ["All Fish", "Shellfish", "Processed", "Equipment"];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBFF),
        body: Stack(
          children: [
            _buildMainScrollArea(),
            _buildBlurHeader(),
            _buildCustomFloatingButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainScrollArea() {
    return ListView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 110,
        left: 20, right: 20,
        bottom: 150,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildStatsRow(),
        const SizedBox(height: 25),
        _buildSectionHeader("Financial Analytics"),
        const SizedBox(height: 15),
        _buildFinancialAnalytics(),
        const SizedBox(height: 25),
        _buildSectionHeader("Quick Actions"),
        const SizedBox(height: 15),
        _buildQuickActions(),
        const SizedBox(height: 25),
        _buildSectionHeader("Stock Inventory"),
        _buildCategoryFilter(),
        const SizedBox(height: 15),
        _buildInventoryList(),
      ],
    );
  }

  Widget _buildFinancialAnalytics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.navyDark,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navyDark.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Revenue (MTD)",
                        style: GoogleFonts.urbanist(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text("KES 482,500",
                        style: GoogleFonts.urbanist(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text("+12.5%", style: GoogleFonts.urbanist(color: Colors.green, fontWeight: FontWeight.w800, fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _miniFinancialStat("Est. Profit", "KES 142K", Icons.auto_graph)),
              const SizedBox(width: 10),
              Expanded(child: _miniFinancialStat("Avg. Margin", "28.4%", Icons.pie_chart_outline)),
            ],
          )
        ],
      ),
    );
  }

  Widget _miniFinancialStat(String label, String val, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.vibrantBlue, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.urbanist(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
              Text(val, style: GoogleFonts.urbanist(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800), overflow: TextOverflow.ellipsis),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBlurHeader() {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 20, left: 20, right: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Good Morning, 👋", style: GoogleFonts.urbanist(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                      Text("Salim Khamis", style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.navyDark), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _roundIconButton(Icons.notifications_none_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomFloatingButton() {
    return Positioned(
      bottom: 110,
      right: 20,
      child: GestureDetector(
        onTap: () => _showAddStockSheet(context),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.navyDark,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.navyDark.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  void _showAddStockSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAddStockPanel(),
    );
  }

  Widget _buildAddStockPanel() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 45, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
          const SizedBox(height: 25),
          Text("New Stock Entry", style: GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
          const SizedBox(height: 25),
          _buildInputLabel("Item Name"),
          _buildField(hint: "e.g. Nile Perch"),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildInputLabel("Weight (kg)"), _buildField(hint: "0.00", icon: Icons.scale_outlined)])),
              const SizedBox(width: 15),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildInputLabel("Price / kg"), _buildField(hint: "KES", icon: Icons.payments_outlined)])),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity, height: 60,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.vibrantBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
              child: Text("CONFIRM STOCK", style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 16)),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8, left: 4), child: Text(text, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.grey[700])));

  Widget _buildField({required String hint, IconData? icon}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(color: const Color(0xFFF8FBFF), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade100)),
    child: TextField(decoration: InputDecoration(hintText: hint, prefixIcon: icon != null ? Icon(icon, size: 20, color: AppTheme.vibrantBlue) : null, border: InputBorder.none, hintStyle: GoogleFonts.urbanist(fontSize: 14, color: Colors.grey))),
  );

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 12),
            Text(value, style: GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.navyDark), overflow: TextOverflow.ellipsis),
            Text(label, style: GoogleFonts.urbanist(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() => Row(children: [
    _statCard("Total Stock", "1,240kg", Icons.inventory_2_outlined, AppTheme.vibrantBlue),
    const SizedBox(width: 15),
    _statCard("Low Alert", "05 Items", Icons.warning_amber_rounded, Colors.orange),
  ]);

  Widget _buildSectionHeader(String title) => Text(title, style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.navyDark));

  Widget _buildQuickActions() => Row(children: [
    Expanded(child: _actionItem(Icons.qr_code_scanner_rounded, "Scan In")),
    Expanded(child: _actionItem(Icons.local_shipping_outlined, "Orders")),
    Expanded(child: _actionItem(Icons.history_rounded, "Ledger")),
    Expanded(child: _actionItem(Icons.analytics_outlined, "Stats")),
  ]);

  Widget _actionItem(IconData icon, String label) => Column(children: [
    Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.grey.shade100)), child: Icon(icon, color: AppTheme.navyDark)),
    const SizedBox(height: 8),
    Text(label, style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey[700]), overflow: TextOverflow.ellipsis),
  ]);

  Widget _buildCategoryFilter() => SizedBox(
    height: 60,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => setState(() => selectedCategory = index),
        child: Container(
          margin: const EdgeInsets.only(right: 12, top: 15, bottom: 5),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: selectedCategory == index ? AppTheme.vibrantBlue : Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Center(child: Text(categories[index], style: GoogleFonts.urbanist(color: selectedCategory == index ? Colors.white : Colors.grey, fontWeight: FontWeight.w800, fontSize: 13))),
        ),
      ),
    ),
  );

  Widget _buildInventoryList() => Column(children: [
    _inventoryTile("Yellowfin Tuna", "120 kg", "KES 600/kg", "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400", false),
    _inventoryTile("Lobster Tail", "02 kg", "KES 2,500/kg", "https://images.unsplash.com/photo-1559737558-2f5a35f4523b?w=400", true),
    _inventoryTile("Octopus", "15 kg", "KES 1,100/kg", "https://images.unsplash.com/photo-1551963831-b3b1ca40c98e?w=400", false),
  ]);

  Widget _inventoryTile(String name, String qty, String price, String img, bool isLowStock) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: isLowStock ? Colors.orange.withValues(alpha: 0.3) : Colors.transparent)),
    child: Row(children: [
      ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.network(img, width: 65, height: 65, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image))),
      const SizedBox(width: 15),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 16), overflow: TextOverflow.ellipsis),
        Text(price, style: GoogleFonts.urbanist(color: AppTheme.vibrantBlue, fontWeight: FontWeight.w800, fontSize: 13), overflow: TextOverflow.ellipsis),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(qty, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 15, color: isLowStock ? Colors.orange : AppTheme.navyDark)),
        if (isLowStock) Text("RESTOCK", style: GoogleFonts.urbanist(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w900)),
      ]),
    ]),
  );

  Widget _roundIconButton(IconData icon) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF8FBFF), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: AppTheme.navyDark, size: 20));
}