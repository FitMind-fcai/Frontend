/// Single unified endpoint body for POST /v1/tracking/logs
class SaveLogRequest {
  final String category; // 'meal' | 'workout' | 'weight' | 'sleep' | 'hydration'
  final String logDate;
  final String logMethod; // 'TEXT' | 'VOICE' | 'CAMERA'
  final List<MealLogEntry>? mealEntries;
  final List<WorkoutLogEntry>? workoutEntries;
  final List<WeightLogEntry>? weightEntries;
  final List<SleepLogEntry>? sleepEntries;
  final List<HydrationLogEntry>? hydrationEntries;

  SaveLogRequest({
    required this.category,
    required this.logDate,
    this.logMethod = 'TEXT',
    this.mealEntries,
    this.workoutEntries,
    this.weightEntries,
    this.sleepEntries,
    this.hydrationEntries,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'log_date': logDate,
      'log_method': logMethod,
      if (mealEntries != null)
        'meal_entries': mealEntries!.map((e) => e.toJson()).toList(),
      if (workoutEntries != null)
        'workout_entries': workoutEntries!.map((e) => e.toJson()).toList(),
      if (weightEntries != null)
        'weight_entries': weightEntries!.map((e) => e.toJson()).toList(),
      if (sleepEntries != null)
        'sleep_entries': sleepEntries!.map((e) => e.toJson()).toList(),
      if (hydrationEntries != null)
        'hydration_entries': hydrationEntries!.map((e) => e.toJson()).toList(),
    };
  }
}

class MealLogEntry {
  final int? centralFoodId;
  final String mealType;
  final String? mealName;
  final double servings;
  final double? servingSizeGSnapshot;
  final String? servingDescriptionSnapshot;
  final double? calories;
  final double? proteinG;
  final double? carbsG;
  final double? fatsG;

  MealLogEntry({
    this.centralFoodId,
    required this.mealType,
    this.mealName,
    this.servings = 1,
    this.servingSizeGSnapshot,
    this.servingDescriptionSnapshot,
    this.calories,
    this.proteinG,
    this.carbsG,
    this.fatsG,
  });

  Map<String, dynamic> toJson() {
    return {
      if (centralFoodId != null) 'central_food_id': centralFoodId,
      'meal_type': mealType,
      if (mealName != null) 'meal_name': mealName,
      'servings': servings,
      if (servingSizeGSnapshot != null)
        'serving_size_g_snapshot': servingSizeGSnapshot,
      if (servingDescriptionSnapshot != null)
        'serving_description_snapshot': servingDescriptionSnapshot,
      if (calories != null) 'calories': calories,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatsG != null) 'fats_g': fatsG,
    };
  }
}

class WorkoutLogEntry {
  final int? centralExerciseId;
  final int? workoutDayExerciseId;
  final int setsCompleted;
  final int repsCompleted;
  final double? weightUsed;
  final int? durationSeconds;
  final String? notes;

  WorkoutLogEntry({
    this.centralExerciseId,
    this.workoutDayExerciseId,
    required this.setsCompleted,
    required this.repsCompleted,
    this.weightUsed,
    this.durationSeconds,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      if (centralExerciseId != null) 'central_exercise_id': centralExerciseId,
      if (workoutDayExerciseId != null)
        'workout_day_exercise_id': workoutDayExerciseId,
      'sets_completed': setsCompleted,
      'reps_completed': repsCompleted,
      if (weightUsed != null) 'weight_used': weightUsed,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}

class WeightLogEntry {
  final double weight;
  final String? notes;

  WeightLogEntry({required this.weight, this.notes});

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}

class SleepLogEntry {
  final double sleepHours;
  final int? sleepQuality; // 1–5
  final String? notes;

  SleepLogEntry({
    required this.sleepHours,
    this.sleepQuality,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'sleep_hours': sleepHours,
      if (sleepQuality != null) 'sleep_quality': sleepQuality,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}

class HydrationLogEntry {
  final int waterMl;
  final String? notes;

  HydrationLogEntry({
    required this.waterMl,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'water_ml': waterMl,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}