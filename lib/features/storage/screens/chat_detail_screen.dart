import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StorageChatDetailScreen extends StatefulWidget {
  final String userName;
  final String userRole;
  final String userImg;

  const StorageChatDetailScreen({
    super.key,
    required this.userName,
    required this.userRole,
    required this.userImg,
  });

  @override
  State<StorageChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<StorageChatDetailScreen> {
  final TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildBookingSnippet(), // Contextual info about the storage request
          Expanded(child: _buildMessageList()),
          _buildInputArea(context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 70,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0D1231), size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.userImg)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.userName, style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF0D1231))),
              Text(widget.userRole, style: GoogleFonts.urbanist(fontSize: 11, color: Colors.blueGrey[300], fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.videocam_outlined, color: Color(0xFF1A237E)), onPressed: () {}),
        IconButton(icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF1A237E)), onPressed: () {}),
      ],
    );
  }

  Widget _buildBookingSnippet() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF1A237E).withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.inventory_2_outlined, color: Color(0xFF1A237E), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text("Active Request: 500kg Tuna (Cold Room A)",
                style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF1A237E))),
          ),
          Text("VIEW INFO", style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFF1A237E))),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        _chatBubble("Hello! I'm arriving at the facility in 15 minutes with the Swordfish batch.", false, "10:00 AM"),
        _chatBubble("Copy that, Omar. We have Bay 04 ready for offloading. Temperature is set to -18°C.", true, "10:02 AM"),
        _chatBubble("Great. Is the security guard briefed for late entry?", false, "10:05 AM"),
        _chatBubble("Yes, the gate protocol is updated. See you soon.", true, "10:06 AM"),
      ],
    );
  }

  Widget _chatBubble(String message, bool isMe, String time) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF1A237E) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 20),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message, style: GoogleFonts.urbanist(color: isMe ? Colors.white : const Color(0xFF0D1231), fontSize: 14, fontWeight: FontWeight.w600, height: 1.4)),
            const SizedBox(height: 6),
            Text(time, style: GoogleFonts.urbanist(color: isMe ? Colors.white70 : Colors.blueGrey[300], fontSize: 10, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: MediaQuery.of(context).padding.bottom + 10, top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          Container(
            height: 45, width: 45,
            decoration: BoxDecoration(color: const Color(0xFFF1F4F9), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.add_rounded, color: Color(0xFF1A237E)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: const Color(0xFFF1F4F9), borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: _msgController,
                decoration: InputDecoration(hintText: "Type message...", hintStyle: GoogleFonts.urbanist(fontSize: 14, color: Colors.blueGrey[300]), border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 45, width: 45,
            decoration: BoxDecoration(color: const Color(0xFF1A237E), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}