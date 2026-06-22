import 'nutrition_plan_model.dart';

class NutritionPlanGenerationRequest {
  final int durationWeeks;
  final NutritionPreferences nutritionPreferences;
  final String? lang;

  NutritionPlanGenerationRequest({
    required this.durationWeeks,
    required this.nutritionPreferences,
     this.lang,

  });

  Map<String, dynamic> toJson() {
    return {
      'duration_weeks': durationWeeks,
      'nutrition_preferences': nutritionPreferences.toJson(),
      'lang': lang,

    };
  }

  factory NutritionPlanGenerationRequest.fromJson(Map<String, dynamic> json) {
    return NutritionPlanGenerationRequest(
      durationWeeks: json['duration_weeks'],
      nutritionPreferences: NutritionPreferences.fromJson(json['nutrition_preferences']),
    );
  }
}
