// lib/data/models/recommendations/next_meal_response.dart

class NextMealIngredient {
  final String foodName;
  final double amountG;

  const NextMealIngredient({
    required this.foodName,
    required this.amountG,
  });

  factory NextMealIngredient.fromJson(Map<String, dynamic> json) =>
      NextMealIngredient(
        foodName: json['food_name'] as String,
        amountG: (json['amount_g'] as num).toDouble(),
      );
}

class RecommendedMeal {
  final int mealId;
  final String mealType;
  final String mealName;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;
  final double fiberG;
  final String instructions;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final List<NextMealIngredient> ingredients;

  const RecommendedMeal({
    required this.mealId,
    required this.mealType,
    required this.mealName,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    required this.fiberG,
    required this.instructions,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.ingredients,
  });

  factory RecommendedMeal.fromJson(Map<String, dynamic> json) =>
      RecommendedMeal(
        mealId: json['meal_id'] as int,
        mealType: json['meal_type'] as String,
        mealName: json['meal_name'] as String,
        calories: (json['calories'] as num).toDouble(),
        proteinG: (json['protein_g'] as num).toDouble(),
        carbsG: (json['carbs_g'] as num).toDouble(),
        fatsG: (json['fats_g'] as num).toDouble(),
        fiberG: (json['fiber_g'] as num).toDouble(),
        instructions: json['instructions'] as String,
        prepTimeMinutes: json['prep_time_minutes'] as int,
        cookTimeMinutes: json['cook_time_minutes'] as int,
        ingredients: (json['ingredients'] as List<dynamic>)
            .map((e) => NextMealIngredient.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class DailyTargets {
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;

  const DailyTargets({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
  });

  factory DailyTargets.fromJson(Map<String, dynamic> json) => DailyTargets(
    calories: (json['calories'] as num).toDouble(),
    proteinG: (json['protein_g'] as num).toDouble(),
    carbsG: (json['carbs_g'] as num).toDouble(),
    fatsG: (json['fats_g'] as num).toDouble(),
  );
}

class NextMealResponse {
  final bool hasPlan;
  final String planName;
  final String todayDayName;
  final String queryTime;
  final DailyTargets dailyTargets;
  final RecommendedMeal? recommendedMeal;
  final String message;

  const NextMealResponse({
    required this.hasPlan,
    required this.planName,
    required this.todayDayName,
    required this.queryTime,
    required this.dailyTargets,
    this.recommendedMeal,
    required this.message,
  });

  factory NextMealResponse.fromJson(Map<String, dynamic> json) =>
      NextMealResponse(
        hasPlan: json['has_plan'] as bool,
        planName: json['plan_name'] as String? ?? '',
        todayDayName: json['today_day_name'] as String? ?? '',
        queryTime: json['query_time'] as String? ?? '',
        dailyTargets: DailyTargets.fromJson(
            json['daily_targets'] as Map<String, dynamic>),
        recommendedMeal: json['recommended_meal'] != null
            ? RecommendedMeal.fromJson(
            json['recommended_meal'] as Map<String, dynamic>)
            : null,
        message: json['message'] as String? ?? '',
      );
}