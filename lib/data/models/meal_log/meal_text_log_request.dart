class MealTextLogRequest {
  final int centralFoodId;
  final String logDate;
  final String mealType;
  final String mealName;
  final double servings;
  final double servingSizeGSnapshot;
  final String servingDescriptionSnapshot;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;

  MealTextLogRequest({
    required this.centralFoodId,
    required this.logDate,
    required this.mealType,
    required this.mealName,
    required this.servings,
    required this.servingSizeGSnapshot,
    required this.servingDescriptionSnapshot,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
  });

  Map<String, dynamic> toJson() {
    return {
      'central_food_id': centralFoodId,
      'log_date': logDate,
      'meal_type': mealType,
      'meal_name': mealName,
      'servings': servings,
      'serving_size_g_snapshot': servingSizeGSnapshot,
      'serving_description_snapshot': servingDescriptionSnapshot,
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fats_g': fatsG,
    };
  }
}