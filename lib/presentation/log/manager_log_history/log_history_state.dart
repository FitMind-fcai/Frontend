part of 'log_history_bloc.dart';

abstract class LogHistoryState {
  const LogHistoryState();
}

class LogHistoryInitial extends LogHistoryState {}

class LogHistoryLoading extends LogHistoryState {}

class MealLogsLoaded extends LogHistoryState {
  final List<MealLogHistory> logs;
  const MealLogsLoaded(this.logs);
}

class WorkoutLogsLoaded extends LogHistoryState {
  final List<WorkoutLogHistory> logs;
  const WorkoutLogsLoaded(this.logs);
}

class WeightLogsLoaded extends LogHistoryState {
  final List<WeightLogHistory> logs;
  const WeightLogsLoaded(this.logs);
}

class SleepLogsLoaded extends LogHistoryState {
  final List<SleepLogHistory> logs;
  const SleepLogsLoaded(this.logs);
}

class HydrationLogsLoaded extends LogHistoryState {
  final List<HydrationLogHistory> logs;
  const HydrationLogsLoaded(this.logs);
}

class LogHistoryError extends LogHistoryState {
  final String message;
  const LogHistoryError(this.message);
}

class LogDeleteSuccess extends LogHistoryState {}