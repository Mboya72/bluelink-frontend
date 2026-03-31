import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../driver/screens/job_board_screen.dart';
import '../fisherman/screens/dashboard_screen.dart';
import '../fisherman/screens/logistics_screen.dart';
import '../fisherman/screens/messages_screen.dart';
import '../fisherman/screens/my_shop_screen.dart';
import '../fisherman/screens/profile_screen.dart'; // UserRole is imported from here

// --- MODELS ---

// Removed 'enum UserRole' from here because it's already in app_theme.dart

class NavItem {
  final IconData icon;
  final String label;
  const NavItem({required this.icon, required this.label});
}

class _NavConfig {
  final List<NavItem> items;
  final List<Widget> screens;
  _NavConfig({required this.items, required this.screens});
}

// --- MAIN SCAFFOLD ---

class MainScaffold extends StatefulWidget {
  final UserRole role;

  const MainScaffold({super.key, required this.role});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  @override
  void didUpdateWidget(MainScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.role != widget.role) {
      setState(() => _selectedIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final navData = _getNavConfig(widget.role);
    final activeIndex = _selectedIndex >= navData.screens.length ? 0 : _selectedIndex;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: activeIndex,
        children: navData.screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: activeIndex,
        items: navData.items,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  _NavConfig _getNavConfig(UserRole role) {
    switch (role) {
      case UserRole.fisherman:
        return _NavConfig(
          items: const [
            NavItem(icon: Icons.dashboard_rounded, label: "Dashboard"),
            NavItem(icon: Icons.add_a_photo_rounded, label: "Shop"),
            NavItem(icon: Icons.local_shipping_rounded, label: "Logistics"),
            NavItem(icon: Icons.chat_bubble_outline, label: "Messages"),
            NavItem(icon: Icons.person_outline, label: "Profile"),
          ],
          screens: const [
            FishermanDashboard(),
            MyShopScreen(),
            LogisticsScreen(),
            FisherMessagesScreen(),
            FisherProfileScreen(),
          ],
        );

      case UserRole.buyer:
        return _NavConfig(
          items: const [
            NavItem(icon: Icons.search_rounded, label: "Market"),
            NavItem(icon: Icons.receipt_long_rounded, label: "Orders"),
            NavItem(icon: Icons.map_outlined, label: "Tracking"),
            NavItem(icon: Icons.chat_bubble_outline, label: "Messages"),
            NavItem(icon: Icons.person_outline, label: "Profile"),
          ],
          screens: const [
            Center(child: Text("Browse Marketplace")),
            Center(child: Text("Purchase History")),
            Center(child: Text("Live Map Tracking")),
            Center(child: Text("Chat")),
            Center(child: Text("Favorites / Wallet")),
          ],
        );

      case UserRole.seller:
        return _NavConfig(
          items: const [
            NavItem(icon: Icons.inventory_2_rounded, label: "Inventory"),
            NavItem(icon: Icons.local_shipping_rounded, label: "Logistics"),
            NavItem(icon: Icons.bar_chart_rounded, label: "Analytics"),
            NavItem(icon: Icons.chat_bubble_outline, label: "Messages"),
            NavItem(icon: Icons.storefront_rounded, label: "Store"),
          ],
          screens: const [
            Center(child: Text("Manage Stock")),
            Center(child: Text("Shipments")),
            Center(child: Text("Sales Trends")),
            Center(child: Text("Chat")),
            Center(child: Text("Store Settings")),
          ],
        );

      case UserRole.driver:
        return _NavConfig(
          items: const [
            NavItem(icon: Icons.assignment_rounded, label: "Tasks"),
            NavItem(icon: Icons.navigation_rounded, label: "Active"),
            NavItem(icon: Icons.storefront_rounded, label: "Market"),
            NavItem(icon: Icons.chat_bubble_outline, label: "Messages"),
            NavItem(icon: Icons.person_outline, label: "Profile"),
          ],
          screens: const [
            DriverJobBoardScreen(),
            Center(child: Text("Maps")),
            Center(child: Text("Browse Equipment")),
            Center(child: Text("Chat")),
            Center(child: Text("Vehicle Specs")),
          ],
        );

      case UserRole.storage:
        return _NavConfig(
          items: const [
            NavItem(icon: Icons.ac_unit_rounded, label: "Storage"),
            NavItem(icon: Icons.calendar_today_rounded, label: "Bookings"),
            NavItem(icon: Icons.shopping_bag_outlined, label: "Market"),
            NavItem(icon: Icons.chat_bubble_outline, label: "Messages"),
            NavItem(icon: Icons.business_rounded, label: "Facility"),
          ],
          screens: const [
            Center(child: Text("Capacity")),
            Center(child: Text("Manage Bookings")),
            Center(child: Text("Marketplace")),
            Center(child: Text("Chat")),
            Center(child: Text("Facility Details")),
          ],
        );

      case UserRole.admin:
        return _NavConfig(
          items: const [
            NavItem(icon: Icons.admin_panel_settings_rounded, label: "Users"),
            NavItem(icon: Icons.campaign_rounded, label: "Market"),
            NavItem(icon: Icons.gavel_rounded, label: "Disputes"),
            NavItem(icon: Icons.payments_rounded, label: "Finance"),
            NavItem(icon: Icons.insights_rounded, label: "Logs"),
          ],
          screens: const [
            Center(child: Text("Verify IDs")),
            Center(child: Text("Ads Control")),
            Center(child: Text("Resolution")),
            Center(child: Text("Finance Hub")),
            Center(child: Text("Analytics")),
          ],
        );
    }
  }
}

// --- CUSTOM NAVIGATION UI ---

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavItem> items;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // Using AppTheme color for consistency
    final Color activeColor = AppTheme.vibrantBlue;
    const Color inactiveColor = Colors.grey;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = currentIndex == index;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: isSelected ? 24 : 0,
                    height: 3,
                    decoration: BoxDecoration(
                      color: isSelected ? activeColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    items[index].icon,
                    color: isSelected ? activeColor : inactiveColor,
                    size: 26,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[index].label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? activeColor : inactiveColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}