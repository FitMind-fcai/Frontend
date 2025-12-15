import 'package:fitmind/data/models/plan/workout_plan_model.dart';

class WorkoutPlanGenerationRequest {
  final int durationWeeks;
  final WorkoutPreferences workoutPreferences;

  WorkoutPlanGenerationRequest({
    required this.durationWeeks,
    required this.workoutPreferences,
  });

  Map<String, dynamic> toJson() {
    return {
      'duration_weeks': durationWeeks,
      'workout_preferences': workoutPreferences.toJson(),
    };
  }

  factory WorkoutPlanGenerationRequest.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanGenerationRequest(
      durationWeeks: json['duration_weeks'],
      workoutPreferences:
      WorkoutPreferences.fromJson(json['workout_preferences']),
    );
  }
}