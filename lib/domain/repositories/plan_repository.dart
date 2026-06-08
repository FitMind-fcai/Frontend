import '../../data/models/plan/nutrition_plan_generation_request.dart';
import '../../data/models/plan/nutrition_plan_result.dart';
import '../../data/models/plan/workout_plan_generation_request.dart';
import '../../data/models/plan/workout_plan_result.dart';

abstract class PlanRepository {
  Future<NutritionPlanResult> createNutritionPreferences(
      NutritionPlanGenerationRequest request);

  Future<WorkoutPlanResult> createWorkoutPreferences(
      WorkoutPlanGenerationRequest request);

  Future<NutritionPlanResult> saveNutritionPlan(NutritionPlanResult draft);
  Future<WorkoutPlanResult> saveWorkoutPlan(WorkoutPlanResult draft);

  Future<NutritionPlanResult> getActiveNutritionPlan();
  Future<NutritionPlanResult> getNutritionPlanById(int planId);
  Future<WorkoutPlanResult> getActiveWorkoutPlan();
  Future<WorkoutPlanResult> getWorkoutPlanById(int planId);

  Future<void> deleteNutritionPlan(int planId);
  Future<void> deleteWorkoutPlan(int planId);

}
