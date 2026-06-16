// lib/domain/repositories/recommendations_repository.dart

import '../../data/models/home/next_meal_response.dart';
import '../../data/models/home/next_workout_response.dart';
import '../../data/models/home/score_response.dart';


abstract class RecommendationsRepository {
  Future<NextMealResponse> getNextMeal({String? time});
  Future<WorkoutRecommendationResponse> getTodayWorkout();
  Future<ScoreResponse> getScore();
}