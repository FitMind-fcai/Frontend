class NotificationPreferencesModel {
  final bool mealRemindersEnabled;
  final bool workoutRemindersEnabled;
  final bool hydrationRemindersEnabled;
  final bool sleepRemindersEnabled;
  final bool coachingRemindersEnabled;
  final int hydrationIntervalHours;
  final int mealReminderMinutesBefore;
  final int workoutReminderHour;
  final int sleepReminderHour;
  final int coachingDailyHour;

  NotificationPreferencesModel({
    required this.mealRemindersEnabled,
    required this.workoutRemindersEnabled,
    required this.hydrationRemindersEnabled,
    required this.sleepRemindersEnabled,
    required this.coachingRemindersEnabled,
    required this.hydrationIntervalHours,
    required this.mealReminderMinutesBefore,
    required this.workoutReminderHour,
    required this.sleepReminderHour,
    required this.coachingDailyHour,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      mealRemindersEnabled: (json['meal_reminders_enabled'] as bool?) ?? false,
      workoutRemindersEnabled: (json['workout_reminders_enabled'] as bool?) ?? false,
      hydrationRemindersEnabled: (json['hydration_reminders_enabled'] as bool?) ?? false,
      sleepRemindersEnabled: (json['sleep_reminders_enabled'] as bool?) ?? false,
      coachingRemindersEnabled: (json['coaching_reminders_enabled'] as bool?) ?? false,
      hydrationIntervalHours: (json['hydration_interval_hours'] as int?) ?? 2,
      mealReminderMinutesBefore: (json['meal_reminder_minutes_before'] as int?) ?? 30,
      workoutReminderHour: (json['workout_reminder_hour'] as int?) ?? 8,
      sleepReminderHour: (json['sleep_reminder_hour'] as int?) ?? 22,
      coachingDailyHour: (json['coaching_daily_hour'] as int?) ?? 9,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meal_reminders_enabled': mealRemindersEnabled,
      'workout_reminders_enabled': workoutRemindersEnabled,
      'hydration_reminders_enabled': hydrationRemindersEnabled,
      'sleep_reminders_enabled': sleepRemindersEnabled,
      'coaching_reminders_enabled': coachingRemindersEnabled,
      'hydration_interval_hours': hydrationIntervalHours,
      'meal_reminder_minutes_before': mealReminderMinutesBefore,
      'workout_reminder_hour': workoutReminderHour,
      'sleep_reminder_hour': sleepReminderHour,
      'coaching_daily_hour': coachingDailyHour,
    };
  }
}