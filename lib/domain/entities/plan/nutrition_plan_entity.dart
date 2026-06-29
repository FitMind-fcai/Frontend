// domain/entities/plan/nutrition_preferences_entity.dart
import '../../../data/models/plan/nutrition_plan_model.dart';

class NutritionPreferencesEntity {
  final CaloriePreference caloriePreference;
  final int? customCalorieTarget;
  final int mealsPerDay;
  final MealComplexity mealComplexity;
  final CuisinePreference cuisinePreference;
  final List<String>? excludeIngredients;

  NutritionPreferencesEntity({
    required this.caloriePreference,
    this.customCalorieTarget,
    required this.mealsPerDay,
    required this.mealComplexity,
    required this.cuisinePreference,
    this.excludeIngredients,
  });
}