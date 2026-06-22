class WorkoutLogHistory {
  final int id;
  final String logDate;
  final int setsCompleted;
  final int repsCompleted;
  final double? weightUsed;
  final int? durationSeconds;
  final String? notes;

  const WorkoutLogHistory({
    required this.id,
    required this.logDate,
    required this.setsCompleted,
    required this.repsCompleted,
    this.weightUsed,
    this.durationSeconds,
    this.notes,
  });

  factory WorkoutLogHistory.fromJson(Map<String, dynamic> json) => WorkoutLogHistory(
    id: (json['id'] as num).toInt(),
    logDate: json['log_date'] as String,
    setsCompleted: (json['sets_completed'] as num? ?? 0).toInt(),
    repsCompleted: (json['reps_completed'] as num? ?? 0).toInt(),
    weightUsed: (json['weight_used'] as num?)?.toDouble(),
    durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
    notes: json['notes'] as String?,
  );
}