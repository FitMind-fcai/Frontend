part of 'log_bloc.dart';

@immutable
sealed class LogState {}

final class LogInitial extends LogState {}

/// Shown while either scan or scan+log is in-flight.
final class LogLoading extends LogState {
  /// true when we are saving (scan+log), false for scan-only.
  final bool isSaving;
  LogLoading({this.isSaving = false});
}

/// Scan-only completed — result ready for preview.
final class MealScanSuccess extends LogState {
  final MealScanResult result;
  MealScanSuccess(this.result);
}

/// Scan+log completed — meal has been saved.
final class MealScanAndLogSuccess extends LogState {
  final MealScanResult result;
  MealScanAndLogSuccess(this.result);
}

final class LogError extends LogState {
  final String message;
  LogError(this.message);
}

/// Voice meal scan completed — result + original audio ready for the confirm page.
class VoiceMealScanSuccess extends LogState {
  final VoiceMealScanResult result;
  final String filePath;
  final String audioFormat;
  VoiceMealScanSuccess(this.result, this.filePath, this.audioFormat);
}

class VoiceWorkoutScanSuccess extends LogState {
  final VoiceWorkoutScanResult result;
  final String filePath;
  final String audioFormat;
  VoiceWorkoutScanSuccess(this.result, this.filePath, this.audioFormat);
}
final class FoodSearchSuccess extends LogState {
  final List<FoodSearchResult> results;
  FoodSearchSuccess(this.results);
}

final class ExerciseSearchSuccess extends LogState {
  final List<ExerciseSearchResult> results;
  ExerciseSearchSuccess(this.results);
}

final class LogSaveSuccess extends LogState {}

