class WeightLogHistory {
  final int id;
  final String logDate;
  final double weight;
  final String? notes;

  const WeightLogHistory({
    required this.id,
    required this.logDate,
    required this.weight,
    this.notes,
  });

  factory WeightLogHistory.fromJson(Map<String, dynamic> json) => WeightLogHistory(
    id: (json['id'] as num).toInt(),
    logDate: json['log_date'] as String,
    weight: (json['weight'] as num).toDouble(),
    notes: json['notes'] as String?,
  );
}