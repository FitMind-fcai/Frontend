import '../../domain/repositories/notifications_repository.dart';
import '../data_sources/remote/notifications_remote_data_source.dart';
import '../models/notifications_prefernces_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> registerDeviceToken(String token) =>
      remoteDataSource.registerDeviceToken(token);

  @override
  Future<void> deleteDeviceToken() =>
      remoteDataSource.deleteDeviceToken();

  @override
  Future<NotificationPreferencesModel> getPreferences() =>
      remoteDataSource.getPreferences();

  @override
  Future<void> updatePreferences(NotificationPreferencesModel prefs) =>
      remoteDataSource.updatePreferences(prefs);

  @override
  Future<void> triggerReminder(String reminderType) =>
      remoteDataSource.triggerReminder(reminderType);
}