class HydrationLogHistory {
  final int id;
  final String logDate;
  final int waterMl;
  final String? notes;

  const HydrationLogHistory({
    required this.id,
    required this.logDate,
    required this.waterMl,
    this.notes,
  });

  factory HydrationLogHistory.fromJson(Map<String, dynamic> json) => HydrationLogHistory(
    id: (json['id'] as num).toInt(),
    logDate: json['log_date'] as String,
    waterMl: (json['water_ml'] as num).toInt(),
    notes: json['notes'] as String?,
  );
}