import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_theme.dart';
import 'chat_detail_screen.dart'; // Ensure this points to your new file

class FisherMessagesScreen extends StatefulWidget {
  const FisherMessagesScreen({super.key});

  @override
  State<FisherMessagesScreen> createState() => _FisherMessagesScreenState();
}

class _FisherMessagesScreenState extends State<FisherMessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBFF),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildSearchSection(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildMessageTile(
                    context: context,
                    name: "Main Port Terminal",
                    message: "Your catch delivery #TRK-8821 arrived at dock 4.",
                    time: "10m ago",
                    unreadCount: 1,
                    contextLabel: "Logistics",
                    color: Colors.blueAccent,
                  ),
                  _buildMessageTile(
                    context: context,
                    name: "Fresh Market Buyer",
                    message: "Are the prawns available for Tuesday?",
                    time: "1h ago",
                    unreadCount: 2,
                    contextLabel: "Marketplace",
                    color: Colors.teal,
                  ),
                  _buildMessageTile(
                    context: context,
                    name: "Equipment Support",
                    message: "Your generator rental expires tomorrow.",
                    time: "3h ago",
                    unreadCount: 0,
                    contextLabel: "Maintenance",
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text("Messages",
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w900, fontSize: 24, color: AppTheme.navyDark)),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.navyDark)),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15)],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey, size: 22),
            const SizedBox(width: 12),
            Text("Search contacts...", style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTile({
    required BuildContext context,
    required String name,
    required String message,
    required String time,
    required int unreadCount,
    required String contextLabel,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              name: name,
              contextLabel: contextLabel,
              themeColor: color,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade50),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(18)),
              child: Icon(Icons.waves, color: color, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, fontSize: 15)),
                      Text(time, style: GoogleFonts.urbanist(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(message,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.urbanist(
                          color: unreadCount > 0 ? AppTheme.navyDark : Colors.grey,
                          fontWeight: unreadCount > 0 ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 13
                      )),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(contextLabel,
                        style: GoogleFonts.urbanist(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}