part of 'log_history_bloc.dart';

abstract class LogHistoryEvent {
  const LogHistoryEvent();
}

class LoadMealLogsEvent extends LogHistoryEvent {
  final String? date;
  const LoadMealLogsEvent({this.date});
}

class LoadWorkoutLogsEvent extends LogHistoryEvent {
  final String? date;
  const LoadWorkoutLogsEvent({this.date});
}

class LoadWeightLogsEvent extends LogHistoryEvent {
  final String? date;
  const LoadWeightLogsEvent({this.date});
}

class LoadSleepLogsEvent extends LogHistoryEvent {
  final String? date;
  const LoadSleepLogsEvent({this.date});
}

class LoadHydrationLogsEvent extends LogHistoryEvent {
  final String? date;
  const LoadHydrationLogsEvent({this.date});
}

class DeleteLogEntryEvent extends LogHistoryEvent {
  final String category;
  final int logId;
  const DeleteLogEntryEvent(this.category, this.logId);
}