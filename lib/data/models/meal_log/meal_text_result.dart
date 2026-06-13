class FoodSearchResult {
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

  FoodSearchResult({
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

  factory FoodSearchResult.fromJson(Map<String, dynamic> json) {
    return FoodSearchResult(
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

  /// Calories for a given number of servings
  double caloriesForServings(double servings) =>
      caloriesPer100g * (servingSizeG / 100) * servings;

  double proteinForServings(double servings) =>
      proteinPer100g * (servingSizeG / 100) * servings;

  double carbsForServings(double servings) =>
      carbsPer100g * (servingSizeG / 100) * servings;

  double fatsForServings(double servings) =>
      fatsPer100g * (servingSizeG / 100) * servings;
}