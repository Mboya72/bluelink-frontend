import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'buyer_chat_detail_screen.dart';

// Assuming BuyerChatDetailScreen is in another file or defined below
class BuyerMessagesScreen extends StatefulWidget {
  const BuyerMessagesScreen({super.key});

  @override
  State<BuyerMessagesScreen> createState() => _BuyerMessagesScreenState();
}

class _BuyerMessagesScreenState extends State<BuyerMessagesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                  _buildChatList(),
                  _buildBroadcastList(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          // Optional: Add padding to FAB if it feels too low
          padding: const EdgeInsets.only(bottom: 95, right: 5),
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: const Color(0xFF1A237E),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
          ),
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
                    "Messages",
                    style: GoogleFonts.urbanist(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D1231),
                      letterSpacing: -0.5,
                    ),
                  ),
                  _headerActionIcon(Icons.search_rounded),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  controller: _tabController,
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
                  dividerColor: Colors.transparent,
                  labelColor: const Color(0xFF1A237E),
                  unselectedLabelColor: Colors.blueGrey[400],
                  labelStyle: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 13),
                  tabs: const [
                    Tab(text: "Direct Chats"),
                    Tab(text: "Logistics Alerts"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        _chatTile(
          name: "Lamu Fresh Landing",
          message: "The King Prawns are ready for pickup.",
          time: "2m ago",
          unreadCount: 2,
          isOnline: true,
          type: "Seller",
        ),
        _chatTile(
          name: "Samuel Kamau",
          message: "I've reached the Garsen checkpoint.",
          time: "15m ago",
          unreadCount: 0,
          isOnline: true,
          type: "Driver",
        ),
        _chatTile(
          name: "Mombasa Canning Co.",
          message: "Price quote for batch #9920 sent.",
          time: "1h ago",
          unreadCount: 0,
          isOnline: false,
          type: "Processor",
        ),
      ],
    );
  }

  Widget _chatTile({
    required String name,
    required String message,
    required String time,
    required int unreadCount,
    required bool isOnline,
    required String type,
  }) {
    return GestureDetector(
      onTap: () {
        // Correctly navigating to the detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BuyerChatDetailScreen(
              name: name,
              role: type,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE0E5F2).withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFF1F3F9),
                  child: Text(name[0],
                      style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A237E))),
                ),
                if (isOnline)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2)),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(name,
                          style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: const Color(0xFF0D1231))),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF1F3F9),
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(type.toUpperCase(),
                            style: GoogleFonts.urbanist(
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                color: Colors.blueGrey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.urbanist(
                          fontSize: 13,
                          color: Colors.blueGrey[400],
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(time,
                    style: GoogleFonts.urbanist(
                        fontSize: 11,
                        color: Colors.blueGrey[300],
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                if (unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                        color: Color(0xFF1A237E), shape: BoxShape.circle),
                    child: Text(unreadCount.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  )
                else
                  const Icon(Icons.done_all_rounded, size: 16, color: Colors.blueAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBroadcastList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        _broadcastCard(
          title: "New Harvest Alert",
          content: "Large Tuna stock just arrived at Malindi Hub. First come first serve.",
          time: "30m ago",
          icon: Icons.tsunami_rounded,
        ),
        _broadcastCard(
          title: "Weather Advisory",
          content: "High tides expected in Lamu. Potential 2-hour delay in shipping.",
          time: "4h ago",
          icon: Icons.wb_cloudy_rounded,
        ),
      ],
    );
  }

  Widget _broadcastCard({
    required String title,
    required String content,
    required String time,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [const Color(0xFF1A237E).withOpacity(0.05), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF1A237E), size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 4),
                Text(content, style: GoogleFonts.urbanist(fontSize: 13, color: Colors.blueGrey[600], height: 1.4)),
                const SizedBox(height: 10),
                Text(time, style: GoogleFonts.urbanist(fontSize: 11, color: Colors.blueGrey[400], fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerActionIcon(IconData icon) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: const Color(0xFFF1F3F9), borderRadius: BorderRadius.circular(12)),
    child: Icon(icon, size: 20, color: const Color(0xFF1A237E)),
  );
}