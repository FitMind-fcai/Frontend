import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:health/health.dart';

import '../../../data/models/home/next_meal_response.dart';
import '../../../data/models/home/next_workout_response.dart';
import '../../../data/models/home/score_response.dart';

import '../../../domain/use_cases/log_use_cases.dart';
import '../../../domain/use_cases/recommendations_use_cases.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc
    extends Bloc<HomeEvent, HomeState> {
  final GetNextMealUseCase getNextMealUseCase;
  final GetTodayWorkoutUseCase getTodayWorkoutUseCase;
  final GetScoreUseCase getScoreUseCase;
  final GetMealsSummaryUseCase getMealsSummaryUseCase;


  HomeBloc(
      this.getNextMealUseCase,
      this.getTodayWorkoutUseCase,
      this.getScoreUseCase,
      this.getMealsSummaryUseCase,

      ) : super(HomeInitial()) {
    on<GetNextMealEvent>(_onGetNextMeal);
    on<GetTodayWorkoutEvent>(_onGetTodayWorkout);
    on<GetScoreEvent>(_onGetScore);
    on<LoadHomeEvent>(_onLoadHomeRecommendations);
    on<RefreshLiveMetricsEvent>(_onRefreshLiveMetrics);

  }

  Future<void> _onGetNextMeal(
      GetNextMealEvent event,
      Emitter<HomeState> emit,
      ) async {
    final current = state;
    try {
      final result = await getNextMealUseCase(time: event.time);
      if (current is HomeLoaded) {
        emit(HomeLoaded(
          workout: current.workout,
          nextMeal: result,
          score: current.score,
        ));
      } else {
        emit(HomeLoaded(nextMeal: result));
      }
    } catch (_) {
      // keep showing whatever was already loaded rather than wiping the UI
    }
  }

  Future<void> _onGetTodayWorkout(
      GetTodayWorkoutEvent event,
      Emitter<HomeState> emit,
      ) async {
    final current = state;
    try {
      final result = await getTodayWorkoutUseCase();
      if (current is HomeLoaded) {
        emit(HomeLoaded(
          workout: result,
          nextMeal: current.nextMeal,
          score: current.score,
        ));
      } else {
        emit(HomeLoaded(workout: result));
      }
    } catch (_) {}
  }

  Future<void> _onGetScore(
      GetScoreEvent event,
      Emitter<HomeState> emit,
      ) async {
    final current = state;
    try {
      final result = await getScoreUseCase();
      if (current is HomeLoaded) {
        emit(HomeLoaded(
          workout: current.workout,
          nextMeal: current.nextMeal,
          score: result,
        ));
      } else {
        emit(HomeLoaded(score: result));
      }
    } catch (_) {}
  }

  Future<void> _onLoadHomeRecommendations(
      LoadHomeEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(HomeLoading());

    WorkoutRecommendationResponse? workout;
    NextMealResponse? meal;
    ScoreResponse? score;
    int? calories;
    int? steps;

    try {
      workout = await getTodayWorkoutUseCase();
    } catch (_) {}

    try {
      meal = await getNextMealUseCase(time: event.mealTime);
    } catch (_) {}

    try {
      score = await getScoreUseCase();
    } catch (_) {}
    try {
      final now = DateTime.now();
      final dateStr =
          '${now.year.toString().padLeft(4, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')}';
      final summary = await getMealsSummaryUseCase(date: dateStr);
      calories = summary.totalCalories;
    } catch (_) {}

    try {
      final health = Health();
      await health.configure();
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);
      steps = await health.getTotalStepsInInterval(midnight, now) ?? 0;
    } catch (_) {}

    emit(HomeLoaded(
      workout: workout,
      nextMeal: meal,
      score: score,
      calories: calories,
      steps: steps,
    ));
  }
  Future<void> _onRefreshLiveMetrics(
      RefreshLiveMetricsEvent event,
      Emitter<HomeState> emit,
      ) async {
    final current = state;
    if (current is! HomeLoaded) return;

    int? calories;
    int? steps;

    try {
      final now = DateTime.now();
      final dateStr =
          '${now.year.toString().padLeft(4, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')}';
      final summary = await getMealsSummaryUseCase(date: dateStr);
      calories = summary.totalCalories;
    } catch (_) {}

    try {
      final health = Health();
      await health.configure();
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);
      steps = await health.getTotalStepsInInterval(midnight, now) ?? 0;
    } catch (_) {}

    emit(HomeLoaded(
      workout: current.workout,
      nextMeal: current.nextMeal,
      score: current.score,
      calories: calories ?? current.calories,
      steps: steps ?? current.steps,
    ));
  }
  }
