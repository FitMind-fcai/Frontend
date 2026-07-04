class HydrationLogHistory {
  final int id;
  final String logDate;
  final int waterMl;
  final String? notes;
  final DateTime createdAt;

  const HydrationLogHistory({
    required this.id,
    required this.logDate,
    required this.waterMl,
    this.notes,
    required this.createdAt,
  });

  factory HydrationLogHistory.fromJson(Map<String, dynamic> json) => HydrationLogHistory(
    id: (json['id'] as num).toInt(),
    logDate: json['log_date'] as String,
    waterMl: (json['water_ml'] as num).toInt(),
    notes: json['notes'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}