import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../driver/screens/chat_detail_screen.dart';

class SellerMessagesScreen extends StatefulWidget {
  const SellerMessagesScreen({super.key});

  @override
  State<SellerMessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<SellerMessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F8FE),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildStickyHeader(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildActiveContacts(),
                  const SizedBox(height: 32),
                  _buildRecentChatsHeader(),
                  const SizedBox(height: 16),
                  _buildChatList(),
                ]),
              ),
            ),
          ],
        ),
        floatingActionButton: _buildNewChatFab(),
      ),
    );
  }

  Widget _buildStickyHeader() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white.withValues(alpha: 0.8),
      centerTitle: false,
      title: Text(
        "Messages",
        style: GoogleFonts.urbanist(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF1A237E),
        ),
      ),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF1A237E)),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search conversations...",
          hintStyle: GoogleFonts.urbanist(color: Colors.grey[400], fontSize: 14),
          icon: const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildActiveContacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ACTIVE DRIVERS",
          style: GoogleFonts.urbanist(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.grey[500],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 85,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _activeAvatar("James", "https://i.pravatar.cc/150?u=1", true),
              _activeAvatar("Sarah", "https://i.pravatar.cc/150?u=2", true),
              _activeAvatar("Mike", "https://i.pravatar.cc/150?u=3", true),
              _activeAvatar("Admin", "https://i.pravatar.cc/150?u=4", false),
              _activeAvatar("John", "https://i.pravatar.cc/150?u=5", true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _activeAvatar(String name, String url, bool isOnline) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(url),
              ),
              if (isOnline)
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A237E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentChatsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "RECENT CHATS",
          style: GoogleFonts.urbanist(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.grey[500],
            letterSpacing: 1.2,
          ),
        ),
        Icon(Icons.filter_list_rounded, size: 18, color: Colors.grey[400]),
      ],
    );
  }

  Widget _buildChatList() {
    return Column(
      children: [
        _chatTile(
          name: "James Mwangi",
          role: "DRIVER",
          message: "The King Prawns are loaded and ready...",
          time: "2m ago",
          unreadCount: 2,
          url: "https://i.pravatar.cc/150?u=1",
        ),
        _chatTile(
          name: "City Market Wholesaler",
          role: "BUYER",
          message: "Can we increase the Tuna order?",
          time: "15m ago",
          unreadCount: 0,
          url: "https://i.pravatar.cc/150?u=8",
        ),
        _chatTile(
          name: "Bluelink Support",
          role: "ADMIN",
          message: "Your storage subscription is active.",
          time: "1h ago",
          unreadCount: 0,
          url: "https://i.pravatar.cc/150?u=4",
        ),
      ],
    );
  }

  Widget _chatTile({
    required String name,
    required String role,
    required String message,
    required String time,
    required int unreadCount,
    required String url,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              name: name,
              role: role,
              url: url,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10)
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 25, backgroundImage: NetworkImage(url)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _roleBadge(role),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: unreadCount > 0 ? Colors.black87 : Colors.grey[500],
                      fontWeight: unreadCount > 0 ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: GoogleFonts.urbanist(
                    fontSize: 11,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A237E),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleBadge(String role) {
    Color color;
    switch (role) {
      case 'DRIVER':
        color = Colors.indigo;
        break;
      case 'BUYER':
        color = Colors.teal;
        break;
      default:
        color = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        role,
        style: GoogleFonts.urbanist(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }

  Widget _buildNewChatFab() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 95, right: 5),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}
