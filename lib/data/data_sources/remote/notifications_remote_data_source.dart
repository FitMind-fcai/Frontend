import 'package:dio/dio.dart';

import '../../../network/notifications_api_service.dart';
import '../../models/coaching_message_model.dart';
import '../../models/notifications_prefernces_model.dart';

abstract class NotificationRemoteDataSource {
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


class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final NotificationsApiService apiService;

  NotificationRemoteDataSourceImpl(this.apiService);

  String _extractError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      try {
        if (data is String) return data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('detail')) return data['detail'].toString();
          if (data.containsKey('message')) return data['message'].toString();
          return data.values.join(', ');
        }
      } catch (_) {}
      return e.response!.statusMessage ?? 'Unknown server error';
    }
    return e.message ?? 'Network error occurred';
  }

  @override
  Future<void> registerDeviceToken(String token) async {
    try {
      await apiService.registerDeviceToken({
        'token': token,
        'platform': 'android',
      });
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteDeviceToken(String token) async {
    try {
      await apiService.deleteDeviceToken({
        'token': token,
        'platform': 'android',
      });
    }on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<NotificationPreferencesModel> getPreferences() async {
    try {
      return await apiService.getPreferences();
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updatePreferences(NotificationPreferencesModel prefs) async {
    try {
      await apiService.updatePreferences(prefs);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> triggerReminder(String reminderType) async {
    try {
      await apiService.triggerReminder(reminderType);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  @override
  Future<CoachingMessagesResponse> getCoachingMessages({
    int skip = 0,
    int limit = 20,
    String? category,
    bool unreadOnly = false,
  }) async {
    try {
      final response = await apiService.getCoachingMessagesRaw(
        skip,
        limit,
        category,
        unreadOnly,
      );
      return CoachingMessagesResponse.fromJson(
        response.response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> markCoachingMessageRead(int messageId) async {
    try {
      await apiService.markCoachingMessageRead(messageId);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> markAllCoachingMessagesRead() async {
    try {
      await apiService.markAllCoachingMessagesRead();
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> dismissCoachingMessage(int messageId) async {
    try {
      await apiService.dismissCoachingMessage(messageId);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}