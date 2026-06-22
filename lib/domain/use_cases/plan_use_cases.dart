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

class SaveNutritionPlanUseCase {
  final PlanRepository repository;

  SaveNutritionPlanUseCase(this.repository);

  Future<NutritionPlanResult> call(NutritionPlanResult draft) {
    return repository.saveNutritionPlan(draft);
  }
}

class SaveWorkoutPlanUseCase {
  final PlanRepository repository;

  SaveWorkoutPlanUseCase(this.repository);

  Future<WorkoutPlanResult> call(WorkoutPlanResult draft) {
    return repository.saveWorkoutPlan(draft);
  }
}

class GetActiveNutritionPlanUseCase {
  final PlanRepository repository;

  GetActiveNutritionPlanUseCase(this.repository);

  Future<NutritionPlanResult> call() {
    return repository.getActiveNutritionPlan();
  }
}

class GetNutritionPlanByIdUseCase {
  final PlanRepository repository;

  GetNutritionPlanByIdUseCase(this.repository);

  Future<NutritionPlanResult> call(int planId) {
    return repository.getNutritionPlanById(planId);
  }
}

class GetActiveWorkoutPlanUseCase {
  final PlanRepository repository;

  GetActiveWorkoutPlanUseCase(this.repository);

  Future<WorkoutPlanResult> call() => repository.getActiveWorkoutPlan();
}

class GetWorkoutPlanByIdUseCase {
  final PlanRepository repository;

  GetWorkoutPlanByIdUseCase(this.repository);

  Future<WorkoutPlanResult> call(int planId) =>
      repository.getWorkoutPlanById(planId);
}

class DeleteNutritionPlanUseCase {
  final PlanRepository repository;

  DeleteNutritionPlanUseCase(this.repository);

  Future<void> call(int planId) => repository.deleteNutritionPlan(planId);
}

class DeleteWorkoutPlanUseCase {
  final PlanRepository repository;

  DeleteWorkoutPlanUseCase(this.repository);

  Future<void> call(int planId) => repository.deleteWorkoutPlan(planId);
}
class GetWorkoutDayExercisesUseCase {
  final PlanRepository repository;
  GetWorkoutDayExercisesUseCase(this.repository);
  Future<List<Exercise>> call(int planId, int dayId) =>
      repository.getWorkoutDayExercises(planId, dayId);
}