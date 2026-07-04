class MealLogHistory {
  final int id;
  final String logDate;
  final String mealType;
  final String mealName;
  final double servings;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatsG;
  final String? imageUrl;
  final DateTime createdAt;

  const MealLogHistory({
    required this.id,
    required this.logDate,
    required this.mealType,
    required this.mealName,
    required this.servings,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    this.imageUrl,
    required this.createdAt,
  });

  factory MealLogHistory.fromJson(Map<String, dynamic> json) => MealLogHistory(
    id: (json['id'] as num).toInt(),
    logDate: json['log_date'] as String,
    mealType: json['meal_type'] as String,
    mealName: json['meal_name'] as String,
    servings: (json['servings'] as num? ?? 1).toDouble(),
    calories: (json['calories'] as num? ?? 0).toInt(),
    proteinG: (json['protein_g'] as num? ?? 0).toDouble(),
    carbsG: (json['carbs_g'] as num? ?? 0).toDouble(),
    fatsG: (json['fats_g'] as num? ?? 0).toDouble(),
    imageUrl: json['image_url'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}