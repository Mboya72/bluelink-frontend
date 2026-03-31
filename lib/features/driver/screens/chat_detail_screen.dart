import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String role;

  const ChatDetailScreen({super.key, required this.name, required this.role});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Quick reply options for logistics drivers
  final List<String> quickReplies = [
    "I've arrived at the station",
    "Stuck in traffic (10 mins)",
    "Goods unloaded successfully",
    "Can't find the entrance",
    "On my way now"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStatusBanner(),
          Expanded(child: _buildMessageList()),
          _buildQuickReplyBar(),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.navyDark, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400"),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.name, style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.navyDark)),
              Text(widget.role, style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.vibrantBlue)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.phone_in_talk_rounded, color: AppTheme.navyDark)),
      ],
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: AppTheme.vibrantBlue.withValues(alpha: 0.05),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined, size: 16, color: AppTheme.vibrantBlue),
          const SizedBox(width: 10),
          Text("Relates to Trip #8842 - Station A",
              style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.navyDark)),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _chatBubble("Hello Hassan, what is your current location?", false, "10:00 AM"),
        _chatBubble("Just passed the main gate. I'll be there in 5 mins.", true, "10:02 AM"),
        _chatBubble("Perfect. We have the forklift ready at Dock 4.", false, "10:03 AM"),
      ],
    );
  }

  Widget _chatBubble(String message, bool isMe, String time) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isMe ? AppTheme.navyDark : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 20),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message,
                style: GoogleFonts.urbanist(
                    color: isMe ? Colors.white : AppTheme.navyDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14
                )),
            const SizedBox(height: 5),
            Text(time,
                style: GoogleFonts.urbanist(
                    color: isMe ? Colors.white60 : Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.w500
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplyBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: quickReplies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Logic to send message automatically
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppTheme.vibrantBlue.withValues(alpha: 0.2)),
              ),
              child: Center(
                child: Text(quickReplies[index],
                    style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.vibrantBlue)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).padding.bottom + 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          _roundAction(Icons.location_on_outlined, AppTheme.vibrantBlue.withValues(alpha: 0.1)),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: const Color(0xFFF8FBFF), borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(hintText: "Type a message...", border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: AppTheme.navyDark, shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundAction(IconData icon, Color bg) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: AppTheme.vibrantBlue, size: 20),
    );
  }
}