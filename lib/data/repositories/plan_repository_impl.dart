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
}
