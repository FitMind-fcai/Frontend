import 'package:fitmind/presentation/plan/widgets/week_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/plan/nutrition_plan_result.dart';
import '../screens/my_plans/week_days_screen.dart';

class PlanBody extends StatelessWidget {
  final NutritionPlanResult plan;

  const PlanBody({required this.plan});

  Map<int, List<DayPlan>> _groupByWeek(List<DayPlan> days) {
    final Map<int, List<DayPlan>> weeks = {};
    for (final day in days) {
      final week = ((day.dayNumber - 1) ~/ 7) + 1;
      weeks.putIfAbsent(week, () => []).add(day);
    }
    return weeks;
  }

  DateTime? _dateForDay(int dayNumber) {
    if (plan.startDate == null) return null;
    try {
      return DateTime.parse(plan.startDate!).add(Duration(days: dayNumber - 1));
    } catch (_) {
      return null;
    }
  }

  String _formatDateRange(List<DayPlan> weekDays) {
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
    final weeks = _groupByWeek(plan.days);
    final sortedWeeks = weeks.keys.toList()..sort();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PlanHeaderCard(plan: plan),
          const SizedBox(height: 28),
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
                    builder: (_) => WeekDaysScreen(
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

class _PlanHeaderCard extends StatelessWidget {
  final NutritionPlanResult plan;

  const _PlanHeaderCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage('assets/images/meal_card.png'),
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
              color: const Color(0xFF3B82F6).withOpacity(0.25),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: const Color(0xFF3B82F6).withOpacity(0.5)),
            ),
            child: Text(
              'plan.active_plan'.tr(),
              style: const TextStyle(
                color: Color(0xFF93C5FD),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                fontFamily: AppConstants.fontRegular,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            plan.planName ?? 'plan.nutrition_plan'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              fontFamily: AppConstants.fontRegular,
            ),
          ),
          if (plan.description != null) ...[
            const SizedBox(height: 4),
            Text(
              plan.description!,
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
              _MacroPill(
                label: '${plan.dailyCalories} ${'meal_card.kcal'.tr()}',
                icon: Icons.local_fire_department_rounded,
                color: const Color(0xFFF97316),
              ),
              const SizedBox(width: 8),
              _MacroPill(
                label:'${plan.dailyProteinG}g ${'meal_card.protein'.tr()}',
                icon: Icons.fitness_center_rounded,
                color: const Color(0xFF3B82F6),
              ),
              const SizedBox(width: 8),
              _MacroPill(
                label: '${plan.days.length} ${'plan.days'.tr()}',
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

class _MacroPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _MacroPill(
      {required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
              fontFamily: AppConstants.fontRegular,
            ),
          ),
        ],
      ),
    );
  }
}
