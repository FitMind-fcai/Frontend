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

  Future<NutritionPlanResult> saveNutritionPlan(NutritionPlanResult draft);
  Future<WorkoutPlanResult> saveWorkoutPlan(WorkoutPlanResult draft);
  Future<NutritionPlanResult> getActiveNutritionPlan();
  Future<NutritionPlanResult> getNutritionPlanById(int planId);
  Future<WorkoutPlanResult> getActiveWorkoutPlan();
  Future<WorkoutPlanResult> getWorkoutPlanById(int planId);
  Future<void> deleteNutritionPlan(int planId);
  Future<void> deleteWorkoutPlan(int planId);



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

  @override
  Future<NutritionPlanResult> saveNutritionPlan(
      NutritionPlanResult draft) async {
    try {
      print('=== SAVING NUTRITION PLAN ===');
      print('Plan: ${draft.planName}');
      print('Days: ${draft.days.length}');

      // Check first meal ingredients
      if (draft.days.isNotEmpty && draft.days[0].meals.isNotEmpty) {
        final firstMeal = draft.days[0].meals[0];
        print('First meal: ${firstMeal.mealName}');
        print('Ingredients type: ${firstMeal.ingredients.runtimeType}');
        print('Ingredients length: ${firstMeal.ingredients?.length ?? 0}');
        if (firstMeal.ingredients != null &&
            (firstMeal.ingredients as List).isNotEmpty) {
          print('First ingredient: ${(firstMeal.ingredients as List)[0]}');
        }
      }

      final draftJson = draft.toJson();
      print('Draft JSON keys: ${draftJson.keys}');

      final payload = {
        "draft_plan": draftJson,
        "generated_from_preferences": draft.generatedFromPreferences,
        "update_plan_id": draft.updatePlanId,
      };

      final result = await apiService.saveNutritionPlan(payload);
      print('=== SAVE SUCCESS ===');
      print('Saved plan: ${result.planName}');
      return result;
    } on DioException catch (e) {
      print('DioException during save: ${e.response?.data}');
      throw Exception(_extractError(e));
    } catch (e) {
      print('Error during save: $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<WorkoutPlanResult> saveWorkoutPlan(WorkoutPlanResult draft) async {
    try {
      print('=== SENDING SAVE REQUEST ===');
      final result = await apiService.saveWorkoutPlan({
        "draft_plan": draft.toJson(),
        "generated_from_preferences": draft.generatedFromPreferences,
        "update_plan_id": draft.updatePlanId,
      });
      print('=== SAVE RESPONSE RECEIVED: ${result.planName}');
      return result;
    } on DioException catch (e) {
      print('=== DIO ERROR: ${e.response?.data}');
      throw Exception(_extractError(e));
    } catch (e, s) {
      print('=== SAVE CRASH: $e');
      print('=== STACK: $s');
      throw Exception(e.toString());
    }
  }

  // Add to PlanRemoteDataSourceImpl:
  @override
  Future<NutritionPlanResult> getActiveNutritionPlan() async {
    try {
      return await apiService.getActiveNutritionPlan();
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<NutritionPlanResult> getNutritionPlanById(int planId) async {
    try {
      return await apiService.getNutritionPlanById(planId);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<WorkoutPlanResult> getActiveWorkoutPlan() async {
    try {
      return await apiService.getActiveWorkoutPlan();
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<WorkoutPlanResult> getWorkoutPlanById(int planId) async {
    try {
      return await apiService.getWorkoutPlanById(planId);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  @override
  Future<void> deleteNutritionPlan(int planId) async {
    try {
      await apiService.deleteNutritionPlan(planId);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteWorkoutPlan(int planId) async {
    try {
      await apiService.deleteWorkoutPlan(planId);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
