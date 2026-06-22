// ─── domain/repositories/log_repository.dart ────────────────────────────────

import '../../data/models/home/calorie_screen_result.dart';
import '../../data/models/meal_log/excersise_search_result.dart';
import '../../data/models/meal_log/meal_log_history/hydration_log_entry.dart';
import '../../data/models/meal_log/meal_log_history/meal_log_entry.dart';
import '../../data/models/meal_log/meal_log_history/sleep_log_entry.dart';
import '../../data/models/meal_log/meal_log_history/weight_log_entry.dart';
import '../../data/models/meal_log/meal_log_history/workout_log_entry.dart';
import '../../data/models/meal_log/meal_scan_request.dart';
import '../../data/models/meal_log/meal_scan_result.dart';
import '../../data/models/meal_log/meal_text_log_request.dart';
import '../../data/models/meal_log/meal_text_result.dart';
import '../../data/models/meal_log/voice_meal_log_request.dart';
import '../../data/models/meal_log/voice_meal_scan_result.dart';
import '../../data/models/meal_log/voice_workout_request.dart';
import '../../data/models/meal_log/voice_workout_scan_result.dart';
import '../../data/models/meal_log/workout_text_log_request.dart';
import '../../data/models/save_log_request.dart';

abstract class LogRepository {
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