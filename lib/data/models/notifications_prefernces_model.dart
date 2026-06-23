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
      mealRemindersEnabled: json['meal_reminders_enabled'],
      workoutRemindersEnabled: json['workout_reminders_enabled'],
      hydrationRemindersEnabled: json['hydration_reminders_enabled'],
      sleepRemindersEnabled: json['sleep_reminders_enabled'],
      coachingRemindersEnabled: json['coaching_reminders_enabled'],
      hydrationIntervalHours: json['hydration_interval_hours'],
      mealReminderMinutesBefore: json['meal_reminder_minutes_before'],
      workoutReminderHour: json['workout_reminder_hour'],
      sleepReminderHour: json['sleep_reminder_hour'],
      coachingDailyHour: json['coaching_daily_hour'],
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