// lib/common_widgets/custom_button.dart

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // We explicitly look up the primary color of the theme
    final Color primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white, // Button body is white
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: RawMaterialButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        elevation: 0.0,
        child: Icon(
          icon,
          color: primaryColor, // Icon matches the current background role color
          size: 30.0,
        ),
      ),
    );
  }
}