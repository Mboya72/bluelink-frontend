import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyerChatDetailScreen extends StatefulWidget {
  final String name;
  final String role;

  const BuyerChatDetailScreen({
    super.key,
    required this.name,
    required this.role
  });

  @override
  State<BuyerChatDetailScreen> createState() => _BuyerChatDetailScreenState();
}

class _BuyerChatDetailScreenState extends State<BuyerChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Logic to scroll to bottom when new messages arrive
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _buildNegotiationHeader(),
            Expanded(
              child: _buildChatList(),
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
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A237E), size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE8EAF6),
            child: Text(widget.name[0],
                style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: const Color(0xFF1A237E)
                )
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.name,
                  style: GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w800, color: const Color(0xFF0D1231))
              ),
              Row(
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 4),
                  Text("Online • ${widget.role}",
                      style: GoogleFonts.urbanist(fontSize: 10, color: Colors.blueGrey[400], fontWeight: FontWeight.w700)
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.call_outlined, color: Color(0xFF1A237E), size: 22), onPressed: () {}),
        const SizedBox(width: 5),
      ],
    );
  }

  Widget _buildNegotiationHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.indigo.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF1F3F9), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.inventory_2_outlined, size: 18, color: Color(0xFF1A237E)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Yellowfin Tuna (40kg)", style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w800)),
                Text("Current Ask: Ksh 45,000",
                    style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.green[700])
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showCounterOfferSheet(),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF1A237E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text("Counter",
                style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      physics: const BouncingScrollPhysics(),
      children: [
        _chatBubble("Is the stock from the morning landing available?", true, "10:00 AM"),
        _chatBubble("Yes, we have 40kg of premium grade. Still on ice.", false, "10:02 AM"),
        _chatBubble("The price in the portal is Ksh 48,000. Can we do 45,000 if I order now?", true, "10:05 AM"),
        _chatBubble("Let me confirm with the landing clerk. Please hold.", false, "10:06 AM"),
      ],
    );
  }

  Widget _chatBubble(String text, bool isMe, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF1A237E) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 20),
              ),
              boxShadow: [
                if (!isMe)
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: Text(
              text,
              style: GoogleFonts.urbanist(
                color: isMe ? Colors.white : const Color(0xFF0D1231),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(time,
                style: GoogleFonts.urbanist(fontSize: 10, color: Colors.blueGrey[300], fontWeight: FontWeight.w700)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, -5))
        ],
        border: const Border(top: BorderSide(color: Color(0xFFF1F3F9))),
      ),
      child: Row(
        children: [
          _iconCircle(Icons.add_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: const Color(0xFFF8F9FD), borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: "Message ${widget.name.split(' ')[0]}...",
                  hintStyle: GoogleFonts.urbanist(color: Colors.blueGrey[300], fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              if (_messageController.text.isNotEmpty) {
                // Logic to send message
                _messageController.clear();
                _scrollToBottom();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Color(0xFF1A237E), shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _showCounterOfferSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows sheet to move up with keyboard
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 24, right: 24, top: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text("Propose Counter Offer", style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 25),
            TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              style: GoogleFonts.urbanist(fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                prefixText: "Ksh ",
                labelText: "Your Offer",
                labelStyle: GoogleFonts.urbanist(fontWeight: FontWeight.w700),
                filled: true,
                fillColor: const Color(0xFFF8F9FD),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              child: Text("Send Offer", style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconCircle(IconData icon) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: const Color(0xFFF1F3F9), borderRadius: BorderRadius.circular(12)),
    child: Icon(icon, color: const Color(0xFF1A237E), size: 20),
  );
}