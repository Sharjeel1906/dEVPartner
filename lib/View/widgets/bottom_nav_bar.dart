import 'package:flutter/material.dart';

/// Professional, responsive bottom navigation bar fitting safe area
Widget bottomNavigationBarUI({
  required BuildContext context,
  required int currentIndex,
  required Function(int) onTap,
}) {
  final bottomPadding = MediaQuery.of(context).padding.bottom;

  // Function to build individual nav item
  Widget navItem(IconData icon, String label, int index) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            colors: [Colors.greenAccent, Colors.cyanAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white54,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  return Container(
    padding: EdgeInsets.only(
      left: 16,
      right: 16,
      top: 10,
      bottom: bottomPadding > 0 ? bottomPadding + 6 : 10,
    ),
    decoration: BoxDecoration(
      color: const Color(0xFF0C0E1F), // Matches C.bg solid dark blue tone
      border: Border(
        top: BorderSide(
          color: Colors.white.withOpacity(0.08),
          width: 0.8,
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, -2),
        )
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        navItem(Icons.explore, "Discover", 0),
        navItem(Icons.people, "Teams", 1),
        navItem(Icons.auto_awesome, "AI Match", 2),
        navItem(Icons.chat_bubble_outline, "Messages", 3),
      ],
    ),
  );
}