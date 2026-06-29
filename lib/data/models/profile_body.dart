class ProfileBody {
  final int userId;
  final int age;
  final double height;
  final double weight;

  final Gender gender;
  final FitnessGoal fitnessGoal;
  final ActivityLevel activityLevel;

  final List<String> dietaryPreferences;
  final List<String> medicalConditions;
  final List<String> allergies;
  final List<String> injuries;
  final List<String> medications;

  ProfileBody({
    required this.userId,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.fitnessGoal,
    required this.activityLevel,
    required this.dietaryPreferences,
    required this.medicalConditions,
    required this.allergies,
    required this.injuries,
    required this.medications,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "age": age,
      "height": height,
      "weight": weight,
      "gender": gender.name,
      "fitness_goal": getFitnessGoalString(fitnessGoal),
      "activity_level": activityLevel.name,
      // Join lists into comma-separated strings
      "dietary_preference": dietaryPreferences.join(','),
      "medical_conditions": medicalConditions.join(','),
      "allergies": allergies.join(','),
      "injuries": injuries.join(','),
      "medications": medications.join(','),
    };
  }
  factory ProfileBody.fromJson(Map<String, dynamic> json) {
    return ProfileBody(
      userId: json['user_id'],
      age: json['age'],
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      gender: Gender.values.firstWhere(
            (e) => e.name == json['gender'],
      ),
      fitnessGoal: _fitnessGoalFromString(json['fitness_goal']),
      activityLevel: ActivityLevel.values.firstWhere(
            (e) => e.name == json['activity_level'],
      ),
      // Backend stores as comma-separated strings, split them back to lists
      dietaryPreferences: (json['dietary_preference'] as String?)
          ?.split(',')
          .where((s) => s.isNotEmpty)
          .toList() ??
          [],
      medicalConditions: (json['medical_conditions'] as String?)
          ?.split(',')
          .where((s) => s.isNotEmpty)
          .toList() ??
          [],
      allergies: (json['allergies'] as String?)
          ?.split(',')
          .where((s) => s.isNotEmpty)
          .toList() ??
          [],
      injuries: (json['injuries'] as String?)
          ?.split(',')
          .where((s) => s.isNotEmpty)
          .toList() ??
          [],
      medications: (json['medications'] as String?)
          ?.split(',')
          .where((s) => s.isNotEmpty)
          .toList() ??
          [],
    );
  }

  static FitnessGoal _fitnessGoalFromString(String value) {
    switch (value) {
      case 'Lose Weight':
        return FitnessGoal.LoseWeight;
      case 'Try AI Coach':
        return FitnessGoal.TryAICoach;
      case 'Get Bulks':
        return FitnessGoal.GetBulks;
      case 'Improve Endurance':
        return FitnessGoal.ImproveEndurance;
      default:
        return FitnessGoal.LoseWeight;
    }
  }
}

enum Gender { Male, Female }

enum FitnessGoal {
  LoseWeight,
  TryAICoach,
  GetBulks,
  ImproveEndurance,
}

String getFitnessGoalString(FitnessGoal goal) {
  switch (goal) {
    case FitnessGoal.LoseWeight:
      return 'Lose Weight';
    case FitnessGoal.TryAICoach:
      return 'Try AI Coach';
    case FitnessGoal.GetBulks:
      return 'Get Bulks';
    case FitnessGoal.ImproveEndurance:
      return 'Improve Endurance';
  }
}

enum ActivityLevel {
  Sedentary,
  LightlyActive,
  ModeratelyActive,
  VeryActive,
  ExtraActive,
}

