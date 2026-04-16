import 'package:fitmind/core/constants/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  final ImageProvider ? graphImage;
  final IconData? fallbackIcon;// Optional: You can replace this with a custom graph widget

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
      this.graphImage,
      this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 200,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppConstants.fontRegular,
                ),
              ),
              Icon(icon, color: Colors.white, size: 18),
            ],
          ),
          const Spacer(),
          // Placeholder for the graph/visual element
          Center(
            child: graphImage != null
                ? Image(image: graphImage!, width: 140, height: 76)
                : Icon(
              fallbackIcon ?? Icons.show_chart_rounded,
              color: Colors.white54,
              size: 40,
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value.split(' ')[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontRegular,
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}