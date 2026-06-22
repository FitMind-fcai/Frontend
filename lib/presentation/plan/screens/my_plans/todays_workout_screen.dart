import 'package:fitmind/presentation/plan/screens/my_plans/workout_days_excersises.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../data/models/plan/workout_plan_result.dart';
import '../../manager/plan_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/plan/workout_plan_result.dart';
import '../../manager/plan_bloc.dart';

class TodayWorkoutTab extends StatefulWidget {
  const TodayWorkoutTab({super.key});

  @override
  State<TodayWorkoutTab> createState() => _TodayWorkoutTabState();
}

class _TodayWorkoutTabState extends State<TodayWorkoutTab> {
  WorkoutPlanResult? _plan;
  String? _error;

  @override
  void initState() {
    super.initState();
    context.read<PlanBloc>().add(const LoadActiveWorkoutPlanEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlanBloc, PlanState>(
      listenWhen: (prev, curr) =>
      curr is ActiveWorkoutPlanLoaded || (curr is PlanError && _plan == null),
      listener: (context, state) {
        if (state is ActiveWorkoutPlanLoaded) {
          setState(() => _plan = state.plan);
        } else if (state is PlanError) {
          setState(() => _error = state.message);
        }
      },
      child: _plan != null
          ? TodayWorkoutScreen(plan: _plan!)
          : Scaffold(
        body: Center(
          child: _error != null
              ? Text(_error!)
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
class TodayWorkoutScreen extends StatefulWidget {
  final WorkoutPlanResult plan;
  const TodayWorkoutScreen({super.key, required this.plan});

  @override
  State<TodayWorkoutScreen> createState() => _TodayWorkoutScreenState();
}

class _TodayWorkoutScreenState extends State<TodayWorkoutScreen> {
  final _today = DateTime.now();
  WorkoutDay? _todayDay;

  @override
  void initState() {
    super.initState();
    _todayDay = _findTodayDay();
    final day = _todayDay;
    if (day != null && widget.plan.id != null && day.id != null) {
      context
          .read<PlanBloc>()
          .add(LoadWorkoutDayExercisesEvent(widget.plan.id!, day.id!));
    }
  }

  WorkoutDay? _findTodayDay() {
    try {
      final start = DateTime.parse(widget.plan.startDate);
      final startOnly = DateTime(start.year, start.month, start.day);
      final todayOnly = DateTime(_today.year, _today.month, _today.day);
      final dayNumber = todayOnly.difference(startOnly).inDays + 1;
      if (dayNumber < 1) return null;
      for (final d in widget.plan.workoutDays) {
        if (d.dayNumber == dayNumber) return d;
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final day = _todayDay;
    if (day == null) {
      return Scaffold(
        appBar: AppBar(title: Text('today_workout.title'.tr())),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('today_workout.no_plan_today'.tr(),
                textAlign: TextAlign.center),
          ),
        ),
      );
    }

    return BlocBuilder<PlanBloc, PlanState>(
      builder: (context, state) {
        if (state is WorkoutDayExercisesLoaded) {
          final filled = WorkoutDay(
            id: day.id,
            dayNumber: day.dayNumber,
            dayName: day.dayName,
            focus: day.focus,
            exercises: state.exercises,
          );
          return WorkoutDayExercisesScreen(
            day: filled,
            date: DateTime(_today.year, _today.month, _today.day),
          );
        }
        if (state is PlanError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}