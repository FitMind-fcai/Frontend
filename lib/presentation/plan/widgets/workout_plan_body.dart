import 'package:fitmind/presentation/plan/widgets/week_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/plan/workout_plan_result.dart';
import '../screens/my_plans/workout_week_days_screen.dart';
import 'macro_pill.dart';

class WorkoutPlanBody extends StatelessWidget {
  final WorkoutPlanResult plan;

  const WorkoutPlanBody({required this.plan});

  Map<int, List<WorkoutDay>> _groupByWeek(List<WorkoutDay> days) {
    final Map<int, List<WorkoutDay>> weeks = {};
    for (final day in days) {
      final week = ((day.dayNumber - 1) ~/ 7) + 1;
      weeks.putIfAbsent(week, () => []).add(day);
    }
    return weeks;
  }

  DateTime? _dateForDay(int dayNumber) {
    if (plan.startDate.isEmpty) return null;
    try {
      return DateTime.parse(plan.startDate).add(Duration(days: dayNumber - 1));
    } catch (_) {
      return null;
    }
  }

  String _formatDateRange(List<WorkoutDay> weekDays) {
    if (weekDays.isEmpty) return '';
    final first = _dateForDay(weekDays.first.dayNumber);
    final last = _dateForDay(weekDays.last.dayNumber);
    if (first == null || last == null) return '';
    return '${_fmt(first)} – ${_fmt(last)}';
  }

  String _fmt(DateTime d) => '${d.day} ${_monthAbbr(d.month)} ${d.year}';

  String _monthAbbr(int m) => const [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ][m];

  @override
  Widget build(BuildContext context) {
    final weeks = _groupByWeek(plan.workoutDays);
    final sortedWeeks = weeks.keys.toList()..sort();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WorkoutPlanHeaderCard(plan: plan),
          const SizedBox(height: 28),
          const Text(
            'Weeks',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
              fontFamily: AppConstants.fontRegular,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: sortedWeeks.length,
            itemBuilder: (context, index) {
              final weekNum = sortedWeeks[index];
              final weekDays = weeks[weekNum]!;
              return WeekCard(
                weekNumber: weekNum,
                dayCount: weekDays.length,
                dateRange: _formatDateRange(weekDays),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutWeekDaysScreen(
                      weekNumber: weekNum,
                      days: weekDays,
                      startDate: plan.startDate,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WorkoutPlanHeaderCard extends StatelessWidget {
  final WorkoutPlanResult plan;

  const _WorkoutPlanHeaderCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage('assets/images/workout_card.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Color(0xCC1A1A2E),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.25),
              borderRadius: BorderRadius.circular(8),
              border:
              Border.all(color: AppConstants.primaryColor.withOpacity(0.5)),
            ),
            child: const Text(
              'ACTIVE PLAN',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                fontFamily: AppConstants.fontRegular,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            plan.planName.isNotEmpty ? plan.planName : 'Workout Plan',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              fontFamily: AppConstants.fontRegular,
            ),
          ),
          if (plan.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              plan.description,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
                fontFamily: AppConstants.fontRegular,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              MacroPill(
                label: plan.difficultyLevel,
                icon: Icons.bar_chart_rounded,
                color: const Color(0xFFF97316),
              ),
              const SizedBox(width: 8),
              MacroPill(
                label: '${plan.estimatedDurationPerSession} min',
                icon: Icons.timer_rounded,
                color: const Color(0xFF3B82F6),
              ),
              const SizedBox(width: 8),
              MacroPill(
                label: '${plan.workoutDays.length} days',
                icon: Icons.calendar_today_rounded,
                color: const Color(0xFF10B981),
              ),
            ],
          ),
        ],
      ),
    );
  }
}