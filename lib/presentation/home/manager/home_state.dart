part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

// ─── Next Meal ────────────────────────────────────────────────────────────────

class NextMealLoading extends HomeState {}

class NextMealLoaded extends HomeState {
  final NextMealResponse nextMeal;
  const NextMealLoaded(this.nextMeal);

  @override
  List<Object?> get props => [nextMeal];
}

// ─── Today's Workout ──────────────────────────────────────────────────────────

class TodayWorkoutLoading extends HomeState {}

class TodayWorkoutLoaded extends HomeState {
  final WorkoutRecommendationResponse workout;
  const TodayWorkoutLoaded(this.workout);

  @override
  List<Object?> get props => [workout];
}

// ─── Score ────────────────────────────────────────────────────────────────────

class ScoreLoading extends HomeState {}

class ScoreLoaded extends HomeState {
  final ScoreResponse score;
  const ScoreLoaded(this.score);

  @override
  List<Object?> get props => [score];
}

// ─── Home combined load ───────────────────────────────────────────────────────

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final WorkoutRecommendationResponse? workout;
  final NextMealResponse? nextMeal;
  final ScoreResponse? score;
  final int? calories;
  final int? steps;

  const HomeLoaded({
    this.workout,
    this.nextMeal,
    this.score,
    this.calories,
    this.steps
  });

  @override
  List<Object?> get props => [workout, nextMeal, score,calories,steps];
}

// ─── Shared error ─────────────────────────────────────────────────────────────

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}