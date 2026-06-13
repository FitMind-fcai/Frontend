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
  Future<VoiceMealScanResult> call(String filePath, String audioFormat) =>
      repository.scanMealVoice(filePath, audioFormat);
}

class ScanWorkoutVoiceUseCase {
  final LogRepository repository;
  ScanWorkoutVoiceUseCase(this.repository);
  Future<VoiceWorkoutScanResult> call(String filePath, String audioFormat) =>
      repository.scanWorkoutVoice(filePath, audioFormat);
}
class SearchFoodsUseCase {
  final LogRepository repository;
  SearchFoodsUseCase(this.repository);
  Future<List<FoodSearchResult>> call(String query, {int limit = 5}) =>
      repository.searchFoods(query, limit: limit);
}

class SearchExercisesUseCase {
  final LogRepository repository;
  SearchExercisesUseCase(this.repository);
  Future<List<ExerciseSearchResult>> call(String query, {int limit = 5}) =>
      repository.searchExercises(query, limit: limit);
}

class SaveLogsUseCase {
  final LogRepository repository;
  SaveLogsUseCase(this.repository);
  Future<void> call(SaveLogRequest request) => repository.saveLogs(request);
}

