// lib/data/models/recommendations/score_response.dart

class ScoreResponse {
  final double overallScore;
  final double nutrition;
  final double strength;
  final double agility;
  final double endurance;
  final double hydration;
  final double sleep;
  final List<double> strengthSeries;
  final List<double> agilitySeries;
  final List<double> enduranceSeries;
  final String generatedAt;

  const ScoreResponse({
    required this.overallScore,
    required this.nutrition,
    required this.strength,
    required this.agility,
    required this.endurance,
    required this.hydration,
    required this.sleep,
    required this.strengthSeries,
    required this.agilitySeries,
    required this.enduranceSeries,
    required this.generatedAt,
  });

  factory ScoreResponse.fromJson(Map<String, dynamic> json) => ScoreResponse(
    overallScore: (json['overall_score'] as num).toDouble(),
    nutrition: (json['nutrition'] as num).toDouble(),
    strength: (json['strength'] as num).toDouble(),
    agility: (json['agility'] as num).toDouble(),
    endurance: (json['endurance'] as num).toDouble(),
    hydration: (json['hydration'] as num).toDouble(),
    sleep: (json['sleep'] as num).toDouble(),
    strengthSeries: (json['strength_series'] as List<dynamic>)
        .map((e) => (e as num).toDouble())
        .toList(),
    agilitySeries: (json['agility_series'] as List<dynamic>)
        .map((e) => (e as num).toDouble())
        .toList(),
    enduranceSeries: (json['endurance_series'] as List<dynamic>)
        .map((e) => (e as num).toDouble())
        .toList(),
    generatedAt: json['generated_at'] as String? ?? '',
  );

  /// Axis order expected by the radar chart:
  /// [Calorie/Nutrition, BMI/Strength, BPM/Agility, Hydration, Sleep, Steps/Endurance]
  List<double> get strengthRadarEntries => strengthSeries.length == 6
      ? strengthSeries
      : [strength, strength, strength, hydration, sleep, endurance];

  List<double> get agilityRadarEntries => agilitySeries.length == 6
      ? agilitySeries
      : [nutrition, agility, agility, hydration, sleep, endurance];

  List<double> get enduranceRadarEntries => enduranceSeries.length == 6
      ? enduranceSeries
      : [nutrition, strength, agility, hydration, sleep, endurance];
}