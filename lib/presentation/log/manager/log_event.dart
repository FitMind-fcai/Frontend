part of 'log_bloc.dart';

@immutable
sealed class LogEvent {}

/// Scan only — returns result for preview, no log saved.
final class ScanMealLogEvent extends LogEvent {
  final MealScanRequest request;
  ScanMealLogEvent(this.request);
}

/// Scan + immediately save as MealLog.
final class ScanAndSaveMealLogEvent extends LogEvent {
  final MealScanRequest request;
  ScanAndSaveMealLogEvent(this.request);
}

/// Transcribe voice clip, return parsed meal for preview.
class ScanMealVoiceEvent extends LogEvent {
  final String filePath;
  final String audioFormat;
  ScanMealVoiceEvent(this.filePath, this.audioFormat);
}

class ScanWorkoutVoiceEvent extends LogEvent {
  final String filePath;
  final String audioFormat;
  ScanWorkoutVoiceEvent(this.filePath, this.audioFormat);
}
final class SearchFoodsEvent extends LogEvent {
  final String query;
  SearchFoodsEvent(this.query);
}

final class SearchExercisesEvent extends LogEvent {
  final String query;
  SearchExercisesEvent(this.query);
}

final class SaveLogsEvent extends LogEvent {
  final SaveLogRequest request;
  SaveLogsEvent(this.request);
}
