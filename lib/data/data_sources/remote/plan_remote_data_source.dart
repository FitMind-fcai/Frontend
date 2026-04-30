import 'package:dio/dio.dart';

import '../../../network/plan_api_service.dart';
import '../../models/plan/nutrition_plan_generation_request.dart';
import '../../models/plan/nutrition_plan_result.dart';
import '../../models/plan/workout_plan_generation_request.dart';
import '../../models/plan/workout_plan_result.dart';

abstract class PlanRemoteDataSource {
  Future<NutritionPlanResult> createNutritionPreferences(
      NutritionPlanGenerationRequest body);

  Future<WorkoutPlanResult> createWorkoutPreferences(
      WorkoutPlanGenerationRequest body);
}

class PlanRemoteDataSourceImpl implements PlanRemoteDataSource {
  final PlanApiService apiService;

  PlanRemoteDataSourceImpl(this.apiService);

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
      return e.response!.statusMessage ?? "Unknown server error";
    }
    return e.message ?? "Network error occurred";
  }

  @override
  Future<NutritionPlanResult> createNutritionPreferences(
      NutritionPlanGenerationRequest body) async {
    try {
      final result = await apiService.createNutritionPreferences(body);
      print('=== NUTRITION RESULT ===');
      print('Calories: ${result.dailyCalories}');
      print('Protein: ${result.dailyProteinG}');
      print('Carbs: ${result.dailyCarbsG}');
      print('Fats: ${result.dailyFatsG}');
      print('Plan name: ${result.planName}');
      return result;
    } on DioException catch (e) {
      print('DioException data: ${e.response?.data}');
      throw Exception(_extractError(e));
    } catch (e, s) {
      print('RAW ERROR: $e');
      print('STACK: $s');
      throw Exception(e.toString());
    }
  }

  @override
  Future<WorkoutPlanResult> createWorkoutPreferences(
      WorkoutPlanGenerationRequest body) async {
    try {
      return await apiService.createWorkoutPreferences(body);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception("Unexpected error occurred");
    }
  }
}
