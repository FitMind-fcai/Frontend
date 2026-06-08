import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../data/data_sources/local/auth_local_data_source.dart';
import '../data/models/plan/nutrition_plan_generation_request.dart';
import '../data/models/plan/nutrition_plan_result.dart';
import '../data/models/plan/workout_plan_generation_request.dart';
import '../data/models/plan/workout_plan_result.dart';

part 'plan_api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8000")
abstract class PlanApiService {
  factory PlanApiService(Dio dio, AuthLocalDataSource local) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await local.getCachedToken();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );
    return _PlanApiService(dio);
  }

  @POST("/v1/plans/generate/nutrition")
  Future<NutritionPlanResult> createNutritionPreferences(
    @Body() NutritionPlanGenerationRequest body,
  );

  @POST("/v1/plans/generate/workout")
  Future<WorkoutPlanResult> createWorkoutPreferences(
    @Body() WorkoutPlanGenerationRequest body,
  );

  @POST("/v1/plans/save/nutrition")
  Future<NutritionPlanResult> saveNutritionPlan(
    @Body() Map<String, dynamic> body,
  );

  @POST("/v1/plans/save/workout")
  Future<WorkoutPlanResult> saveWorkoutPlan(
    @Body() Map<String, dynamic> body,
  );

  @GET("/v1/nutrition-plans/active")
  Future<NutritionPlanResult> getActiveNutritionPlan();

  @GET("/v1/nutrition-plans/{plan_id}")
  Future<NutritionPlanResult> getNutritionPlanById(
    @Path("plan_id") int planId,
  );

  @GET("/v1/workout-plans/active")
  Future<WorkoutPlanResult> getActiveWorkoutPlan();

  @GET("/v1/workout-plans/{planId}")
  Future<WorkoutPlanResult> getWorkoutPlanById(@Path("planId") int planId);

  @DELETE("/v1/nutrition-plans/{plan_id}")
  Future<void> deleteNutritionPlan(
    @Path("plan_id") int planId,
  );

  @DELETE("/v1/workout-plans/{planId}")
  Future<void> deleteWorkoutPlan(
    @Path("planId") int planId,
  );
}
