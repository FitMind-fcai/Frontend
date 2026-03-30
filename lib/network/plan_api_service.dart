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
}