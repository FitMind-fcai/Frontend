// lib/network/recommendations_api_service.dart

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../data/data_sources/local/auth_local_data_source.dart';
import '../data/models/home/next_meal_response.dart';
import '../data/models/home/next_workout_response.dart';
import '../data/models/home/score_response.dart';

part 'recommendations_api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8000")
abstract class RecommendationsApiService {
  factory RecommendationsApiService(Dio dio, AuthLocalDataSource local) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await local.getCachedToken();
        if (token != null && token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('--- RESPONSE [${response.requestOptions.path}] ---');
        print('Status: ${response.statusCode}');
        print('Content-Type: ${response.headers.value('content-type')}');
        print('Data type: ${response.data.runtimeType}');
        print('Data: ${response.data}');
        print('-----------------------------------');
        return handler.next(response);
      },
      onError: (e, handler) {
        print('--- ERROR [${e.requestOptions.path}] ---');
        print('Status: ${e.response?.statusCode}');
        print('Data: ${e.response?.data}');
        print('-----------------------------------');
        return handler.next(e);
      },
    ));
    return _RecommendationsApiService(dio);
  }
  /// GET /v1/recommendations/next-meal
  /// [time] optional HH:MM format
  @GET("/v1/recommendations/next-meal")
  Future<NextMealResponse> getNextMeal({
    @Query("time") String? time,
  });

  /// GET /v1/recommendations/workout
  @GET("/v1/recommendations/next-workout")
  Future<WorkoutRecommendationResponse> getTodayWorkout();

  /// GET /v1/recommendations/score
  @GET("/v1/recommendations/score")
  Future<ScoreResponse> getScore();
}