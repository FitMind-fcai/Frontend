import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/meal_log/excersise_search_result.dart';
import '../../../data/models/meal_log/meal_scan_request.dart';
import '../../../data/models/meal_log/meal_scan_result.dart';
import '../../../data/models/meal_log/meal_text_log_request.dart';
import '../../../data/models/meal_log/meal_text_result.dart';
import '../../../data/models/meal_log/voice_meal_log_request.dart';
import '../../../data/models/meal_log/voice_meal_scan_result.dart';
import '../../../data/models/meal_log/voice_workout_request.dart';
import '../../../data/models/meal_log/voice_workout_scan_result.dart';
import '../../../data/models/meal_log/workout_text_log_request.dart';
import '../../../data/models/save_log_request.dart';
import '../../../domain/use_cases/log_use_cases.dart';

part 'log_event.dart';

part 'log_state.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  final ScanMealUseCase scanMealUseCase;
  final ScanMealVoiceUseCase scanMealVoiceUseCase;
  final ScanWorkoutVoiceUseCase scanWorkoutVoiceUseCase;
  final SearchFoodsUseCase searchFoodsUseCase;
  final SearchExercisesUseCase searchExercisesUseCase;
  final SaveLogsUseCase saveLogsUseCase;

  LogBloc({
    required this.scanMealUseCase,
    required this.scanMealVoiceUseCase,
    required this.scanWorkoutVoiceUseCase,
    required this.searchFoodsUseCase,
    required this.searchExercisesUseCase,
    required this.saveLogsUseCase,
  }) : super(LogInitial()) {
    on<ScanMealLogEvent>(_onScanMeal);
    on<ScanMealVoiceEvent>(_onScanMealVoice);
    on<ScanWorkoutVoiceEvent>(_onScanWorkoutVoice);
    on<SearchFoodsEvent>(_onSearchFoods);
    on<SearchExercisesEvent>(_onSearchExercises);
    on<SaveLogsEvent>(_onSaveLogs);
  }

  Future<void> _onScanMeal(
    ScanMealLogEvent event,
    Emitter<LogState> emit,
  ) async {
    emit(LogLoading());
    try {
      final result = await scanMealUseCase(event.request);
      emit(MealScanSuccess(result));
    } catch (e) {
      emit(LogError(e.toString().replaceFirst('Exception: ', '')));
    }
  }


  Future<void> _onScanMealVoice(
      ScanMealVoiceEvent e, Emitter<LogState> emit) async {
    emit(LogLoading());
    try {
      final result = await scanMealVoiceUseCase(e.filePath, e.audioFormat);
      emit(VoiceMealScanSuccess(result, e.filePath, e.audioFormat));
    } catch (err) {
      emit(LogError(err.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onScanWorkoutVoice(
      ScanWorkoutVoiceEvent e, Emitter<LogState> emit) async {
    emit(LogLoading());
    try {
      final result = await scanWorkoutVoiceUseCase(e.filePath, e.audioFormat);
      emit(VoiceWorkoutScanSuccess(result, e.filePath, e.audioFormat));
    } catch (err) {
      emit(LogError(err.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onSearchFoods(
      SearchFoodsEvent event, Emitter<LogState> emit) async {
    emit(LogLoading());
    try {
      final results = await searchFoodsUseCase(event.query);
      emit(FoodSearchSuccess(results));
    } catch (e) {
      emit(LogError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onSearchExercises(
      SearchExercisesEvent event, Emitter<LogState> emit) async {
    emit(LogLoading());
    try {
      final results = await searchExercisesUseCase(event.query);
      emit(ExerciseSearchSuccess(results));
    } catch (e) {
      emit(LogError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onSaveLogs(SaveLogsEvent event, Emitter<LogState> emit) async {
    emit(LogLoading(isSaving: true));
    try {
      await saveLogsUseCase(event.request);
      emit(LogSaveSuccess());
    } catch (e) {
      emit(LogError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
