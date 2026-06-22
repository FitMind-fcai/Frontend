class SleepLogHistory {
  final int id;
  final String logDate;
  final double sleepHours;
  final int? sleepQuality;
  final String? notes;

  const SleepLogHistory({
    required this.id,
    required this.logDate,
    required this.sleepHours,
    this.sleepQuality,
    this.notes,
  });

  factory SleepLogHistory.fromJson(Map<String, dynamic> json) => SleepLogHistory(
    id: (json['id'] as num).toInt(),
    logDate: json['log_date'] as String,
    sleepHours: (json['sleep_hours'] as num).toDouble(),
    sleepQuality: (json['sleep_quality'] as num?)?.toInt(),
    notes: json['notes'] as String?,
  );
}