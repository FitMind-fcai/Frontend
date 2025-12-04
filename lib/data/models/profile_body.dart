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
}

enum Gender { Male, Female }

enum FitnessGoal {
  LoseWeight,
  MaintainWeight,
  BuildMuscle,
}

enum ActivityLevel {
  Sedentary,
  LightlyActive,
  ModeratelyActive,
  VeryActive,
  ExtraActive,
}
String getFitnessGoalString(FitnessGoal goal) {
  switch (goal) {
    case FitnessGoal.LoseWeight:
      return 'Lose Weight';
    case FitnessGoal.MaintainWeight:
      return 'Maintain Weight';
    case FitnessGoal.BuildMuscle:
      return 'Build Muscle';
  }
}