// lib/presentation/home/widgets/workout_highlight_card.dart

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/home/next_workout_response.dart';

class WorkoutHighlightCard extends StatelessWidget {
  /// Pass null to render the card with placeholder/fallback text.
  final WorkoutRecommendationResponse? workout;

  const WorkoutHighlightCard({super.key, this.workout});

  @override
  Widget build(BuildContext context) {
    final hasPlan = workout?.hasPlan ?? false;
    final isArabic = context.locale.languageCode == 'ar';

    // Derived display values
    final title = hasPlan
        ? (workout!.workoutDayName.isNotEmpty
            ? workout!.workoutDayName
            : workout!.focusArea)
        : '';

    final durationText = hasPlan
        ? '${workout!.estimatedDurationMinutes} ${'workout_card.minutes_short'.tr()}'
        : '';

    final exerciseCount = hasPlan
        ? '${workout!.exercises.length} ${'workout_card.exercises'.tr()}'
        : '';

    final focusLabel = hasPlan ? workout!.focusArea : '';

    return Container(
      width: double.infinity,
      height: 240,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage('assets/images/workout_card.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    isArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  const Icon(Icons.fitness_center,
                      color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    exerciseCount,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontRegular,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      focusLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: AppConstants.extraBold,
                        fontFamily: AppConstants.fontRegular,
                      ),
                    ),
                  ),
                  if (hasPlan && workout!.sessionsLoggedToday > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            'workout_card.logged'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: AppConstants.fontRegular,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          // No plan message overlay
          if (!hasPlan && workout != null)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    workout!.message.isNotEmpty
                        ? workout!.message
                        : 'workout_card.generate_plan'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
