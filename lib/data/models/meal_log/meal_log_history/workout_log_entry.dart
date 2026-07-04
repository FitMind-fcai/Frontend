class WorkoutLogHistory {
  final int id;
  final String logDate;
  final int setsCompleted;
  final int repsCompleted;
  final String? exerciseName;
  final double? weightUsed;
  final int? durationSeconds;
  final String? notes;
  final DateTime createdAt;

  const WorkoutLogHistory({
    required this.id,
    required this.logDate,
    this.exerciseName,
    required this.setsCompleted,
    required this.repsCompleted,
    this.weightUsed,
    this.durationSeconds,
    this.notes,
    required this.createdAt,
  });

  factory WorkoutLogHistory.fromJson(Map<String, dynamic> json) => WorkoutLogHistory(
    id: (json['id'] as num).toInt(),
    logDate: json['log_date'] as String,
    setsCompleted: (json['sets_completed'] as num? ?? 0).toInt(),
    exerciseName: json['exercise_name'] as String?,
    repsCompleted: (json['reps_completed'] as num? ?? 0).toInt(),
    weightUsed: (json['weight_used'] as num?)?.toDouble(),
    durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
    notes: json['notes'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}