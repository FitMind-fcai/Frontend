class NutritionPlanResult {
  final String planName;
  final String description;
  final String startDate;
  final String endDate;
  final int dailyCalories;
  final int dailyProteinG;
  final int dailyCarbsG;
  final int dailyFatsG;
  final List<DayPlan> days;
  final Map<String, dynamic> generatedFromPreferences;
  final int? updatePlanId;

  NutritionPlanResult({
    required this.planName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.dailyCalories,
    required this.dailyProteinG,
    required this.dailyCarbsG,
    required this.dailyFatsG,
    required this.days,
    required this.generatedFromPreferences,
    this.updatePlanId,
  });

  factory NutritionPlanResult.fromJson(Map<String, dynamic> json) {
    final draft = json['draft_plan'] as Map<String, dynamic>;
    return NutritionPlanResult(
      planName: draft['plan_name'] ?? '',
      description: draft['description'] ?? '',
      startDate: draft['start_date'] ?? '',
      endDate: draft['end_date'] ?? '',
      dailyCalories: (draft['daily_calories'] as num? ?? 0).toInt(),
      dailyProteinG: (draft['daily_protein_g'] as num? ?? 0).toInt(),
      dailyCarbsG: (draft['daily_carbs_g'] as num? ?? 0).toInt(),
      dailyFatsG: (draft['daily_fats_g'] as num? ?? 0).toInt(),
      days: (draft['days'] as List<dynamic>? ?? [])
          .map((d) => DayPlan.fromJson(d as Map<String, dynamic>))
          .toList(),
      generatedFromPreferences:
      json['generated_from_preferences'] as Map<String, dynamic>? ?? {},
      // 0 and null both treated as "no update plan"
      updatePlanId: (json['update_plan_id'] as num?) == 0
          ? null
          : (json['update_plan_id'] as num?)?.toInt(),
    );
  }
}

class DayPlan {
  final int dayNumber;
  final String dayName;
  final List<Meal> meals;

  DayPlan({
    required this.dayNumber,
    required this.dayName,
    required this.meals,
  });

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    return DayPlan(
      dayNumber: (json['day_number'] as num? ?? 0).toInt(),
      dayName: json['day_name'] ?? '',
      meals: (json['meals'] as List<dynamic>? ?? [])
          .map((m) => Meal.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Meal {
  final String mealType;
  final String mealName;
  final String? description;
  final String? ingredients;
  final String? instructions;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatsG;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;

  Meal({
    required this.mealType,
    required this.mealName,
    this.description,
    this.ingredients,
    this.instructions,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealType: json['meal_type'] ?? '',
      mealName: json['meal_name'] ?? '',
      description: _parseStringOrList(json['description']),
      ingredients: _parseStringOrList(json['ingredients']),
      instructions: _parseStringOrList(json['instructions']),
      calories: (json['calories'] as num? ?? 0).toInt(),
      proteinG: (json['protein_g'] as num? ?? 0).toInt(),
      carbsG: (json['carbs_g'] as num? ?? 0).toInt(),
      fatsG: (json['fats_g'] as num? ?? 0).toInt(),
      prepTimeMinutes: json['prep_time_minutes'] != null
          ? (json['prep_time_minutes'] as num).toInt()
          : null,
      cookTimeMinutes: json['cook_time_minutes'] != null
          ? (json['cook_time_minutes'] as num).toInt()
          : null,
    );
  }

  static String? _parseStringOrList(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List) return value.join('\n'); // or ', ' depending on your UI
    return value.toString();
  }
}