import 'package:bloc/bloc.dart';


import '../../../data/models/meal_log/meal_log_history/hydration_log_entry.dart';
import '../../../data/models/meal_log/meal_log_history/meal_log_entry.dart';
import '../../../data/models/meal_log/meal_log_history/sleep_log_entry.dart';
import '../../../data/models/meal_log/meal_log_history/weight_log_entry.dart';
import '../../../data/models/meal_log/meal_log_history/workout_log_entry.dart';
import '../../../domain/use_cases/log_use_cases.dart';

part 'log_history_event.dart';
part 'log_history_state.dart';

class LogHistoryBloc extends Bloc<LogHistoryEvent, LogHistoryState> {
  final GetMealLogsUseCase getMealLogs;
  final GetWorkoutLogsUseCase getWorkoutLogs;
  final GetWeightLogsUseCase getWeightLogs;
  final GetSleepLogsUseCase getSleepLogs;
  final GetHydrationLogsUseCase getHydrationLogs;
  final DeleteLogUseCase deleteLog;

  LogHistoryBloc({
    required this.getMealLogs,
    required this.getWorkoutLogs,
    required this.getWeightLogs,
    required this.getSleepLogs,
    required this.getHydrationLogs,
    required this.deleteLog,
  }) : super(LogHistoryInitial()) {
    on<LoadMealLogsEvent>(_onLoadMeals);
    on<LoadWorkoutLogsEvent>(_onLoadWorkouts);
    on<LoadWeightLogsEvent>(_onLoadWeight);
    on<LoadSleepLogsEvent>(_onLoadSleep);
    on<LoadHydrationLogsEvent>(_onLoadHydration);
    on<DeleteLogEntryEvent>(_onDelete);
  }

  Future<void> _onLoadMeals(
      LoadMealLogsEvent e, Emitter<LogHistoryState> emit) async {
    emit(LogHistoryLoading());
    try {
      final logs = await getMealLogs(date: e.date);
      emit(MealLogsLoaded(logs));
    } catch (err) {
      emit(LogHistoryError(err.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLoadWorkouts(
      LoadWorkoutLogsEvent e, Emitter<LogHistoryState> emit) async {
    emit(LogHistoryLoading());
    try {
      final logs = await getWorkoutLogs(date: e.date);
      emit(WorkoutLogsLoaded(logs));
    } catch (err) {
      emit(LogHistoryError(err.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLoadWeight(
      LoadWeightLogsEvent e, Emitter<LogHistoryState> emit) async {
    emit(LogHistoryLoading());
    try {
      final logs = await getWeightLogs(date: e.date);
      emit(WeightLogsLoaded(logs));
    } catch (err) {
      emit(LogHistoryError(err.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLoadSleep(
      LoadSleepLogsEvent e, Emitter<LogHistoryState> emit) async {
    emit(LogHistoryLoading());
    try {
      final logs = await getSleepLogs(date: e.date);
      emit(SleepLogsLoaded(logs));
    } catch (err) {
      emit(LogHistoryError(err.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLoadHydration(
      LoadHydrationLogsEvent e, Emitter<LogHistoryState> emit) async {
    emit(LogHistoryLoading());
    try {
      final logs = await getHydrationLogs(date: e.date);
      emit(HydrationLogsLoaded(logs));
    } catch (err) {
      emit(LogHistoryError(err.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onDelete(
      DeleteLogEntryEvent e, Emitter<LogHistoryState> emit) async {
    try {
      await deleteLog(e.category, e.logId);
      emit(LogDeleteSuccess());
    } catch (err) {
      emit(LogHistoryError(err.toString().replaceFirst('Exception: ', '')));
    }
  }
}