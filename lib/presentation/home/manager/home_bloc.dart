import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/home/next_meal_response.dart';
import '../../../data/models/home/next_workout_response.dart';
import '../../../data/models/home/score_response.dart';

import '../../../domain/use_cases/recommendations_use_cases.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc
    extends Bloc<HomeEvent, HomeState> {
  final GetNextMealUseCase getNextMealUseCase;
  final GetTodayWorkoutUseCase getTodayWorkoutUseCase;
  final GetScoreUseCase getScoreUseCase;

  HomeBloc(
      this.getNextMealUseCase,
      this.getTodayWorkoutUseCase,
      this.getScoreUseCase,
      ) : super(HomeInitial()) {
    on<GetNextMealEvent>(_onGetNextMeal);
    on<GetTodayWorkoutEvent>(_onGetTodayWorkout);
    on<GetScoreEvent>(_onGetScore);
    on<LoadHomeEvent>(_onLoadHomeRecommendations);
  }

  Future<void> _onGetNextMeal(
      GetNextMealEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(NextMealLoading());
    try {
      final result = await getNextMealUseCase(time: event.time);
      emit(NextMealLoaded(result));
    } catch (e) {
      emit(HomeError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onGetTodayWorkout(
      GetTodayWorkoutEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(TodayWorkoutLoading());
    try {
      final result = await getTodayWorkoutUseCase();
      emit(TodayWorkoutLoaded(result));
    } catch (e) {
      emit(HomeError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onGetScore(
      GetScoreEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(ScoreLoading());
    try {
      final result = await getScoreUseCase();
      emit(ScoreLoaded(result));
    } catch (e) {
      emit(HomeError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLoadHomeRecommendations(
      LoadHomeEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(HomeLoading());

    WorkoutRecommendationResponse? workout;
    NextMealResponse? meal;
    ScoreResponse? score;

    try {
      workout = await getTodayWorkoutUseCase();
    } catch (_) {}

    try {
      meal = await getNextMealUseCase(time: event.mealTime);
    } catch (_) {}

    try {
      score = await getScoreUseCase();
    } catch (_) {}

    emit(HomeLoaded(workout: workout, nextMeal: meal, score: score));
  }
}