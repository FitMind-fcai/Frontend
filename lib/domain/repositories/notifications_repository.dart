import '../../data/models/coaching_message_model.dart';
import '../../data/models/notifications_prefernces_model.dart';

abstract class NotificationRepository {
  Future<void> registerDeviceToken(String token);
  Future<void> deleteDeviceToken(String token);
  Future<NotificationPreferencesModel> getPreferences();
  Future<void> updatePreferences(NotificationPreferencesModel prefs);
  Future<void> triggerReminder(String reminderType);
  Future<CoachingMessagesResponse> getCoachingMessages({
    int skip,
    int limit,
    String? category,
    bool unreadOnly,
  });
  Future<void> markCoachingMessageRead(int messageId);
  Future<void> markAllCoachingMessagesRead();
  Future<void> dismissCoachingMessage(int messageId);
}
