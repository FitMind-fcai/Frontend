class WorkoutExercise {
  final int exerciseId;
  final String name;
  final String? muscleGroup;
  final int sets;
  final int reps;
  final double? weightKg;
  final int? durationSeconds;
  final bool alreadyLogged;

  const WorkoutExercise({
    required this.exerciseId,
    required this.name,
    this.muscleGroup,
    required this.sets,
    required this.reps,
    this.weightKg,
    this.durationSeconds,
    required this.alreadyLogged,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    try {
      return WorkoutExercise(
        exerciseId: json['exercise_id'] as int? ?? 0,
        name: json['exercise_name'] as String? ?? '',
        muscleGroup: json['muscle_group'] as String?,
        sets: json['sets'] as int? ?? 0,
        reps: json['reps'] as int? ?? 0,
        weightKg: json['weight_kg'] != null
            ? (json['weight_kg'] as num).toDouble()
            : null,
        durationSeconds: json['duration_seconds'] as int?,
        alreadyLogged: json['already_logged'] as bool? ?? false,
      );
    } catch (e) {
      print('WorkoutExercise.fromJson failed: $e');
      print('Offending json: $json');
      rethrow;
    }
  }
}

class WorkoutRecommendationResponse {
  final bool hasPlan;
  final String planName;
  final String workoutDayName;
  final String focusArea;
  final int estimatedDurationMinutes;
  final List<WorkoutExercise> exercises;
  final int sessionsLoggedToday;
  final String message;

  const WorkoutRecommendationResponse({
    required this.hasPlan,
    required this.planName,
    required this.workoutDayName,
    required this.focusArea,
    required this.estimatedDurationMinutes,
    required this.exercises,
    required this.sessionsLoggedToday,
    required this.message,
  });

  factory WorkoutRecommendationResponse.fromJson(Map<String, dynamic> json) =>
      WorkoutRecommendationResponse(
        hasPlan: json['has_plan'] as bool? ?? false,
        planName: json['plan_name'] as String? ?? '',
        workoutDayName: json['workout_day_name'] as String? ?? '',
        focusArea: json['focus_area'] as String? ?? '',
        estimatedDurationMinutes:
        json['estimated_duration_minutes'] as int? ?? 0,
        exercises: (json['exercises'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map((e) => WorkoutExercise.fromJson(e))
            .toList(),
        sessionsLoggedToday: json['sessions_logged_today'] as int? ?? 0,
        message: json['message'] as String? ?? '',
      );
}