import '../../domain/repositories/notifications_repository.dart';
import '../data_sources/remote/notifications_remote_data_source.dart';
import '../models/coaching_message_model.dart';
import '../models/notifications_prefernces_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> registerDeviceToken(String token) =>
      remoteDataSource.registerDeviceToken(token);

  @override
  Future<void> deleteDeviceToken(String token) =>
      remoteDataSource.deleteDeviceToken(token);

  @override
  Future<NotificationPreferencesModel> getPreferences() =>
      remoteDataSource.getPreferences();

  @override
  Future<void> updatePreferences(NotificationPreferencesModel prefs) =>
      remoteDataSource.updatePreferences(prefs);

  @override
  Future<void> triggerReminder(String reminderType) =>
      remoteDataSource.triggerReminder(reminderType);
  @override
  Future<CoachingMessagesResponse> getCoachingMessages({
    int skip = 0,
    int limit = 20,
    String? category,
    bool unreadOnly = false,
  }) =>
      remoteDataSource.getCoachingMessages(
        skip: skip,
        limit: limit,
        category: category,
        unreadOnly: unreadOnly,
      );

  @override
  Future<void> markCoachingMessageRead(int messageId) =>
      remoteDataSource.markCoachingMessageRead(messageId);

  @override
  Future<void> markAllCoachingMessagesRead() =>
      remoteDataSource.markAllCoachingMessagesRead();

  @override
  Future<void> dismissCoachingMessage(int messageId) =>
      remoteDataSource.dismissCoachingMessage(messageId);
}