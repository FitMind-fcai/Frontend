import '../../data/models/plan/nutrition_plan_generation_request.dart';
import '../../data/models/plan/nutrition_plan_result.dart';
import '../../data/models/plan/workout_plan_generation_request.dart';
import '../../data/models/plan/workout_plan_result.dart';
import '../repositories/plan_repository.dart';

class CreateNutritionPreferencesUseCase {
  final PlanRepository repository;

  CreateNutritionPreferencesUseCase(this.repository);

  Future<NutritionPlanResult> call(NutritionPlanGenerationRequest request) {
    return repository.createNutritionPreferences(request);
  }
}

class CreateWorkoutPreferencesUseCase {
  final PlanRepository repository;
  CreateWorkoutPreferencesUseCase(this.repository);

  Future<WorkoutPlanResult> call(WorkoutPlanGenerationRequest request) {
    return repository.createWorkoutPreferences(request);
  }
}
