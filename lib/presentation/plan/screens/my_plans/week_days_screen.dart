import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/plan/nutrition_plan_result.dart';
import 'day_meals_screen.dart';

class WeekDaysScreen extends StatelessWidget {
  final int weekNumber;
  final List<DayPlan> days;
  final String? startDate;

  const WeekDaysScreen({
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
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    const weekdays = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return '${weekdays[d.weekday]}, ${d.day} ${months[d.month]}';
  }

  @override
  Widget build(BuildContext context) {
    // CHANGED: light mode keeps every original literal color exactly as
    // given — isDark only branches where a value would actually break
    // against a dark background.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // CHANGED: was always const Color(0xFFF5F5F5).
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────
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
                        // CHANGED: was Colors.white.
                        color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          // CHANGED: was const Color(0xFFEAEAEA), invisible
                          // against a dark card.
                          color: isDark ? colorScheme.outlineVariant : const Color(0xFFEAEAEA),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        // CHANGED: was const Color(0xFF1A1A2E), same
                        // navy-on-dark contrast issue seen throughout.
                        color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Week $weekNumber',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          // CHANGED: was const Color(0xFF1A1A2E).
                          color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                          letterSpacing: -0.5,
                          fontFamily: AppConstants.fontRegular,
                        ),
                      ),
                      // NOTE: mid-tone gray, already reads fine on both
                      // light and dark — left untouched.
                      Text(
                        '${days.length} days',
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
            // ── Days list ─────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: days.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final day = days[index];
                  final date = _dateForDay(day.dayNumber);
                  return _DayCard(
                    day: day,
                    date: date,
                    dateLabel: date != null ? _formatDate(date) : null,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DayMealsScreen(day: day, date: date),
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

class _DayCard extends StatelessWidget {
  final DayPlan day;
  final DateTime? date;
  final String? dateLabel;
  final VoidCallback onTap;

  const _DayCard({
    required this.day,
    required this.date,
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
          // CHANGED: was Colors.white.
          color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              // CHANGED: dropped entirely in dark mode, same smudge issue
              // as every other card shadow fixed so far.
              color: isDark ? Colors.transparent : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Day number bubble
            // NOTE: low-opacity brand-color tint — untouched, still reads
            // as a warm accent patch on a dark card.
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  'D${day.dayNumber}',
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
                    day.dayName.isNotEmpty
                        ? day.dayName
                        : 'Day ${day.dayNumber}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      // CHANGED: was const Color(0xFF1A1A2E).
                      color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // NOTE: same mid-tone gray as "days" caption above —
                  // already fine on both light and dark, untouched.
                  if (dateLabel != null)
                    Text(
                      dateLabel!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                        fontFamily: AppConstants.fontRegular,
                      ),
                    ),
                ],
              ),
            ),
            // Meals count chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                // CHANGED: was const Color(0xFFF3F4F6) — near-white chip
                // that would look like a stray pale tile on a dark card.
                // A faint white overlay keeps it one step lighter than the
                // card without a hardcoded dark hex.
                color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${day.meals.length} meals',
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
            // NOTE: light gray chevron — subtle-by-design on white, and
            // already reads with good contrast on a dark card too —
            // untouched.
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFFD1D5DB), size: 22),
          ],
        ),
      ),
    );
  }
}