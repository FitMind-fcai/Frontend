import '../../data/models/plan/nutrition_plan_generation_request.dart';
import '../../data/models/plan/nutrition_plan_result.dart';
import '../../data/models/plan/workout_plan_generation_request.dart';
import '../../data/models/plan/workout_plan_result.dart';

abstract class PlanRepository {
  Future<NutritionPlanResult> createNutritionPreferences(
      NutritionPlanGenerationRequest request);

  Future<WorkoutPlanResult> createWorkoutPreferences(
      WorkoutPlanGenerationRequest request);
}
