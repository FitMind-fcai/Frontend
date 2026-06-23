import '../../data/models/notifications_prefernces_model.dart';

abstract class NotificationRepository {
  Future<void> registerDeviceToken(String token);
  Future<void> deleteDeviceToken();
  Future<NotificationPreferencesModel> getPreferences();
  Future<void> updatePreferences(NotificationPreferencesModel prefs);
  Future<void> triggerReminder(String reminderType);
}