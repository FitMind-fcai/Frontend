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

  Future<void> call() => repository.deleteDeviceToken();
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