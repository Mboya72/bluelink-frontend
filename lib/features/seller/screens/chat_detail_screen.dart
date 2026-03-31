import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String role;
  final String url; // Add this line

  const ChatDetailScreen({
    super.key,
    required this.name,
    required this.role,
    required this.url, // Add this line
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FE),
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 120),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildDateDivider("Today, March 31"),
                _buildChatBubble("Hey James, have you reached the cold storage facility yet?", true),
                _buildChatBubble("Yes, just arrived. The temperature is stable at 4.2°C.", false),
                _buildChatBubble("Great. Please ensure the King Prawns are loaded first.", true),
                _buildChatBubble("Understood. Will update the progress bar in the app once moving.", false),
              ],
            ),
          ),
          _buildInputDock(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AppBar(
            backgroundColor: Colors.white.withValues(alpha: 0.8),
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1A237E)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.url)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name, style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF1A237E))),
                    Text(widget.role, style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.green)),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.videocam_outlined, color: Color(0xFF1A237E))),
              IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined, color: Color(0xFF1A237E))),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatBubble(String message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF1A237E) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 20),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Text(
          message,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isMe ? Colors.white : const Color(0xFF1A237E),
          ),
        ),
      ),
    );
  }

  Widget _buildDateDivider(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          date,
          style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey[400], letterSpacing: 0.5),
        ),
      ),
    );
  }

  Widget _buildInputDock() {
    return Container(
      padding: EdgeInsets.only(
          left: 20, right: 20, top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5))
        ],
      ),
      child: Column(
        children: [
          // Logistics Quick Actions
          Row(
            children: [
              _quickAction(Icons.location_on_rounded, "Share Port"),
              _quickAction(Icons.inventory_2_rounded, "Shipment ID"),
              _quickAction(Icons.ac_unit_rounded, "Temp Log"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F8FE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _messageController,
                    style: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: GoogleFonts.urbanist(color: Colors.grey[400]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 48, width: 48,
                  decoration: const BoxDecoration(color: Color(0xFF1A237E), shape: BoxShape.circle),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF1A237E)),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF1A237E))),
        ],
      ),
    );
  }
}