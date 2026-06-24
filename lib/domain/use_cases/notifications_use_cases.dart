import '../../data/models/coaching_message_model.dart';
import '../../data/models/notifications_prefernces_model.dart';
import '../repositories/notifications_repository.dart';

class RegisterDeviceTokenUseCase {
  final NotificationRepository repository;
  RegisterDeviceTokenUseCase(this.repository);

  Future<void> call(String token) => repository.registerDeviceToken(token);
}

class DeleteDeviceTokenUseCase {
  final NotificationRepository repository;
  DeleteDeviceTokenUseCase(this.repository);

  Future<void> call(String token) => repository.deleteDeviceToken(token);
}

class GetNotificationPreferencesUseCase {
  final NotificationRepository repository;
  GetNotificationPreferencesUseCase(this.repository);

  Future<NotificationPreferencesModel> call() => repository.getPreferences();
}

class UpdateNotificationPreferencesUseCase {
  final NotificationRepository repository;
  UpdateNotificationPreferencesUseCase(this.repository);

  Future<void> call(NotificationPreferencesModel prefs) =>
      repository.updatePreferences(prefs);
}

class TriggerReminderUseCase {
  final NotificationRepository repository;
  TriggerReminderUseCase(this.repository);

  Future<void> call(String reminderType) =>
      repository.triggerReminder(reminderType);
}
class GetCoachingMessagesUseCase {
  final NotificationRepository repository;
  GetCoachingMessagesUseCase(this.repository);

  Future<CoachingMessagesResponse> call({
    int skip = 0,
    int limit = 20,
    String? category,
    bool unreadOnly = false,
  }) =>
      repository.getCoachingMessages(
        skip: skip,
        limit: limit,
        category: category,
        unreadOnly: unreadOnly,
      );
}

class MarkCoachingMessageReadUseCase {
  final NotificationRepository repository;
  MarkCoachingMessageReadUseCase(this.repository);

  Future<void> call(int messageId) =>
      repository.markCoachingMessageRead(messageId);
}

class MarkAllCoachingMessagesReadUseCase {
  final NotificationRepository repository;
  MarkAllCoachingMessagesReadUseCase(this.repository);

  Future<void> call() => repository.markAllCoachingMessagesRead();
}

class DismissCoachingMessageUseCase {
  final NotificationRepository repository;
  DismissCoachingMessageUseCase(this.repository);

  Future<void> call(int messageId) =>
      repository.dismissCoachingMessage(messageId);
}