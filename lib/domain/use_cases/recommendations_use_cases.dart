// lib/domain/use_cases/recommendations_use_cases.dart


import '../../data/models/home/next_meal_response.dart';
import '../../data/models/home/next_workout_response.dart';
import '../../data/models/home/score_response.dart';
import '../repositories/recommendations_repository.dart';

class GetNextMealUseCase {
  final RecommendationsRepository repository;
  GetNextMealUseCase(this.repository);

  Future<NextMealResponse> call({String? time}) =>
      repository.getNextMeal(time: time);
}

class GetTodayWorkoutUseCase {
  final RecommendationsRepository repository;
  GetTodayWorkoutUseCase(this.repository);

  Future<WorkoutRecommendationResponse> call() =>
      repository.getTodayWorkout();
}

class GetScoreUseCase {
  final RecommendationsRepository repository;
  GetScoreUseCase(this.repository);

  Future<ScoreResponse> call() => repository.getScore();
}