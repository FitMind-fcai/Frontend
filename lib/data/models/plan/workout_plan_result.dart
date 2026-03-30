class WorkoutPlanResult {
  final String planName;
  final String description;
  final String startDate;
  final String endDate;
  final String frequency;
  final String difficultyLevel;
  final int estimatedDurationPerSession;

  WorkoutPlanResult({
    required this.planName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.frequency,
    required this.difficultyLevel,
    required this.estimatedDurationPerSession,
  });

  factory WorkoutPlanResult.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanResult(
      planName: json['plan_name'] ?? '',
      description: json['description'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      frequency: json['frequency'] ?? '',
      difficultyLevel: json['difficulty_level'] ?? '',
      estimatedDurationPerSession:
      (json['estimated_duration_per_session'] ?? 0).toInt(),
    );
  }
}