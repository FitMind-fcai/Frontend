import 'package:fitmind/presentation/plan/screens/my_plans/workout_days_excersises.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/plan/workout_plan_result.dart';
import 'package:easy_localization/easy_localization.dart';

class WorkoutWeekDaysScreen extends StatelessWidget {
  final int weekNumber;
  final List<WorkoutDay> days;
  final String? startDate;

  const WorkoutWeekDaysScreen({
    super.key,
    required this.weekNumber,
    required this.days,
    this.startDate,
  });

  DateTime? _dateForDay(int dayNumber) {
    if (startDate == null) return null;
    try {
      return DateTime.parse(startDate!).add(Duration(days: dayNumber - 1));
    } catch (_) {
      return null;
    }
  }

  String _formatDate(DateTime d) {
    final months = [
      '',
      'week_days.month_january'.tr(),
      'week_days.month_february'.tr(),
      'week_days.month_march'.tr(),
      'week_days.month_april'.tr(),
      'week_days.month_may'.tr(),
      'week_days.month_june'.tr(),
      'week_days.month_july'.tr(),
      'week_days.month_august'.tr(),
      'week_days.month_september'.tr(),
      'week_days.month_october'.tr(),
      'week_days.month_november'.tr(),
      'week_days.month_december'.tr(),
    ];
    final weekdays = [
      '',
      'week_days.weekday_monday'.tr(),
      'week_days.weekday_tuesday'.tr(),
      'week_days.weekday_wednesday'.tr(),
      'week_days.weekday_thursday'.tr(),
      'week_days.weekday_friday'.tr(),
      'week_days.weekday_saturday'.tr(),
      'week_days.weekday_sunday'.tr(),
    ];
    return 'week_days.date_label'.tr(namedArgs: {
      'weekday': weekdays[d.weekday],
      'day': '${d.day}',
      'month': months[d.month],
    });
  }

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: isDark ? colorScheme.outlineVariant : const Color(0xFFEAEAEA),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,

                        color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'week_days.week_label'.tr(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          // CHANGED: was const Color(0xFF1A1A2E).
                          color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                          letterSpacing: -0.5,
                          fontFamily: AppConstants.fontRegular,
                        ),
                      ),
                      Text(
                        'week_days.days_count'.tr(namedArgs: {'count': '${days.length}'}),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9CA3AF),
                          fontFamily: AppConstants.fontRegular,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: days.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final day = days[index];
                  final date = _dateForDay(day.dayNumber);
                  return _WorkoutDayCard(
                    day: day,
                    dateLabel: date != null ? _formatDate(date) : null,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkoutDayExercisesScreen(
                          day: day,
                          date: date,
                          Location: "My Plan",
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutDayCard extends StatelessWidget {
  final WorkoutDay day;
  final String? dateLabel;
  final VoidCallback onTap;

  const _WorkoutDayCard({
    required this.day,
    required this.dateLabel,
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
          color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.transparent : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(

                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  'week_days.day_short'.tr(namedArgs: {'number': '${day.dayNumber}'}),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.primaryColor,
                    fontFamily: AppConstants.fontRegular,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day.dayName.isNotEmpty ? day.dayName : 'week_days.day_label'.tr(namedArgs: {'number': '${day.dayNumber}'}),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                  const SizedBox(height: 3),
                  if (day.focus != null && day.focus!.isNotEmpty)
                    Text(
                      day.focus!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConstants.primaryColor.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                        fontFamily: AppConstants.fontRegular,
                      ),
                    ),

                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'week_days.exercises_count'.tr(namedArgs: {'count': '${day.exercises.length}'}),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  // CHANGED: was const Color(0xFF6B7280) — too low-contrast
                  // against the dark chip above, swapped to onSurfaceVariant.
                  color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF6B7280),
                  fontFamily: AppConstants.fontRegular,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // NOTE: this light gray chevron is subtle-by-design on a white
            // card, and actually reads with good (if slightly more
            // prominent) contrast on a dark card too — left untouched.
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFFD1D5DB), size: 22),
          ],
        ),
      ),
    );
  }
}