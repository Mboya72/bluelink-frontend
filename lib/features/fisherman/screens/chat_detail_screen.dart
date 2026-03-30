import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String contextLabel;
  final Color themeColor;

  const ChatDetailScreen({
    super.key,
    required this.name,
    required this.contextLabel,
    required this.themeColor,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  // --- ACTIONS ---
  void _initiateVoiceCall() {
    // Logic for VOIP or Phone Dialer goes here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Calling ${widget.name}...")),
    );
  }

  void _initiateVideoCall() {
    // Logic for Video Call goes here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Starting video call with ${widget.name}...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBFF),
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _buildContextBanner(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildMessageBubble("Hello! Is the delivery #TRK-8821 ready for pickup?", false),
                  _buildMessageBubble("Yes, just finished loading the crates. Sending the receipt now.", true),
                  _buildImageAttachment("https://images.unsplash.com/photo-1554224155-169641357599?w=500", "Logistics_Receipt_04.jpg"),
                  _buildMessageBubble("Perfect. Driver is 5 mins away.", false),
                ],
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5, // Subtle shadow for depth
      toolbarHeight: 70,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: widget.themeColor.withOpacity(0.1),
            child: Icon(Icons.person, color: widget.themeColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: GoogleFonts.urbanist(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16)),
                Text("Online",
                    style: GoogleFonts.urbanist(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // --- VIDEO CALL BUTTON ---
        _buildHeaderAction(Icons.videocam_outlined, _initiateVideoCall),
        // --- VOICE CALL BUTTON ---
        _buildHeaderAction(Icons.call_outlined, _initiateVoiceCall),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildHeaderAction(IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F5F0), // Soft secondary background
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppTheme.navyDark, size: 22),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildContextBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
        color: widget.themeColor.withOpacity(0.08),
        border: Border(bottom: BorderSide(color: widget.themeColor.withOpacity(0.1))),
      ),
      child: Text(
        "Context: ${widget.contextLabel} #TRK-8821",
        style: GoogleFonts.urbanist(color: widget.themeColor, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppTheme.navyDark : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 20),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
        ),
        child: Text(
          text,
          style: GoogleFonts.urbanist(
            color: isMe ? Colors.white : Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildImageAttachment(String url, String fileName) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        width: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(21)),
              child: Image.network(url, height: 160, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file_outlined, size: 16, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(fileName,
                        style: GoogleFonts.urbanist(fontSize: 12, color: Colors.grey[800], fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, MediaQuery.of(context).padding.bottom + 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          _inputActionIcon(Icons.add_circle_outline_rounded, () {}),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F5F0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Type something...",
                  hintStyle: GoogleFonts.urbanist(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 48, width: 48,
            decoration: const BoxDecoration(color: AppTheme.navyDark, shape: BoxShape.circle),
            child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                onPressed: () {}
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputActionIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: AppTheme.navyDark, size: 28),
    );
  }
}