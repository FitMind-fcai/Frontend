// lib/data/data_sources/remote/recommendations_remote_data_source.dart

import 'package:dio/dio.dart';

import '../../../network/recommendations_api_service.dart';
import '../../models/home/next_meal_response.dart';
import '../../models/home/next_workout_response.dart';
import '../../models/home/score_response.dart';


abstract class RecommendationsRemoteDataSource {
  Future<NextMealResponse> getNextMeal({String? time});
  Future<WorkoutRecommendationResponse> getTodayWorkout();
  Future<ScoreResponse> getScore();
}

class RecommendationsRemoteDataSourceImpl
    implements RecommendationsRemoteDataSource {
  final RecommendationsApiService apiService;

  RecommendationsRemoteDataSourceImpl(this.apiService);

  String _extractError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      try {
        if (data is String) return data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('detail')) return data['detail'].toString();
          if (data.containsKey('message')) return data['message'].toString();
          return data.values.join(', ');
        }
      } catch (_) {}
      return e.response!.statusMessage ?? 'Unknown server error';
    }
    return e.message ?? 'Network error occurred';
  }

  @override
  Future<NextMealResponse> getNextMeal({String? time}) async {
    try {
      return await apiService.getNextMeal(time: time);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<WorkoutRecommendationResponse> getTodayWorkout() async {
    try {
      return await apiService.getTodayWorkout();
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ScoreResponse> getScore() async {
    try {
      return await apiService.getScore();
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}