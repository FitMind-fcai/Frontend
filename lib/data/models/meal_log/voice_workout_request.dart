// lib/data/models/voice_log/voice_workout_log_request.dart

class ExerciseOverride {
  final int exerciseIndex;
  final int centralExerciseId;

  ExerciseOverride({
    required this.exerciseIndex,
    required this.centralExerciseId,
  });

  Map<String, dynamic> toJson() => {
    'exercise_index': exerciseIndex,
    'central_exercise_id': centralExerciseId,
  };
}

class VoiceWorkoutLogRequest {
  final String audioBase64;
  final String audioFormat;
  final String logDate;
  final String language;
  final List<ExerciseOverride> exerciseOverrides;

  VoiceWorkoutLogRequest({
    required this.audioBase64,
    required this.audioFormat,
    required this.logDate,
    this.language = 'en',
    this.exerciseOverrides = const [],
  });

  Map<String, dynamic> toJson() => {
    'audio_base64': audioBase64,
    'audio_format': audioFormat,
    'log_date': logDate,
    'language': language,
    'exercise_overrides': exerciseOverrides.map((e) => e.toJson()).toList(),
  };
}
class VoiceWorkoutScanRequest {
  final String audioBase64;
  final String audioFormat;
  final String language;

  VoiceWorkoutScanRequest({
    required this.audioBase64,
    required this.audioFormat,
    this.language = 'en',
  });

  Map<String, dynamic> toJson() => {
    'audio_base64': audioBase64,
    'audio_format': audioFormat,
    'language': language,
  };
}