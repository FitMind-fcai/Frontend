// domain/entities/plan/nutrition_plan_result_entity.dart
class NutritionPlanResultEntity {
  final int? id;
  final String planName;
  final String description;
  final String startDate;
  final String endDate;
  final int dailyCalories;
  final int dailyProteinG;
  final int dailyCarbsG;
  final int dailyFatsG;
  final List<DayPlanEntity> days;
  final Map<String, dynamic> generatedFromPreferences;
  final int? updatePlanId;

  NutritionPlanResultEntity({
    this.id,
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
}

class DayPlanEntity {
  final int dayNumber;
  final String dayName;
  final List<MealEntity> meals;

  DayPlanEntity({
    required this.dayNumber,
    required this.dayName,
    required this.meals,
  });
}

class MealEntity {
  final String mealType;
  final String mealName;
  final String? description;
  final List<IngredientEntity> ingredients;
  final String? instructions;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatsG;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;

  MealEntity({
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
}

class IngredientEntity {
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

  IngredientEntity({
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
}