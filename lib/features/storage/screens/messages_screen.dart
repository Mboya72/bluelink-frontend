import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat_detail_screen.dart';


class StorageMessagesScreen extends StatefulWidget {
  const StorageMessagesScreen({super.key});

  @override
  State<StorageMessagesScreen> createState() => _StorageMessagesScreenState();
}

class _StorageMessagesScreenState extends State<StorageMessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _activeFilter = "All Chats";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFE),
        body: Stack(
          children: [
            _buildScrollingContent(),
            _buildStickyHeader(context),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 95, right: 5),
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: const Color(0xFF1A237E),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildStickyHeader(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: topPadding + 10,
            bottom: 15,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Messages",
                      style: GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFF0D1231))),
                  _headerIcon(Icons.filter_list_rounded),
                ],
              ),
              const SizedBox(height: 15),
              _buildSearchBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: "Search conversations...",
          hintStyle: GoogleFonts.urbanist(color: Colors.blueGrey[300], fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.blueGrey[400], size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildScrollingContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: MediaQuery.of(context).padding.top + 155,
        bottom: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContextFilters(),
          const SizedBox(height: 25),
          _buildSectionHeader("Recent Chats"),
          const SizedBox(height: 15),
          _chatTile("Omar Hassan", "Fisherman", "Can I extend my storage for 2 more days?", "12:45 PM", 2, "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400"),
          _chatTile("Lamu Fish Traders", "Trader Group", "The Tuna delivery is arriving at Bay 04.", "11:20 AM", 0, "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400"),
          _chatTile("Sarah Kwale", "Logistics", "Truck KBZ 442Y is 10 mins away.", "Yesterday", 0, "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400"),
          _chatTile("Bamburi Marine", "Fisherman", "Payment for Invoice #882 confirmed.", "Yesterday", 0, "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400"),
        ],
      ),
    );
  }

  Widget _buildContextFilters() {
    final filters = ["All Chats", "Fishermen", "Traders", "Logistics"];
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return _filterChip(filters[index], _activeFilter == filters[index]);
        },
      ),
    );
  }

  Widget _filterChip(String label, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1A237E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isActive ? [BoxShadow(color: const Color(0xFF1A237E).withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))] : null,
          border: Border.all(color: isActive ? const Color(0xFF1A237E) : const Color(0xFFF1F4F9)),
        ),
        child: Text(label,
            style: GoogleFonts.urbanist(
                color: isActive ? Colors.white : Colors.blueGrey[400],
                fontSize: 13,
                fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _chatTile(String name, String role, String lastMsg, String time, int unread, String img) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StorageChatDetailScreen(
              userName: name,
              userRole: role,
              userImg: img,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F4F9)),
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(radius: 28, backgroundImage: NetworkImage(img)),
                Container(
                  height: 14, width: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
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
                    children: [
                      Text(name, style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 15, color: const Color(0xFF0D1231))),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFF1A237E).withValues(alpha: 0.05), borderRadius: BorderRadius.circular(6)),
                        child: Text(role.toUpperCase(), style: GoogleFonts.urbanist(fontSize: 8, fontWeight: FontWeight.w900, color: const Color(0xFF1A237E))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(lastMsg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: unread > 0 ? const Color(0xFF0D1231) : Colors.blueGrey[300],
                        fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w500,
                      )),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(time, style: GoogleFonts.urbanist(fontSize: 10, color: Colors.blueGrey[300], fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                if (unread > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF1A237E), borderRadius: BorderRadius.circular(10)),
                    child: Text(unread.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  )
                else
                  const Icon(Icons.done_all_rounded, size: 14, color: Colors.blueAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w900, color: const Color(0xFF0D1231)));
  }

  Widget _headerIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF1F4F9))
      ),
      child: Icon(icon, color: const Color(0xFF1A237E), size: 20),
    );
  }
}
