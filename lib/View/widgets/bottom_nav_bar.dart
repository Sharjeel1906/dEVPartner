import 'package:flutter/material.dart';
import '../widgets/theme.dart';

/// Professional, responsive bottom navigation bar
Widget bottomNavigationBarUI({
  required BuildContext context,
  required int currentIndex,
  required Function(int) onTap,
}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  // Function to build individual nav item
  Widget navItem(IconData icon, String label, int index) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.008,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [Colors.greenAccent, Colors.cyanAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          borderRadius: BorderRadius.circular(width * 0.05),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white54,
              size: width * 0.06,
            ),
            SizedBox(width: width * 0.015),
            if (isSelected)
              Text(
                label,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  return Container(
    margin: EdgeInsets.all(width * 0.03),
    padding: EdgeInsets.symmetric(vertical: height * 0.012),
    decoration: BoxDecoration(
      color: C.surface, // match your theme
      borderRadius: BorderRadius.circular(width * 0.08),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: width * 0.03,
          offset: Offset(0, height * 0.005),
        )
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        navItem(Icons.explore, "Discover", 0),
        navItem(Icons.people, "Teams", 1),
        navItem(Icons.chat_bubble_outline, "Messages", 3),
        navItem(Icons.settings, "Setting", 2),
      ],
    ),
  );
}