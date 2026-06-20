// home_bottom_nav_bar.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import 'bnb_custom_painter.dart';
import 'home_fb.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const HomeBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Dark:  your elevated surface card color  (#1E1E26)
    // Light: white — matches the original painter fill
    final barColor = isDark
        ? colorScheme.surfaceContainerHighest
        : Colors.white;

    return Container(
      width: size.width,
      height: 95,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(size.width, 95),
            painter: BNBCustomPainter(
              color: barColor,
              shadowColor: isDark ? Colors.black : Colors.black,
            ),
          ),
          Home_fb(),
          SizedBox(
            width: size.width,
            height: 95,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(context: context, icon: Icons.home_rounded, index: 0),
                _buildNavItem(context: context, icon: Icons.fitness_center, index: 1),
                SizedBox(width: size.width * 0.20),
                _buildNavItem(context: context, icon: Icons.restaurant, index: 2),
                _buildNavItem(context: context, icon: Icons.person, index: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required int index,
  }) {
    final isSelected = selectedIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    // Selected highlight pill:
    //   Light → faint grey  (original Colors.grey[200])
    //   Dark  → white at low opacity so it stays subtle on the dark bar
    final highlightColor = isDark
        ? Colors.white.withOpacity(0.10)
        : Colors.grey[200]!;

    // Icon color:
    //   Light → black when selected, grey when idle  (original)
    //   Dark  → white when selected, dimmed white when idle
    final activeIconColor = isDark ? Colors.white : Colors.black;
    final idleIconColor = isDark
        ? Colors.white.withOpacity(0.35)
        : Colors.grey[400]!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onItemSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(isSelected ? 12 : 8),
            decoration: BoxDecoration(
              color: isSelected ? highlightColor : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: isSelected ? 28 : 24,
              color: isSelected ? activeIconColor : idleIconColor,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            width: isSelected ? 20 : 0,
            height: 3.5,
            constraints: const BoxConstraints(minWidth: 0),
            decoration: BoxDecoration(
              color: isSelected ? AppConstants.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}