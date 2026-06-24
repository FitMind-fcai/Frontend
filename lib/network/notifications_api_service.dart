import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../data/data_sources/local/auth_local_data_source.dart';
import '../data/models/notifications_prefernces_model.dart';

part 'notifications_api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8000")
abstract class NotificationsApiService {

  factory NotificationsApiService(Dio dio, AuthLocalDataSource local) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await local.getCachedToken();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );

    return _NotificationsApiService(dio);
  }

  @POST('/v1/notifications/device-token')
  Future<void> registerDeviceToken(@Body() Map<String, dynamic> body);

  @DELETE('/v1/notifications/device-token')
  Future<void> deleteDeviceToken(@Body() Map<String, dynamic> body);

  @GET('/v1/notifications/preferences')
  Future<NotificationPreferencesModel> getPreferences();

  @PUT('/v1/notifications/preferences')
  Future<void> updatePreferences(@Body() NotificationPreferencesModel body);

  @POST('/v1/notifications/trigger/{reminderType}')
  Future<void> triggerReminder(@Path('reminderType') String reminderType);

  @GET('/v1/coaching/messages')
  Future<HttpResponse<dynamic>> getCoachingMessagesRaw(
      @Query('skip') int skip,
      @Query('limit') int limit,
      @Query('category') String? category,
      @Query('unread_only') bool unreadOnly,
      );

  @PATCH('/v1/coaching/messages/{message_id}/read')
  Future<void> markCoachingMessageRead(@Path('message_id') int messageId);

  @POST('/v1/coaching/messages/read-all')
  Future<void> markAllCoachingMessagesRead();

  @DELETE('/v1/coaching/messages/{message_id}')
  Future<void> dismissCoachingMessage(@Path('message_id') int messageId);
}