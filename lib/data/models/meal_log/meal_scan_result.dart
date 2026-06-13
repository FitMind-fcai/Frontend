
class MealScanResult {
  final String mealName;
  final String mealType;
  final List<MealFoodItem> foodItems;
  final double totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatsG;
  final List<String> tags;
  final String healthNotes;
  final double confidenceScore;
  final List<MatchedFood> matchedFoods;
  final List<Map<String, dynamic>> allergenWarnings;
  final bool scanSuccessful;
  final String? errorMessage;

  MealScanResult({
    required this.mealName,
    required this.mealType,
    required this.foodItems,
    required this.totalCalories,
    required this.totalProteinG,
    required this.totalCarbsG,
    required this.totalFatsG,
    required this.tags,
    required this.healthNotes,
    required this.confidenceScore,
    required this.matchedFoods,
    required this.allergenWarnings,
    required this.scanSuccessful,
    this.errorMessage,
  });

  factory MealScanResult.fromJson(Map<String, dynamic> json) {
    return MealScanResult(
      mealName: json['meal_name'] ?? '',
      mealType: json['meal_type'] ?? '',
      foodItems: (json['food_items'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((item) => MealFoodItem.fromJson(item))
          .toList(),
      totalCalories: (json['total_calories'] as num? ?? 0).toDouble(),
      totalProteinG: (json['total_protein_g'] as num? ?? 0).toDouble(),
      totalCarbsG: (json['total_carbs_g'] as num? ?? 0).toDouble(),
      totalFatsG: (json['total_fats_g'] as num? ?? 0).toDouble(),
      tags: (json['tags'] as List<dynamic>? ?? [])
          .whereType<String>()
          .toList(),
      healthNotes: json['health_notes'] ?? '',
      confidenceScore: (json['confidence_score'] as num? ?? 0).toDouble(),
      matchedFoods: (json['matched_foods'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((item) => MatchedFood.fromJson(item))
          .toList(),
      allergenWarnings: (json['allergen_warnings'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList(),
      scanSuccessful: json['scan_successful'] as bool? ?? false,
      errorMessage: json['error_message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meal_name': mealName,
      'meal_type': mealType,
      'food_items': foodItems.map((item) => item.toJson()).toList(),
      'total_calories': totalCalories,
      'total_protein_g': totalProteinG,
      'total_carbs_g': totalCarbsG,
      'total_fats_g': totalFatsG,
      'tags': tags,
      'health_notes': healthNotes,
      'confidence_score': confidenceScore,
      'matched_foods': matchedFoods.map((item) => item.toJson()).toList(),
      'allergen_warnings': allergenWarnings,
      'scan_successful': scanSuccessful,
      if (errorMessage != null) 'error_message': errorMessage,
    };
  }
}
class MatchedFood {
  final int id;
  final String foodName;
  final String foodCategory;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatsPer100g;
  final double fiberPer100g;
  final double servingSizeG;
  final String servingDescription;
  final double similarityScore;

  MatchedFood({
    required this.id,
    required this.foodName,
    required this.foodCategory,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatsPer100g,
    required this.fiberPer100g,
    required this.servingSizeG,
    required this.servingDescription,
    required this.similarityScore,
  });

  factory MatchedFood.fromJson(Map<String, dynamic> json) {
    return MatchedFood(
      id: (json['id'] as num).toInt(),
      foodName: json['food_name'] ?? '',
      foodCategory: json['food_category'] ?? '',
      caloriesPer100g: (json['calories_per_100g'] as num? ?? 0).toDouble(),
      proteinPer100g: (json['protein_per_100g'] as num? ?? 0).toDouble(),
      carbsPer100g: (json['carbs_per_100g'] as num? ?? 0).toDouble(),
      fatsPer100g: (json['fats_per_100g'] as num? ?? 0).toDouble(),
      fiberPer100g: (json['fiber_per_100g'] as num? ?? 0).toDouble(),
      servingSizeG: (json['serving_size_g'] as num? ?? 0).toDouble(),
      servingDescription: json['serving_description'] ?? '',
      similarityScore: (json['similarity_score'] as num? ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food_name': foodName,
      'food_category': foodCategory,
      'calories_per_100g': caloriesPer100g,
      'protein_per_100g': proteinPer100g,
      'carbs_per_100g': carbsPer100g,
      'fats_per_100g': fatsPer100g,
      'fiber_per_100g': fiberPer100g,
      'serving_size_g': servingSizeG,
      'serving_description': servingDescription,
      'similarity_score': similarityScore,
    };
  }
}
class MealFoodItem {
  final String name;
  final String portionSize;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;
  final double fiberG;
  final double confidence;

  MealFoodItem({
    required this.name,
    required this.portionSize,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    required this.fiberG,
    required this.confidence,
  });

  factory MealFoodItem.fromJson(Map<String, dynamic> json) {
    return MealFoodItem(
      name: json['name'] ?? '',
      portionSize: json['portion_size'] ?? '',
      calories: (json['calories'] as num? ?? 0).toDouble(),
      proteinG: (json['protein_g'] as num? ?? 0).toDouble(),
      carbsG: (json['carbs_g'] as num? ?? 0).toDouble(),
      fatsG: (json['fats_g'] as num? ?? 0).toDouble(),
      fiberG: (json['fiber_g'] as num? ?? 0).toDouble(),
      confidence: (json['confidence'] as num? ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'portion_size': portionSize,
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fats_g': fatsG,
      'fiber_g': fiberG,
      'confidence': confidence,
    };
  }
}