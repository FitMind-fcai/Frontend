import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_constants.dart';

class WeekCard extends StatelessWidget {
  final int weekNumber;
  final int dayCount;
  final String dateRange;
  final VoidCallback onTap;

  const WeekCard({
    required this.weekNumber,
    required this.dayCount,
    required this.dateRange,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark?Colors.black45:Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.calendar_view_week_rounded,
                    size: 18,
                    color: AppConstants.primaryColor,
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: Colors.grey[300], size: 20),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'week_card.week'.tr()} $weekNumber',
                  style:  TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color:isDark?Colors.white: Color(0xFF1A1A2E),
                    fontFamily: AppConstants.fontRegular,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$dayCount ${'week_card.days'.tr()}',
                  style:  TextStyle(
                    fontSize: 12,
                    color:isDark?Colors.white: Color(0xFF9CA3AF),
                    fontFamily: AppConstants.fontRegular,
                  ),
                ),
                if (dateRange.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    dateRange,
                    style:  TextStyle(
                      fontSize: 10,
                      color:isDark?Colors.white: Color(0xFFB0B7C3),
                      fontFamily: AppConstants.fontRegular,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}