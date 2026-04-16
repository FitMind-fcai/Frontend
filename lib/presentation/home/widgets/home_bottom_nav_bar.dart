import 'package:flutter/cupertino.dart';
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

    return Container(
      width: size.width,
      height: 95,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(size.width, 95),
            painter: BNBCustomPainter(),
          ),
          Home_fb(),
          SizedBox(
            width: size.width,
            height: 95,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(icon: Icons.home_rounded, index: 0),
                _buildNavItem(icon: Icons.fitness_center, index: 1),
                SizedBox(width: size.width * 0.20),
                _buildNavItem(icon: Icons.restaurant, index: 2),
                _buildNavItem(icon: Icons.person, index: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final isSelected = selectedIndex == index;

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
              color: isSelected ? Colors.grey[200] : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: isSelected ? 28 : 24,
              color: isSelected ? Colors.black : Colors.grey[400],
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