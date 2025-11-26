import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../data/models/auth_response_mode.dart';
import '../data/models/user_model.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8000") // ✅ base URL (change to yours)
abstract class AuthApiService {
  factory AuthApiService(Dio dio) = _AuthApiService;

  /// POST /auth/signup
  @POST("/auth/signup")
  Future<UserModel> signUp(@Body() Map<String, dynamic> body);

  /// POST /auth/login
  @POST("/auth/login")
  Future<AuthResponseModel> signIn(@Body() Map<String, dynamic> body);

  /// GET /auth/verify-email?email={email}
  @GET("/auth/verify-email")
  Future<void> verifyEmail(@Query("email") String email);

  @GET("/auth/me")
  Future<UserModel> getMe(@Header("Authorization") String token);

  @POST("/auth/forgot-password")
  Future<void> forgotPassword(@Body() Map<String, dynamic> body);

  /// POST /auth/verify-otp
  /// Verifies OTP for password reset
  @POST("/auth/verify-otp")
  Future<void> verifyOtp(@Body() Map<String, dynamic> body);

  /// POST /auth/reset-password
  /// Resets the password after OTP verification
  @POST("/auth/reset-password")
  Future<void> resetPassword(@Body() Map<String, dynamic> body);
}
