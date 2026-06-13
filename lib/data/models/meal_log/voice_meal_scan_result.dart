import 'meal_scan_result.dart';

class VoiceMealScanResult {
  final String rawText;
  final String mealName;
  final String mealType;
  final List<String> foodItems;
  final List<String> portions;
  final List<String> tags;
  final double estimatedCalories;
  final double estimatedProteinG;
  final double estimatedCarbsG;
  final double estimatedFatsG;
  final List<MatchedFood> matchedFoods; // was FoodSearchResult
  final bool parseSuccessful;
  final String notes;

  VoiceMealScanResult({
    required this.rawText,
    required this.mealName,
    required this.mealType,
    required this.foodItems,
    required this.portions,
    required this.tags,
    required this.estimatedCalories,
    required this.estimatedProteinG,
    required this.estimatedCarbsG,
    required this.estimatedFatsG,
    required this.matchedFoods,
    required this.parseSuccessful,
    required this.notes,
  });

  factory VoiceMealScanResult.fromJson(Map<String, dynamic> json) {
    return VoiceMealScanResult(
      rawText: json['raw_text'] ?? '',
      mealName: json['meal_name'] ?? '',
      mealType: json['meal_type'] ?? '',
      foodItems: (json['food_items'] as List<dynamic>? ?? [])
          .whereType<String>()
          .toList(),
      portions: (json['portions'] as List<dynamic>? ?? [])
          .whereType<String>()
          .toList(),
      tags: (json['tags'] as List<dynamic>? ?? [])
          .whereType<String>()
          .toList(),
      estimatedCalories: (json['estimated_calories'] as num? ?? 0).toDouble(),
      estimatedProteinG: (json['estimated_protein_g'] as num? ?? 0).toDouble(),
      estimatedCarbsG: (json['estimated_carbs_g'] as num? ?? 0).toDouble(),
      estimatedFatsG: (json['estimated_fats_g'] as num? ?? 0).toDouble(),
      matchedFoods: (json['matched_foods'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((f) => MatchedFood.fromJson(f))
          .toList(),
      parseSuccessful: json['parse_successful'] as bool? ?? false,
      notes: json['notes'] ?? '',
    );
  }
}
