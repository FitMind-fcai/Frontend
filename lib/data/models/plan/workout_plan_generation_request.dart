import 'package:fitmind/data/models/plan/workout_plan_model.dart';

class WorkoutPlanGenerationRequest {
  final int durationWeeks;
  final WorkoutPreferences workoutPreferences;
  final String? lang;


  WorkoutPlanGenerationRequest({
    required this.durationWeeks,
    required this.workoutPreferences,
    this.lang,
  });

  Map<String, dynamic> toJson() {
    return {
      'duration_weeks': durationWeeks,
      'workout_preferences': workoutPreferences.toJson(),
      'lang': lang,
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