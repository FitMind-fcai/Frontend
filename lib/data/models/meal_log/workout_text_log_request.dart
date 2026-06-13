class WorkoutTextLogRequest {
  final int centralExerciseId;
  final int? workoutDayExerciseId;
  final String logDate;
  final int setsCompleted;
  final int repsCompleted;
  final double? weightUsed;
  final int? durationSeconds;
  final String? notes;

  WorkoutTextLogRequest({
    required this.centralExerciseId,
    this.workoutDayExerciseId,
    required this.logDate,
    required this.setsCompleted,
    required this.repsCompleted,
    this.weightUsed,
    this.durationSeconds,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'central_exercise_id': centralExerciseId,
      if (workoutDayExerciseId != null)
        'workout_day_exercise_id': workoutDayExerciseId,
      'log_date': logDate,
      'sets_completed': setsCompleted,
      'reps_completed': repsCompleted,
      if (weightUsed != null) 'weight_used': weightUsed,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}