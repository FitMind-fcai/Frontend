// lib/data/repositories/recommendations_repository_impl.dart

import '../../data/data_sources/remote/recommendations_remote_data_source.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../models/home/next_meal_response.dart';
import '../models/home/next_workout_response.dart';
import '../models/home/score_response.dart';

class RecommendationsRepositoryImpl implements RecommendationsRepository {
  final RecommendationsRemoteDataSource remote;

  RecommendationsRepositoryImpl(this.remote);

  @override
  Future<NextMealResponse> getNextMeal({String? time}) =>
      remote.getNextMeal(time: time);

  @override
  Future<WorkoutRecommendationResponse> getTodayWorkout() =>
      remote.getTodayWorkout();

  @override
  Future<ScoreResponse> getScore() => remote.getScore();
}