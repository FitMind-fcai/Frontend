import 'excersise_search_result.dart';

class VoiceWorkoutScanResult {
  final String rawText;
  final List<ParsedExercise> exercises;
  final String durationMentioned;
  final List<String> tags;
  final bool parseSuccessful;
  final String notes;

  VoiceWorkoutScanResult({
    required this.rawText,
    required this.exercises,
    required this.durationMentioned,
    required this.tags,
    required this.parseSuccessful,
    required this.notes,
  });

  factory VoiceWorkoutScanResult.fromJson(Map<String, dynamic> json) {
    return VoiceWorkoutScanResult(
      rawText: json['raw_text'] ?? '',
      exercises: (json['exercises'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => ParsedExercise.fromJson(e))
          .toList(),
      durationMentioned: json['duration_mentioned'] ?? '',
      tags: (json['tags'] as List<dynamic>? ?? [])
          .whereType<String>()
          .toList(),
      parseSuccessful: json['parse_successful'] as bool? ?? false,
      notes: json['notes'] ?? '',
    );
  }
}

class ParsedExercise {
  final String name;
  final int sets;
  final int reps;
  final String weightStr;
  final double weightKg;
  final int durationSeconds;
  final List<MatchedExercise> matchedExercises; // was ExerciseSearchResult

  ParsedExercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weightStr,
    required this.weightKg,
    required this.durationSeconds,
    required this.matchedExercises,
  });

  factory ParsedExercise.fromJson(Map<String, dynamic> json) {
    return ParsedExercise(
      name: json['name'] ?? '',
      sets: (json['sets'] as num? ?? 0).toInt(),
      reps: (json['reps'] as num? ?? 0).toInt(),
      weightStr: json['weight_str'] ?? '',
      weightKg: (json['weight_kg'] as num? ?? 0).toDouble(),
      durationSeconds: (json['duration_seconds'] as num? ?? 0).toInt(),
      matchedExercises: (json['matched_exercises'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => MatchedExercise.fromJson(e))
          .toList(),
    );
  }
}
class MatchedExercise {
  final int id;
  final String name;
  final String exerciseType;
  final String primaryMuscleGroup;
  final String secondaryMuscles;
  final String equipmentRequired;
  final String difficultyLevel;
  final String location;
  final double similarityScore;

  MatchedExercise({
    required this.id,
    required this.name,
    required this.exerciseType,
    required this.primaryMuscleGroup,
    required this.secondaryMuscles,
    required this.equipmentRequired,
    required this.difficultyLevel,
    required this.location,
    required this.similarityScore,
  });

  factory MatchedExercise.fromJson(Map<String, dynamic> json) => MatchedExercise(
    id: json['id'] as int,
    name: json['name'] ?? '',
    exerciseType: json['exercise_type'] ?? '',
    primaryMuscleGroup: json['primary_muscle_group'] ?? '',
    secondaryMuscles: json['secondary_muscles'] ?? '',
    equipmentRequired: json['equipment_required'] ?? '',
    difficultyLevel: json['difficulty_level'] ?? '',
    location: json['location'] ?? '',
    similarityScore: (json['similarity_score'] as num? ?? 0).toDouble(),
  );
}