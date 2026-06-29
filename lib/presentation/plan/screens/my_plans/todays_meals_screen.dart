import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../data/models/plan/nutrition_plan_result.dart';
import 'day_meals_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/plan_bloc.dart'; // adjust path as needed


class TodayMealsTab extends StatefulWidget {
  const TodayMealsTab({super.key});

  @override
  State<TodayMealsTab> createState() => _TodayMealsTabState();
}

class _TodayMealsTabState extends State<TodayMealsTab> {
  @override
  void initState() {
    super.initState();
    context.read<PlanBloc>().add(const LoadActivePlanEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanBloc, PlanState>(
      builder: (context, state) {
        if (state is ActivePlanLoaded) {
          return TodayMealsScreen(plan: state.plan);
        }
        if (state is PlanError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class TodayMealsScreen extends StatelessWidget {
  final NutritionPlanResult plan;
  const TodayMealsScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    DateTime? startDate;
    try {
      startDate = DateTime.parse(plan.startDate);
    } catch (_) {
      startDate = null;
    }

    DayPlan? todayPlan;
    if (startDate != null) {
      final startDateOnly =
      DateTime(startDate.year, startDate.month, startDate.day);
      final dayNumber =
          todayDateOnly.difference(startDateOnly).inDays + 1;

      if (dayNumber >= 1) {
        for (final d in plan.days) {
          if (d.dayNumber == dayNumber) {
            todayPlan = d;
            break;
          }
        }
      }
    }

    if (todayPlan == null) {
      return Scaffold(
        appBar: AppBar(title: Text('today_meals.title'.tr())),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'today_meals.no_plan_today'.tr(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return DayMealsScreen(day: todayPlan, date: todayDateOnly,Location: "Home",);
  }
}