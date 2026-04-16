class WorkoutPlanResult {
  final String planName;
  final String description;
  final String startDate;
  final String endDate;
  final String frequency;
  final String difficultyLevel;
  final int estimatedDurationPerSession;
  final List<WorkoutDay> workoutDays;
  final Map<String, dynamic> generatedFromPreferences;
  final int? updatePlanId;

  WorkoutPlanResult({
    required this.planName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.frequency,
    required this.difficultyLevel,
    required this.estimatedDurationPerSession,
    required this.workoutDays,
    required this.generatedFromPreferences,
    this.updatePlanId,
  });

  factory WorkoutPlanResult.fromJson(Map<String, dynamic> json) {
    final draft = json['draft_plan'] as Map<String, dynamic>;
    return WorkoutPlanResult(
      planName: draft['plan_name'] ?? '',
      description: draft['description'] ?? '',
      startDate: draft['start_date'] ?? '',
      endDate: draft['end_date'] ?? '',
      frequency: draft['frequency'] ?? '',
      difficultyLevel: draft['difficulty_level'] ?? '',
      estimatedDurationPerSession:
      (draft['estimated_duration_per_session'] ?? 0).toInt(),
      workoutDays: (draft['workout_days'] as List<dynamic>? ?? [])
          .map((d) => WorkoutDay.fromJson(d as Map<String, dynamic>))
          .toList(),
      generatedFromPreferences:
      json['generated_from_preferences'] as Map<String, dynamic>? ?? {},
      updatePlanId: json['update_plan_id'],
    );
  }
}

class WorkoutDay {
  final int dayNumber;
  final String dayName;
  final String? focus;
  final List<Exercise> exercises;

  WorkoutDay({
    required this.dayNumber,
    required this.dayName,
    this.focus,
    required this.exercises,
  });

  factory WorkoutDay.fromJson(Map<String, dynamic> json) {
    return WorkoutDay(
      dayNumber: (json['day_number'] ?? 0).toInt(),
      dayName: json['day_name'] ?? '',
      focus: json['focus'],
      exercises: (json['exercises'] as List<dynamic>? ?? [])
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Exercise {
  final String name;
  final String? description;
  final int? sets;
  final int? reps;
  final int? durationSeconds;
  final int? restSeconds;
  final String? muscleGroup;
  final String? equipment;
  final String? difficulty;

  Exercise({
    required this.name,
    this.description,
    this.sets,
    this.reps,
    this.durationSeconds,
    this.restSeconds,
    this.muscleGroup,
    this.equipment,
    this.difficulty,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? '',
      description: json['description'],
      sets: json['sets'],
      reps: json['reps'],
      durationSeconds: json['duration_seconds'],
      restSeconds: json['rest_seconds'],
      muscleGroup: json['muscle_group'],
      equipment: json['equipment'],
      difficulty: json['difficulty'],
    );
  }
}