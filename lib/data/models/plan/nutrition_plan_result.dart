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
  });

  factory NutritionPlanResult.fromJson(Map<String, dynamic> json) {
    final draft = json['draft_plan'] as Map<String, dynamic>;
    return NutritionPlanResult(
      planName: draft['plan_name'] ?? '',
      description: draft['description'] ?? '',
      startDate: draft['start_date'] ?? '',
      endDate: draft['end_date'] ?? '',
      dailyCalories: (draft['daily_calories'] ?? 0).toInt(),
      dailyProteinG: (draft['daily_protein_g'] ?? 0).toInt(),
      dailyCarbsG: (draft['daily_carbs_g'] ?? 0).toInt(),
      dailyFatsG: (draft['daily_fats_g'] ?? 0).toInt(),
      days: (draft['days'] as List<dynamic>? ?? [])
          .map((d) => DayPlan.fromJson(d as Map<String, dynamic>))
          .toList(),
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
      dayNumber: (json['day_number'] ?? 0).toInt(),
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
      description: json['description'],
      ingredients: json['ingredients'],
      instructions: json['instructions'],
      calories: (json['calories'] ?? 0).toInt(),
      proteinG: (json['protein_g'] ?? 0.0).toDouble().toInt(),
      carbsG: (json['carbs_g'] ?? 0.0).toDouble().toInt(),
      fatsG: (json['fats_g'] ?? 0.0).toDouble().toInt(),
      prepTimeMinutes: json['prep_time_minutes'],
      cookTimeMinutes: json['cook_time_minutes'],
    );
  }
}