
class NutritionPreferences {
  final CaloriePreference caloriePreference;
  final int? customCalorieTarget;
  final int mealsPerDay;
  final MealComplexity mealComplexity;
  final CuisinePreference cuisinePreference;
  final List<String>? excludeIngredients;

  NutritionPreferences({
    required this.caloriePreference,
    this.customCalorieTarget,
    required this.mealsPerDay,
    required this.mealComplexity,
    required this.cuisinePreference,
    this.excludeIngredients,
  });

  Map<String, dynamic> toJson() {
    return {
      'calorie_preference': caloriePreference.value,
      'custom_calorie_target': customCalorieTarget,
      'meals_per_day': mealsPerDay,
      'meal_complexity': mealComplexity.value,
      'cuisine_preference': cuisinePreference.value,
      'exclude_ingredients': excludeIngredients,
    };
  }

  factory NutritionPreferences.fromJson(Map<String, dynamic> json) {
    return NutritionPreferences(
      caloriePreference:
      CaloriePreference.fromString(json['calorie_preference']),
      customCalorieTarget: json['custom_calorie_target'],
      mealsPerDay: json['meals_per_day'],
      mealComplexity: MealComplexity.fromString(json['meal_complexity']),
      cuisinePreference: CuisinePreference.fromString(json['cuisine_preference']),
      excludeIngredients: json['exclude_ingredients'] != null
          ? List<String>.from(json['exclude_ingredients'])
          : null,
    );
  }
}

enum CaloriePreference {
  auto('Auto'),
  custom('Custom');

  final String value;
  const CaloriePreference(this.value);

  static CaloriePreference fromString(String value) {
    return CaloriePreference.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CaloriePreference.auto,
    );
  }
}

enum MealComplexity {
  quick('Quick'),
  moderate('Moderate'),
  elaborate('Elaborate'),
  mixed('Mixed');

  final String value;
  const MealComplexity(this.value);

  static MealComplexity fromString(String value) {
    return MealComplexity.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MealComplexity.moderate,
    );
  }
}

enum CuisinePreference {
  mediterranean('Mediterranean'),
  asian('Asian'),
  western('Western'),
  middleEastern('Middle Eastern'),
  latinAmerican('Latin American'),
  vegetarian('Vegetarian'),
  vegan('Vegan'),
  mixed('Mixed');

  final String value;
  const CuisinePreference(this.value);

  static CuisinePreference fromString(String value) {
    return CuisinePreference.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CuisinePreference.mixed,
    );
  }
}