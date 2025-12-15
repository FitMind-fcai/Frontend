class WorkoutPreferences {
  final int workoutDaysPerWeek;
  final WorkoutLocation workoutLocation;
  final EquipmentAvailability equipmentAvailability;
  final WorkoutFocus workoutFocus;
  final WorkoutDifficulty workoutDifficulty;
  final int sessionDurationMinutes;
  final List<String>? focusAreas;

  WorkoutPreferences({
    required this.workoutDaysPerWeek,
    required this.workoutLocation,
    required this.equipmentAvailability,
    required this.workoutFocus,
    required this.workoutDifficulty,
    required this.sessionDurationMinutes,
    this.focusAreas,
  });

  Map<String, dynamic> toJson() {
    return {
      'workout_days_per_week': workoutDaysPerWeek,
      'workout_location': workoutLocation.value,
      'equipment_availability': equipmentAvailability.value,
      'workout_focus': workoutFocus.value,
      'workout_difficulty': workoutDifficulty.value,
      'session_duration_minutes': sessionDurationMinutes,
      'focus_areas': focusAreas,
    };
  }

  factory WorkoutPreferences.fromJson(Map<String, dynamic> json) {
    return WorkoutPreferences(
      workoutDaysPerWeek: json['workout_days_per_week'],
      workoutLocation: WorkoutLocation.fromString(json['workout_location']),
      equipmentAvailability:
          EquipmentAvailability.fromString(json['equipment_availability']),
      workoutFocus: WorkoutFocus.fromString(json['workout_focus']),
      workoutDifficulty:
          WorkoutDifficulty.fromString(json['workout_difficulty']),
      sessionDurationMinutes: json['session_duration_minutes'],
      focusAreas: json['focus_areas'] != null
          ? List<String>.from(json['focus_areas'])
          : null,
    );
  }
}

enum WorkoutLocation {
  gym('Gym'),
  home('Home'),
  outdoor('Outdoor'),
  hybrid('Hybrid');

  final String value;

  const WorkoutLocation(this.value);

  static WorkoutLocation fromString(String value) {
    return WorkoutLocation.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WorkoutLocation.gym,
    );
  }
}

enum EquipmentAvailability {
  fullGymEquipment('Full Gym Equipment'),
  basicEquipment('Basic Equipment'),
  noEquipment('No Equipment');

  final String value;

  const EquipmentAvailability(this.value);

  static EquipmentAvailability fromString(String value) {
    return EquipmentAvailability.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EquipmentAvailability.basicEquipment,
    );
  }
}

enum WorkoutFocus {
  strengthTraining('Strength Training'),
  cardiovascular('Cardiovascular'),
  flexibility('Flexibility'),
  hybrid('Hybrid'),
  sportSpecific('Sport Specific');

  final String value;

  const WorkoutFocus(this.value);

  static WorkoutFocus fromString(String value) {
    return WorkoutFocus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WorkoutFocus.hybrid,
    );
  }
}

enum WorkoutDifficulty {
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced');

  final String value;

  const WorkoutDifficulty(this.value);

  static WorkoutDifficulty fromString(String value) {
    return WorkoutDifficulty.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WorkoutDifficulty.beginner,
    );
  }
}
