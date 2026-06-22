import '../../domain/repositories/log_repository.dart';
import '../data_sources/remote/log_remote_data_source.dart';
import '../models/home/calorie_screen_result.dart';
import '../models/meal_log/excersise_search_result.dart';
import '../models/meal_log/meal_log_history/hydration_log_entry.dart';
import '../models/meal_log/meal_log_history/meal_log_entry.dart';
import '../models/meal_log/meal_log_history/sleep_log_entry.dart';
import '../models/meal_log/meal_log_history/weight_log_entry.dart';
import '../models/meal_log/meal_log_history/workout_log_entry.dart';
import '../models/meal_log/meal_scan_request.dart';
import '../models/meal_log/meal_scan_result.dart';
import '../models/meal_log/meal_text_log_request.dart';
import '../models/meal_log/meal_text_result.dart';
import '../models/meal_log/voice_meal_log_request.dart';
import '../models/meal_log/voice_meal_scan_result.dart';
import '../models/meal_log/voice_workout_request.dart';
import '../models/meal_log/voice_workout_scan_result.dart';
import '../models/meal_log/workout_text_log_request.dart';
import '../models/save_log_request.dart';

class LogRepositoryImpl implements LogRepository {
  final LogRemoteDataSource remote;

  LogRepositoryImpl(this.remote);

  @override
  Future<MealScanResult> scanMeal(MealScanRequest request) =>
      remote.scanMeal(request);


  @override
  Future<VoiceMealScanResult> scanMealVoice(
      String filePath, String audioFormat,String language) =>
      remote.scanMealVoice(filePath, audioFormat,language);

  @override
  Future<VoiceWorkoutScanResult> scanWorkoutVoice(
      String filePath, String audioFormat,String language) =>
      remote.scanWorkoutVoice(filePath, audioFormat,language);

  @override
  Future<List<FoodSearchResult>> searchFoods(String query, {int limit = 5}) =>
      remote.searchFoods(query, limit: limit);

  @override
  Future<List<ExerciseSearchResult>> searchExercises(String query,
      {int limit = 5}) =>
      remote.searchExercises(query, limit: limit);

  @override
  Future<void> saveLogs(SaveLogRequest request) => remote.saveLogs(request);

  @override
  Future<MealsSummaryResult> getMealsSummary({String? date}) =>
      remote.getMealsSummary(date: date);

  @override
  Future<List<MealLogHistory>> getMealLogs({String? date}) =>
      remote.getMealLogs(date: date);

  @override
  Future<List<WorkoutLogHistory>> getWorkoutLogs({String? date}) =>
      remote.getWorkoutLogs(date: date);

  @override
  Future<List<WeightLogHistory>> getWeightLogs({String? date}) =>
      remote.getWeightLogs(date: date);

  @override
  Future<List<SleepLogHistory>> getSleepLogs({String? date}) =>
      remote.getSleepLogs(date: date);

  @override
  Future<List<HydrationLogHistory>> getHydrationLogs({String? date}) =>
      remote.getHydrationLogs(date: date);

  @override
  Future<void> deleteLog(String category, int logId) =>
      remote.deleteLog(category, logId);
}
