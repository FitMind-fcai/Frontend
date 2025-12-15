import '../../data/models/plan/nutrition_plan_generation_request.dart';
import '../../data/models/plan/workout_plan_generation_request.dart';
import '../repositories/plan_repository.dart';

class CreateNutritionPreferencesUseCase {
  final PlanRepository repository;

  CreateNutritionPreferencesUseCase(this.repository);

  Future<void> call(NutritionPlanGenerationRequest request) {
    return repository.createNutritionPreferences(request);
  }
}
class CreateWorkoutPreferencesUseCase {
  final PlanRepository repository;

  CreateWorkoutPreferencesUseCase(this.repository);

  Future<void> call(WorkoutPlanGenerationRequest request) {
    return repository.createWorkoutPreferences(request);
  }
}