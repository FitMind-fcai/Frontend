import 'package:flutter/foundation.dart';

@immutable
class MealsSummaryResult {
  final String date;
  final int totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatsG;
  final double proteinPct;
  final double carbsPct;
  final double fatsPct;
  final int mealCount;

  const MealsSummaryResult({
    required this.date,
    required this.totalCalories,
    required this.totalProteinG,
    required this.totalCarbsG,
    required this.totalFatsG,
    required this.proteinPct,
    required this.carbsPct,
    required this.fatsPct,
    required this.mealCount,
  });

  factory MealsSummaryResult.fromJson(Map<String, dynamic> json) {
    // Defensive parsing: the schema shows these as bare numbers, which
    // json-decodes as int when the value happens to be whole (e.g. 0
    // instead of 0.0). Going through `num` first avoids a runtime cast
    // error the day a value lands on a whole number.
    return MealsSummaryResult(
      date: json['date'] as String,
      totalCalories: (json['total_calories'] as num).toInt(),
      totalProteinG: (json['total_protein_g'] as num).toDouble(),
      totalCarbsG: (json['total_carbs_g'] as num).toDouble(),
      totalFatsG: (json['total_fats_g'] as num).toDouble(),
      proteinPct: (json['protein_pct'] as num).toDouble(),
      carbsPct: (json['carbs_pct'] as num).toDouble(),
      fatsPct: (json['fats_pct'] as num).toDouble(),
      mealCount: (json['meal_count'] as num).toInt(),
    );
  }
}