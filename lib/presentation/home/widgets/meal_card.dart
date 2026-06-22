// lib/presentation/home/widgets/meal_card.dart

import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class MealCard extends StatelessWidget {
  final String title;
  final String kcal;
  final String time;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final proteinLabel = proteinG != null ? '${proteinG!.toStringAsFixed(0)}g' : '25g';
    final fatLabel = fatsG != null ? '${fatsG!.toStringAsFixed(0)}g' : '17g';

    return Container(
      width: 280,
      height: 220,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
        image:  DecorationImage(
          image: isDark?const AssetImage('assets/images/darkmeal.png'):const AssetImage('assets/images/meal_image.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMacroTag(proteinLabel, 'Protein', isDark),
              const SizedBox(height: 8),
              _buildMacroTag(fatLabel, 'Fat', isDark),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontRegular,
                  color: isDark ? Colors.white : null,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.local_fire_department,
                      size: 16,
                      color: isDark ? Colors.white60 : Colors.grey[600]),
                  Text(
                    ' $kcal  •  ',
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey[600],
                      fontWeight: FontWeight.w800,
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                  Icon(Icons.access_time,
                      size: 16,
                      color: isDark ? Colors.white60 : Colors.grey[600]),
                  Text(
                    ' $time',
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey[600],
                      fontWeight: FontWeight.w800,
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                ],
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildMacroTag(String amount, String label, bool isDark) {
    return Container(
      width: 56,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.10) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: AppConstants.fontRegular,
              color: isDark ? Colors.white : null,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.white54 : Colors.grey[600],
              fontFamily: AppConstants.fontRegular,
            ),
          ),
        ],
      ),
    );
  }
}