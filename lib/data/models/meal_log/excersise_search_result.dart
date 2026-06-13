class ExerciseSearchResult {
  final int id;
  final String name;
  final String exerciseType;
  final String primaryMuscleGroup;
  final String? secondaryMuscles;
  final String? equipmentRequired;
  final String? difficultyLevel;
  final String? location;
  final double similarityScore;

  ExerciseSearchResult({
    required this.id,
    required this.name,
    required this.exerciseType,
    required this.primaryMuscleGroup,
    this.secondaryMuscles,
    this.equipmentRequired,
    this.difficultyLevel,
    this.location,
    required this.similarityScore,
  });

  factory ExerciseSearchResult.fromJson(Map<String, dynamic> json) {
    return ExerciseSearchResult(
      id: (json['id'] as num).toInt(),
      name: json['name'] ?? '',
      exerciseType: json['exercise_type'] ?? '',
      primaryMuscleGroup: json['primary_muscle_group'] ?? '',
      secondaryMuscles: json['secondary_muscles'] as String?,
      equipmentRequired: json['equipment_required'] as String?,
      difficultyLevel: json['difficulty_level'] as String?,
      location: json['location'] as String?,
      similarityScore: (json['similarity_score'] as num? ?? 0).toDouble(),
    );
  }
}