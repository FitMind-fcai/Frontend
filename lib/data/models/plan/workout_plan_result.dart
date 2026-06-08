class WorkoutPlanResult {
  final int? id; // 👈 Added ID field
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
    this.id, // 👈 Added to constructor
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
    final draft = json.containsKey('draft_plan') && json['draft_plan'] != null
        ? json['draft_plan'] as Map<String, dynamic>
        : json; // 👈 flat response fallback

    return WorkoutPlanResult(
      // Extracts ID from either root json or from nested draft map safely
      id: (json['id'] ?? draft['id'] ?? json['plan_id'] ?? draft['plan_id'] as num?)?.toInt(),
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
      updatePlanId: (json['update_plan_id'] as num?) == 0
          ? null
          : (json['update_plan_id'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // 👈 Serialize ID if it exists
      'plan_name': planName,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'frequency': frequency,
      'difficulty_level': difficultyLevel,
      'estimated_duration_per_session': estimatedDurationPerSession,
      'workout_days': workoutDays.map((d) => d.toJson()).toList(),
    };
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
      focus: json['focus_area']?? '',
      exercises: (json['exercises'] as List<dynamic>? ?? [])
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'day_number': dayNumber,
      'day_name': dayName,
      'focus_area': focus,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
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
    final central = json['central_exercise'] as Map<String, dynamic>?;

    return Exercise(
      name: central?['name'] ?? json['exercise_name'] ?? json['name'] ?? '',
      description: central?['instructions'] ?? json['description'],
      sets: (json['sets'] as num?)?.toInt(),
      reps: (json['reps'] as num?)?.toInt(),
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
      restSeconds: (json['rest_seconds'] as num?)?.toInt(),
      muscleGroup: central?['primary_muscle_group'] ?? json['muscle_group'],
      equipment: central?['equipment_required'] ?? json['equipment'],
      difficulty: central?['difficulty_level'] ?? json['difficulty'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'exercise_name': name,  // 👈 was 'name'
      'description': description,
      'sets': sets,
      'reps': reps,
      'duration_seconds': durationSeconds,
      'rest_seconds': restSeconds,
      'muscle_group': muscleGroup,
      'equipment': equipment,
      'difficulty': difficulty,
    };
  }
}