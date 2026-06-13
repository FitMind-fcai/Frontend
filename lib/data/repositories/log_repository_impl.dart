import '../../domain/repositories/log_repository.dart';
import '../data_sources/remote/log_remote_data_source.dart';
import '../models/meal_log/excersise_search_result.dart';
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
      String filePath, String audioFormat) =>
      remote.scanMealVoice(filePath, audioFormat);

  @override
  Future<VoiceWorkoutScanResult> scanWorkoutVoice(
      String filePath, String audioFormat) =>
      remote.scanWorkoutVoice(filePath, audioFormat);

  @override
  Future<List<FoodSearchResult>> searchFoods(String query, {int limit = 5}) =>
      remote.searchFoods(query, limit: limit);

  @override
  Future<List<ExerciseSearchResult>> searchExercises(String query,
      {int limit = 5}) =>
      remote.searchExercises(query, limit: limit);

  @override
  Future<void> saveLogs(SaveLogRequest request) => remote.saveLogs(request);
}
