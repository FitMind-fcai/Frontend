// ─── domain/repositories/log_repository.dart ────────────────────────────────

import '../../data/models/meal_log/excersise_search_result.dart';
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

  Future<VoiceMealScanResult> scanMealVoice(String filePath, String audioFormat);
  Future<VoiceWorkoutScanResult> scanWorkoutVoice(String filePath, String audioFormat);


  Future<List<FoodSearchResult>> searchFoods(String query, {int limit});
  Future<List<ExerciseSearchResult>> searchExercises(String query, {int limit});
  Future<void> saveLogs(SaveLogRequest request);
}