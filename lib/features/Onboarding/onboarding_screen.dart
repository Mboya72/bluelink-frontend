import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../common_widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  UserRole? selectedRole;
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to Bluelink",
      "subtitle": "Connecting the entire blue economy from ocean to table.",
      "image": "assets/images/onboarding1.png"
    },
    {
      "title": "Streamlined Logistics",
      "subtitle": "Real-time tracking for catch, equipment, and cold storage.",
      "image": "assets/images/onboarding2.png"
    },
  ];

  void _finishOnboarding() {
    if (selectedRole != null) {
      developer.log('User selected role: ${selectedRole?.name}', name: 'Onboarding');
      // Navigate to your next screen here
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a role to continue")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: onboardingData.length + 1,
                itemBuilder: (context, index) {
                  if (index < onboardingData.length) {
                    return _buildOnboardingPage(onboardingData[index]);
                  } else {
                    return _buildRoleSelectionPage();
                  }
                },
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(Map<String, String> data) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.tsunami, size: 100, color: Colors.blue),
          const SizedBox(height: 40),
          Text(data['title']!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Text(data['subtitle']!,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildRoleSelectionPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text("Identify Your Role",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Select how you will use the platform",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: UserRole.values.map((role) => _roleCard(role)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleCard(UserRole role) {
    final isSelected = selectedRole == role;
    final roleColor = AppTheme.getRoleColor(role);

    return GestureDetector(
      onTap: () => setState(() => selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? roleColor.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? roleColor : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getRoleIcon(role),
              color: isSelected ? roleColor : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              role.name.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? roleColor : Colors.black87,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.fisherman: return Icons.anchor;
      case UserRole.buyer:     return Icons.shopping_basket;
      case UserRole.seller:    return Icons.settings_input_component;
      case UserRole.driver:    return Icons.local_shipping;
      case UserRole.storage:   return Icons.ac_unit;
      case UserRole.admin:     return Icons.admin_panel_settings;
    }
  }

  Widget _buildBottomControls() {
    final bool isLastPage = _currentPage == onboardingData.length;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hide Skip button on the last page
          Opacity(
            opacity: isLastPage ? 0 : 1,
            child: TextButton(
              onPressed: isLastPage ? null : () => _pageController.jumpToPage(onboardingData.length),
              child: const Text("SKIP"),
            ),
          ),
          SizedBox(
            width: 150,
            child: CustomButton(
              text: isLastPage ? "GET STARTED" : "NEXT",
              backgroundColor: selectedRole != null ? AppTheme.getRoleColor(selectedRole!) : null,
              onPressed: () {
                if (!isLastPage) {
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease);
                } else {
                  _finishOnboarding();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}