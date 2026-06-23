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
  Future<void> deleteDeviceToken();

  @GET('/v1/notifications/preferences')
  Future<NotificationPreferencesModel> getPreferences();

  @PUT('/v1/notifications/preferences')
  Future<void> updatePreferences(@Body() NotificationPreferencesModel body);

  @POST('/v1/notifications/trigger/{reminderType}')
  Future<void> triggerReminder(@Path('reminderType') String reminderType);
}