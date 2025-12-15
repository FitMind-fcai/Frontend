// Repository Implementation
import '../../domain/repositories/plan_repository.dart';
import '../data_sources/remote/plan_remote_data_source.dart';
import '../models/plan/nutrition_plan_generation_request.dart';
import '../models/plan/workout_plan_generation_request.dart';

class PlanRepositoryImpl implements PlanRepository {
  final PlanRemoteDataSource remote;

  PlanRepositoryImpl(this.remote);

  @override
  Future<void> createNutritionPreferences(NutritionPlanGenerationRequest request) {
    return remote.createNutritionPreferences(request);
  }

  @override
  Future<void> createWorkoutPreferences(WorkoutPlanGenerationRequest request) {
    return remote.createWorkoutPreferences(request);
  }
}