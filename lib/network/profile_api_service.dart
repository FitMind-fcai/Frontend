import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../data/data_sources/local/auth_local_data_source.dart';
import '../data/models/profile_body.dart';

part 'profile_api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8000")
abstract class ProfileApiService {

  factory ProfileApiService(Dio dio, AuthLocalDataSource local) {
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

    return _ProfileApiService(dio);
  }

  @POST("/profiles/")
  Future<void> createProfile(
      @Body() ProfileBody body,
      );
}