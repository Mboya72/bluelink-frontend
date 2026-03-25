import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
// Import your screens here
import '../fisherman/screens/dashboard_screen.dart';

class MainScaffold extends StatefulWidget {
  final UserRole role;

  const MainScaffold({super.key, required this.role});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // This fetches the specific data for the current user's role
    final navData = _getNavConfig(widget.role);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        // navData.screens contains the actual pages defined in your table
        children: navData.screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.vibrantBlue,
          unselectedItemColor: Colors.grey[500],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 26,
          items: navData.items,
        ),
      ),
    );
  }

  // --- The Logic Hub for your Role Table ---
  _NavConfig _getNavConfig(UserRole role) {
    switch (role) {
      case UserRole.fisherman:
        return _NavConfig(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.add_a_photo_rounded), label: "Shop"),
            BottomNavigationBarItem(icon: Icon(Icons.local_shipping_rounded), label: "Logistics"),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Messages"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          ],
          screens: [
            const FishermanDashboard(), // Tab 1: Earnings, Weather
            const Center(child: Text("Post Catch / Manage")), // Tab 2
            const Center(child: Text("Book Logistics")), // Tab 3
            const Center(child: Text("Chat")), // Tab 4
            const Center(child: Text("Boat Info / Licenses")), // Tab 5
          ],
        );

      case UserRole.buyer:
        return _NavConfig(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: "Marketplace"),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: "My Orders"),
            BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: "Tracking"),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Messages"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          ],
          screens: [
            const Center(child: Text("Browse Categories")),
            const Center(child: Text("Purchase History")),
            const Center(child: Text("Live Map Tracking")),
            const Center(child: Text("Chat")),
            const Center(child: Text("Favorites / Wallet")),
          ],
        );

      case UserRole.driver:
        return _NavConfig(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.assignment_rounded), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.navigation_rounded), label: "Active Trip"),
            BottomNavigationBarItem(icon: Icon(Icons.storefront_rounded), label: "Market"),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Messages"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          ],
          screens: [
            const Center(child: Text("Pickup Requests & Logs")),
            const Center(child: Text("Maps & Delivery Codes")),
            const Center(child: Text("Browse Equipment")),
            const Center(child: Text("Chat")),
            const Center(child: Text("Vehicle Specs / Docs")),
          ],
        );

    // Add Seller and Cold Storage cases here following the same pattern
      default:
        return _NavConfig(items: [], screens: []);
    }
  }
}

// Simple helper class to bundle items and screens
class _NavConfig {
  final List<BottomNavigationBarItem> items;
  final List<Widget> screens;
  _NavConfig({required this.items, required this.screens});
}