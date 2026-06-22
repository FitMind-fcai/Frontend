import '../../domain/repositories/plan_repository.dart';
import '../data_sources/remote/plan_remote_data_source.dart';
import '../models/plan/nutrition_plan_generation_request.dart';
import '../models/plan/nutrition_plan_result.dart';
import '../models/plan/workout_plan_generation_request.dart';
import '../models/plan/workout_plan_result.dart';

class PlanRepositoryImpl implements PlanRepository {
  final PlanRemoteDataSource remote;

  PlanRepositoryImpl(this.remote);

  @override
  Future<NutritionPlanResult> createNutritionPreferences(
      NutritionPlanGenerationRequest request) {
    return remote.createNutritionPreferences(request);
  }

  @override
  Future<WorkoutPlanResult> createWorkoutPreferences(
      WorkoutPlanGenerationRequest request) {
    return remote.createWorkoutPreferences(request);
  }
  @override
  Future<NutritionPlanResult> saveNutritionPlan(NutritionPlanResult draft) {
    return remote.saveNutritionPlan(draft);
  }
  @override
  Future<WorkoutPlanResult> saveWorkoutPlan(WorkoutPlanResult draft) {
    return remote.saveWorkoutPlan(draft);
  }

  @override
  Future<NutritionPlanResult> getActiveNutritionPlan() {
    return remote.getActiveNutritionPlan();
  }

  @override
  Future<NutritionPlanResult> getNutritionPlanById(int planId) {
    return remote.getNutritionPlanById(planId);
  }
  @override
  Future<WorkoutPlanResult> getActiveWorkoutPlan() =>
      remote.getActiveWorkoutPlan();

  @override
  Future<WorkoutPlanResult> getWorkoutPlanById(int planId) =>
      remote.getWorkoutPlanById(planId);

  @override
  Future<void> deleteNutritionPlan(int planId) async {
    return await remote.deleteNutritionPlan(planId);
  }

  @override
  Future<void> deleteWorkoutPlan(int planId) async {
    return await remote.deleteWorkoutPlan(planId);
  }
  @override
  Future<List<Exercise>> getWorkoutDayExercises(int planId, int dayId) {
    return remote.getWorkoutDayExercises(planId, dayId);
  }

}
