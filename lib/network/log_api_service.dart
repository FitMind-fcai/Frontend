// lib/network/log_api_service.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../data/data_sources/local/auth_local_data_source.dart';
import '../data/models/meal_log/excersise_search_result.dart';
import '../data/models/meal_log/meal_scan_request.dart';
import '../data/models/meal_log/meal_scan_result.dart';
import '../data/models/meal_log/meal_text_result.dart';
import '../data/models/meal_log/voice_meal_scan_result.dart';
import '../data/models/meal_log/voice_workout_scan_result.dart';

part 'log_api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8000")
abstract class LogApiService {
  // Store the Dio instance so the manual multipart methods can use it
  static late Dio _dio;
  static const _base = 'http://10.0.2.2:8000';

  factory LogApiService(Dio dio, AuthLocalDataSource local) {
    _dio = dio;

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await local.getCachedToken();
        if (token != null && token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
    ));
    return _LogApiService(dio);
  }

  // ── Retrofit-generated endpoints ─────────────────────────────────────────

  static Future<MealScanResult> scanMeal(MealScanRequest request) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        request.filePath,
        filename: 'meal.${request.imageFormat}',
      ),
      'image_format': request.imageFormat,
      'meal_type': request.mealType,
      'language': request.language,
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '$_base/v1/tracking/meals/scan',
      data: formData,
    );

    return MealScanResult.fromJson(response.data!);
  }

  @GET("/v1/tracking/meals/search")
  Future<List<FoodSearchResult>> searchFoods(
    @Query("q") String query, {
    @Query("limit") int limit = 5,
  });

  @GET("/v1/tracking/workouts/search")
  Future<List<ExerciseSearchResult>> searchExercises(
    @Query("q") String query, {
    @Query("limit") int limit = 5,
  });

  @POST("/v1/tracking/logs")
  Future<void> saveLogs(@Body() Map<String, dynamic> body);

  // ── Manual multipart endpoints ────────────────────────────────────────────

  static Future<VoiceMealScanResult> scanMealVoice(
    String filePath,
    String audioFormat,
  ) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: 'voice_meal.$audioFormat',
        ),
        'audio_format': audioFormat,
      });

      final response = await _dio.post<Map<String, dynamic>>(
        '$_base/v1/tracking/meals/voice',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      return VoiceMealScanResult.fromJson(response.data!);
    } on DioException catch (e) {
      print('=== DIO ERROR ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Status: ${e.response?.statusCode}');
      print('Body: ${e.response?.data}');
      rethrow;
    }
  }

  static Future<VoiceWorkoutScanResult> scanWorkoutVoice(
    String filePath,
    String audioFormat,
  ) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: 'voice_workout.$audioFormat',
        ),
        'audio_format': audioFormat,
      });

      final response = await _dio.post<Map<String, dynamic>>(
        '$_base/v1/tracking/workouts/voice',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      return VoiceWorkoutScanResult.fromJson(response.data!);
    } on DioException catch (e) {
      print('=== DIO ERROR ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Status: ${e.response?.statusCode}');
      print('Body: ${e.response?.data}');
      rethrow;
    }
  }
}
