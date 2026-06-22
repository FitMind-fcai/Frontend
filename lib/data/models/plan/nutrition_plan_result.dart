class NutritionPlanResult {
  final int? id; // 👈 Added ID field
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
    this.id, // 👈 Added to constructor
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
    // Handle both wrapped (with draft_plan) and flat responses
    final draft = json.containsKey('draft_plan')
        ? json['draft_plan'] as Map<String, dynamic>
        : json as Map<String, dynamic>;

    return NutritionPlanResult(
      // Extracts ID from either root json or from nested draft map safely
      id: (json['id'] ?? draft['id'] ?? json['plan_id'] ?? draft['plan_id'] as num?)?.toInt(),
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

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // 👈 Serialize ID if it exists
      'plan_name': planName,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'daily_calories': dailyCalories,
      'daily_protein_g': dailyProteinG,
      'daily_carbs_g': dailyCarbsG,
      'daily_fats_g': dailyFatsG,
      'days': days.map((d) => d.toJson()).toList(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'day_number': dayNumber,
      'day_name': dayName,
      'meals': meals.map((m) => m.toJson()).toList(),
    };
  }
}

class Meal {
  final String mealType;
  final String mealName;
  final String? description;
  final List<Ingredient> ingredients;
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
    this.ingredients = const [],
    this.instructions,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredientsList = [];
    if (json['ingredients'] != null && json['ingredients'] is List) {
      ingredientsList = (json['ingredients'] as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map((i) => Ingredient.fromJson(i))
          .toList();
    }

    return Meal(
      mealType: json['meal_type'] ?? '',
      mealName: json['meal_name'] ?? '',
      description: _parseStringOrList(json['description']),
      ingredients: ingredientsList,
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

  Map<String, dynamic> toJson() {
    return {
      'meal_type': mealType,
      'meal_name': mealName,
      'description': description,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'instructions': instructions,
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fats_g': fatsG,
      'prep_time_minutes': prepTimeMinutes,
      'cook_time_minutes': cookTimeMinutes,
    };
  }

  static String? _parseStringOrList(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List) return value.join('\n'); // or ', ' depending on your UI
    return value.toString();
  }

}
class Ingredient {
  final int? id;
  final int? nutritionPlanMealId;
  final int centralFoodId;
  final double amountG;
  final String? foodName;
  final String? foodCategory;
  final double? calories;
  final double? proteinG;
  final double? carbsG;
  final double? fatsG;
  final double? fiberG;
  final double? caloriesPer100g;
  final double? proteinPer100g;
  final double? carbsPer100g;
  final double? fatsPer100g;
  final double? fiberPer100g;

  Ingredient({
    this.id,
    this.nutritionPlanMealId,
    required this.centralFoodId,
    required this.amountG,
    this.foodName,
    this.foodCategory,
    this.calories,
    this.proteinG,
    this.carbsG,
    this.fatsG,
    this.fiberG,
    this.caloriesPer100g,
    this.proteinPer100g,
    this.carbsPer100g,
    this.fatsPer100g,
    this.fiberPer100g,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: (json['id'] as num?)?.toInt(),
      nutritionPlanMealId: (json['nutrition_plan_meal_id'] as num?)?.toInt(),
      centralFoodId: (json['central_food_id'] as num? ?? 0).toInt(),
      amountG: (json['amount_g'] as num? ?? 0).toDouble(),
      foodName: json['food_name'],
      foodCategory: json['food_category'],
      calories: (json['calories'] as num?)?.toDouble(),
      proteinG: (json['protein_g'] as num?)?.toDouble(),
      carbsG: (json['carbs_g'] as num?)?.toDouble(),
      fatsG: (json['fats_g'] as num?)?.toDouble(),
      fiberG: (json['fiber_g'] as num?)?.toDouble(),
      caloriesPer100g: (json['calories_per_100g'] as num?)?.toDouble(),
      proteinPer100g: (json['protein_per_100g'] as num?)?.toDouble(),
      carbsPer100g: (json['carbs_per_100g'] as num?)?.toDouble(),
      fatsPer100g: (json['fats_per_100g'] as num?)?.toDouble(),
      fiberPer100g: (json['fiber_per_100g'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (nutritionPlanMealId != null) 'nutrition_plan_meal_id': nutritionPlanMealId,
      'central_food_id': centralFoodId,
      'amount_g': amountG,
      if (foodName != null) 'food_name': foodName,
      if (foodCategory != null) 'food_category': foodCategory,
      if (calories != null) 'calories': calories,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatsG != null) 'fats_g': fatsG,
      if (fiberG != null) 'fiber_g': fiberG,
      if (caloriesPer100g != null) 'calories_per_100g': caloriesPer100g,
      if (proteinPer100g != null) 'protein_per_100g': proteinPer100g,
      if (carbsPer100g != null) 'carbs_per_100g': carbsPer100g,
      if (fatsPer100g != null) 'fats_per_100g': fatsPer100g,
      if (fiberPer100g != null) 'fiber_per_100g': fiberPer100g,
    };
  }
}

