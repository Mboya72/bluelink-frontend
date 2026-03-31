import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';
import 'chat_detail_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBFF),
        body: Column(
          children: [
            _buildHeader(),
            _buildCategoryFilter(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  _buildChatTile(
                    name: "Omar Farooq",
                    role: "Station Master - Old Port",
                    lastMsg: "Is the Fresh Snapper delivery on track?",
                    time: "10:24 AM",
                    unreadCount: 2,
                    isOnline: true,
                    image: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400",
                  ),
                  _buildChatTile(
                    name: "Sarah Johnson",
                    role: "Buyer",
                    lastMsg: "Thank you for the engine oil!",
                    time: "Yesterday",
                    unreadCount: 0,
                    isOnline: false,
                    image: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400",
                  ),
                  _buildChatTile(
                    name: "Bluelink Support",
                    role: "System Agent",
                    lastMsg: "Your payout for Route #88 has been processed.",
                    time: "Oct 24",
                    unreadCount: 0,
                    isOnline: true,
                    isSupport: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTile({
    required String name,
    required String role,
    required String lastMsg,
    required String time,
    required int unreadCount,
    required bool isOnline,
    String? image,
    bool isSupport = false,
  }) {
    final String imageUrl = image ?? "https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=random";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              name: name,
              role: role,
              url: imageUrl,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: isSupport ? AppTheme.navyDark : Colors.grey[200],
                  backgroundImage: image != null ? NetworkImage(image) : null,
                  child: image == null ? const Icon(Icons.headset_mic_rounded, color: Colors.white) : null,
                ),
                if (isOnline)
                  Positioned(
                    right: 2, bottom: 2,
                    child: Container(
                      width: 14, height: 14,
                      decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.navyDark)),
                      Text(time, style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Text(role, style: GoogleFonts.urbanist(color: AppTheme.vibrantBlue, fontWeight: FontWeight.w700, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    lastMsg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.urbanist(
                      color: unreadCount > 0 ? AppTheme.navyDark : Colors.grey,
                      fontWeight: unreadCount > 0 ? FontWeight.w800 : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(left: 10),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppTheme.vibrantBlue, shape: BoxShape.circle),
                child: Text("$unreadCount", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 25, right: 25, bottom: 20),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Messages", style: GoogleFonts.urbanist(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.navyDark)),
              Text("Direct contact with buyers & stations", style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
            ],
          ),
          _roundIconButton(Icons.search_rounded),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: Row(
        children: [
          _filterChip("All", true),
          const SizedBox(width: 10),
          _filterChip("Stations", false),
          const SizedBox(width: 10),
          _filterChip("Buyers", false),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.vibrantBlue : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? Colors.transparent : Colors.grey.shade200),
      ),
      child: Text(label, style: GoogleFonts.urbanist(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.w800, fontSize: 13)),
    );
  }

  Widget _roundIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF8FBFF), borderRadius: BorderRadius.circular(15)),
      child: Icon(icon, color: AppTheme.navyDark, size: 22),
    );
  }
}
