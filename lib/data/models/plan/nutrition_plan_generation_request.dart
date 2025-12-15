import 'nutrition_plan_model.dart';

class NutritionPlanGenerationRequest {
  final int durationWeeks;
  final NutritionPreferences nutritionPreferences;

  NutritionPlanGenerationRequest({
    required this.durationWeeks,
    required this.nutritionPreferences,
  });

  Map<String, dynamic> toJson() {
    return {
      'duration_weeks': durationWeeks,
      'nutrition_preferences': nutritionPreferences.toJson(),
    };
  }

  factory NutritionPlanGenerationRequest.fromJson(Map<String, dynamic> json) {
    return NutritionPlanGenerationRequest(
      durationWeeks: json['duration_weeks'],
      nutritionPreferences: NutritionPreferences.fromJson(json['nutrition_preferences']),
    );
  }
}
