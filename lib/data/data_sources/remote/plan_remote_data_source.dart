import 'package:dio/dio.dart';

import '../../../network/plan_api_service.dart';
import '../../models/plan/nutrition_plan_generation_request.dart';
import '../../models/plan/workout_plan_generation_request.dart';

abstract class PlanRemoteDataSource {
  Future<void> createNutritionPreferences(NutritionPlanGenerationRequest body);
  Future<void> createWorkoutPreferences(WorkoutPlanGenerationRequest body);
}

class PlanRemoteDataSourceImpl implements PlanRemoteDataSource {
  final PlanApiService apiService;

  PlanRemoteDataSourceImpl(this.apiService);

  String _extractError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;

      try {
        if (data is String) {
          return data;
        }

        if (data is Map<String, dynamic>) {
          if (data.containsKey('detail')) {
            return data['detail'].toString();
          }
          if (data.containsKey('message')) {
            return data['message'].toString();
          }

          // fallback: collect all values
          return data.values.join(', ');
        }
      } catch (_) {}

      return e.response!.statusMessage ?? "Unknown server error";
    }

    return e.message ?? "Network error occurred";
  }

  @override
  Future<void> createNutritionPreferences(NutritionPlanGenerationRequest body) async {
    try {
      await apiService.createNutritionPreferences(body);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception("Unexpected error occurred");
    }
  }

  @override
  Future<void> createWorkoutPreferences(WorkoutPlanGenerationRequest body) async {
    try {
      await apiService.createWorkoutPreferences(body);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception("Unexpected error occurred");
    }
  }
}