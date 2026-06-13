// lib/data/models/voice_log/voice_log_request.dart

class VoiceMealLogRequest {
  final String audioBase64;
  final String audioFormat;
  final String logDate;
  final String mealType;
  final String language;
  final int? centralFoodId;
  final double? servings;

  VoiceMealLogRequest({
    required this.audioBase64,
    required this.audioFormat,
    required this.logDate,
    required this.mealType,
    this.language = 'en',
    this.centralFoodId,
    this.servings,
  });

  Map<String, dynamic> toJson() => {
    'audio_base64': audioBase64,
    'audio_format': audioFormat,
    'log_date': logDate,
    'meal_type': mealType,
    'language': language,
    if (centralFoodId != null) 'central_food_id': centralFoodId,
    if (servings != null) 'servings': servings,
  };
}
class VoiceMealScanRequest {
  final String audioBase64;
  final String audioFormat;
  final String language;

  VoiceMealScanRequest({
    required this.audioBase64,
    required this.audioFormat,
    this.language = 'en',
  });

  Map<String, dynamic> toJson() => {
    'audio_base64': audioBase64,
    'audio_format': audioFormat,
    'language': language,
  };
}