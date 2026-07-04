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
import '../repositories/log_repository.dart';

class ScanMealUseCase {
  final LogRepository repository;
  ScanMealUseCase(this.repository);
  Future<MealScanResult> call(MealScanRequest request) =>
      repository.scanMeal(request);
}


class ScanMealVoiceUseCase {
  final LogRepository repository;
  ScanMealVoiceUseCase(this.repository);
  Future<VoiceMealScanResult> call(String filePath, String audioFormat,String language) =>
      repository.scanMealVoice(filePath, audioFormat,language);
}

class ScanWorkoutVoiceUseCase {
  final LogRepository repository;
  ScanWorkoutVoiceUseCase(this.repository);
  Future<VoiceWorkoutScanResult> call(String filePath, String audioFormat,String language) =>
      repository.scanWorkoutVoice(filePath, audioFormat,language);
}
class SearchFoodsUseCase {
  final LogRepository repository;
  SearchFoodsUseCase(this.repository);
  Future<List<FoodSearchResult>> call(String query, {int limit = 10}) =>
      repository.searchFoods(query, limit: limit);
}

class SearchExercisesUseCase {
  final LogRepository repository;
  SearchExercisesUseCase(this.repository);
  Future<List<ExerciseSearchResult>> call(String query, {int limit = 10}) =>
      repository.searchExercises(query, limit: limit);
}

class SaveLogsUseCase {
  final LogRepository repository;
  SaveLogsUseCase(this.repository);
  Future<void> call(SaveLogRequest request) => repository.saveLogs(request);
}
class GetMealsSummaryUseCase {
  final LogRepository repository;
  GetMealsSummaryUseCase(this.repository);
  Future<MealsSummaryResult> call({String? date}) =>
      repository.getMealsSummary(date: date);
}
class GetMealLogsUseCase {
  final LogRepository repository;
  GetMealLogsUseCase(this.repository);
  Future<List<MealLogHistory>> call({String? date}) =>
      repository.getMealLogs(date: date);
}

class GetWorkoutLogsUseCase {
  final LogRepository repository;
  GetWorkoutLogsUseCase(this.repository);
  Future<List<WorkoutLogHistory>> call({String? date}) =>
      repository.getWorkoutLogs(date: date);
}

class GetWeightLogsUseCase {
  final LogRepository repository;
  GetWeightLogsUseCase(this.repository);
  Future<List<WeightLogHistory>> call({String? date}) =>
      repository.getWeightLogs(date: date);
}

class GetSleepLogsUseCase {
  final LogRepository repository;
  GetSleepLogsUseCase(this.repository);
  Future<List<SleepLogHistory>> call({String? date}) =>
      repository.getSleepLogs(date: date);
}

class GetHydrationLogsUseCase {
  final LogRepository repository;
  GetHydrationLogsUseCase(this.repository);
  Future<List<HydrationLogHistory>> call({String? date}) =>
      repository.getHydrationLogs(date: date);
}

class DeleteLogUseCase {
  final LogRepository repository;
  DeleteLogUseCase(this.repository);
  Future<void> call(String category, int logId) =>
      repository.deleteLog(category, logId);
}
