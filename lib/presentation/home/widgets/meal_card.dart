// lib/presentation/home/widgets/meal_card.dart

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class MealCard extends StatelessWidget {
  final String title;
  final String kcal;
  final String time;

  /// Optional — supplied when card is built from real API data.
  final double? proteinG;
  final double? fatsG;

  const MealCard({
    super.key,
    required this.title,
    required this.kcal,
    required this.time,
    this.proteinG,
    this.fatsG,
  });

  @override
  Widget build(BuildContext context) {
    final proteinLabel =
    proteinG != null ? '${proteinG!.toStringAsFixed(0)}g' : '25g';
    final fatLabel =
    fatsG != null ? '${fatsG!.toStringAsFixed(0)}g' : '17g';

    return Container(
      width: 280,
      height: 220,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
        image: const DecorationImage(
          image: AssetImage('assets/images/meal_image.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMacroTag(proteinLabel, 'Protein'),
              const SizedBox(height: 8),
              _buildMacroTag(fatLabel, 'Fat'),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontRegular,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.local_fire_department,
                      size: 16, color: Colors.grey[600]),
                  Text(
                    ' $kcal  •  ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w800,
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                  Icon(Icons.access_time,
                      size: 16, color: Colors.grey[600]),
                  Text(
                    ' $time',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w800,
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ImageIcon(
                AssetImage("assets/images/Monotone arrow right.png"),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroTag(String amount, String label) {
    return Container(
      width: 56,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: AppConstants.fontRegular,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontFamily: AppConstants.fontRegular,
            ),
          ),
        ],
      ),
    );
  }
}