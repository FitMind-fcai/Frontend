import 'package:dio/dio.dart';

import '../../../network/log_api_service.dart';
import '../../models/home/calorie_screen_result.dart';
import '../../models/meal_log/excersise_search_result.dart';
import '../../models/meal_log/meal_log_history/hydration_log_entry.dart';
import '../../models/meal_log/meal_log_history/meal_log_entry.dart';
import '../../models/meal_log/meal_log_history/sleep_log_entry.dart';
import '../../models/meal_log/meal_log_history/weight_log_entry.dart';
import '../../models/meal_log/meal_log_history/workout_log_entry.dart';
import '../../models/meal_log/meal_scan_request.dart';
import '../../models/meal_log/meal_scan_result.dart';
import '../../models/meal_log/meal_text_log_request.dart';
import '../../models/meal_log/meal_text_result.dart';
import '../../models/meal_log/voice_meal_log_request.dart';
import '../../models/meal_log/voice_meal_scan_result.dart';
import '../../models/meal_log/voice_workout_request.dart';
import '../../models/meal_log/voice_workout_scan_result.dart';
import '../../models/meal_log/workout_text_log_request.dart';
import '../../models/save_log_request.dart';

abstract class LogRemoteDataSource {
  Future<MealScanResult> scanMeal(MealScanRequest request);

  Future<VoiceMealScanResult> scanMealVoice(String filePath, String audioFormat,String language);
  Future<VoiceWorkoutScanResult> scanWorkoutVoice(String filePath, String audioFormat,String language);


  Future<List<FoodSearchResult>> searchFoods(String query, {int limit});
  Future<List<ExerciseSearchResult>> searchExercises(String query, {int limit});
  Future<void> saveLogs(SaveLogRequest request);
  Future<MealsSummaryResult> getMealsSummary({String? date});

  Future<List<MealLogHistory>> getMealLogs({String? date});
  Future<List<WorkoutLogHistory>> getWorkoutLogs({String? date});
  Future<List<WeightLogHistory>> getWeightLogs({String? date});
  Future<List<SleepLogHistory>> getSleepLogs({String? date});
  Future<List<HydrationLogHistory>> getHydrationLogs({String? date});
  Future<void> deleteLog(String category, int logId);
}

class LogRemoteDataSourceImpl implements LogRemoteDataSource {
  final LogApiService apiService;

  LogRemoteDataSourceImpl(this.apiService);

  String _extractError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      try {
        if (data is String) return data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('detail')) return data['detail'].toString();
          if (data.containsKey('message')) return data['message'].toString();
          return data.values.join(', ');
        }
      } catch (_) {}
      return e.response!.statusMessage ?? 'Unknown server error';
    }
    return e.message ?? 'Network error occurred';
  }


  @override
  Future<VoiceMealScanResult> scanMealVoice(String filePath, String audioFormat,String language) async {
    try {
      return await LogApiService.scanMealVoice(filePath, audioFormat,language);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<VoiceWorkoutScanResult> scanWorkoutVoice(String filePath, String audioFormat,String language) async {
    try {
      return await LogApiService.scanWorkoutVoice(filePath, audioFormat,language);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<FoodSearchResult>> searchFoods(String query,
      {int limit = 5}) async {
    try {
      return await apiService.searchFoods(query, limit: limit);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ExerciseSearchResult>> searchExercises(String query,
      {int limit = 5}) async {
    try {
      return await apiService.searchExercises(query, limit: limit);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> saveLogs(SaveLogRequest request) async {
    try {
      await apiService.saveLogs(request.toJson());
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  @override
  Future<MealScanResult> scanMeal(MealScanRequest request) async {
    try {
      return await LogApiService.scanMeal(request);   // static, like voice
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  @override
  Future<MealsSummaryResult> getMealsSummary({String? date}) async {
    try {
      return await apiService.getMealsSummary(date: date);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  @override
  Future<List<MealLogHistory>> getMealLogs({String? date}) async {
    try {
      return await apiService.getMealLogs(date: date);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<WorkoutLogHistory>> getWorkoutLogs({String? date}) async {
    try {
      return await apiService.getWorkoutLogs(date: date);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<WeightLogHistory>> getWeightLogs({String? date}) async {
    try {
      return await apiService.getWeightLogs(date: date);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<SleepLogHistory>> getSleepLogs({String? date}) async {
    try {
      return await apiService.getSleepLogs(date: date);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<HydrationLogHistory>> getHydrationLogs({String? date}) async {
    try {
      return await apiService.getHydrationLogs(date: date);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteLog(String category, int logId) async {
    try {
      await apiService.deleteLog(category, logId);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
