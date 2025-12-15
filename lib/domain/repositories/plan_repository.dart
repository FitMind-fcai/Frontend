// Abstract Repository (domain/repositories/plan_repository.dart)
import '../../data/models/plan/nutrition_plan_generation_request.dart';
import '../../data/models/plan/workout_plan_generation_request.dart';

abstract class PlanRepository {
  Future<void> createNutritionPreferences(NutritionPlanGenerationRequest request);
  Future<void> createWorkoutPreferences(WorkoutPlanGenerationRequest request);
}