import 'package:dio/dio.dart';
import '../../../network/auth_api_service.dart';
import '../../models/auth_response_mode.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> signIn(String email, String password);
  Future<UserModel> signUp(UserModel user);
  Future<void> verifyEmail(String email);
  Future<UserModel> getMe(String token);
  Future<void> forgotPassword(String email);
  Future<void> verifyOtp(String email, String otp);
  Future<void> resetPassword(String email, String otp, String newPassword);
  Future<Map<String, dynamic>> getOtpStatus(String email);
  Future<void> deleteAccount(String password);

}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService api;

  AuthRemoteDataSourceImpl(this.api);

  // -----------------------------
  // Helper: Extract FastAPI error
  // -----------------------------
  String _extractError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;

      try {
        // 1. If data is already a string
        if (data is String) {
          return data;
        }

        // 2. If data is a Map (JSON)
        if (data is Map<String, dynamic>) {
          // Common key for errors: "detail" or "message"
          if (data.containsKey('detail')) {
            return data['detail'].toString();
          }
          if (data.containsKey('message')) {
            return data['message'].toString();
          }

          // fallback: join all values
          return data.values.join(', ');
        }
      } catch (_) {}

      // fallback: statusMessage
      return e.response!.statusMessage ?? "Unknown server error";
    }

    // fallback if no response
    return e.message ?? "Unknown error";
  }



  // -----------------------------
  // Sign In
  // -----------------------------
  @override
  Future<AuthResponseModel> signIn(String email, String password) async {
    try {
      return await api.signIn({
        "email": email,
        "password": password,
      });
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  // -----------------------------
  // Sign Up
  // -----------------------------
  @override
  Future<UserModel> signUp(UserModel user) async {
    try {
      return await api.signUp(user.toJson());
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  // -----------------------------
  // Verify Email
  // -----------------------------
  @override
  Future<void> verifyEmail(String email) async {
    try {
      await api.verifyEmail(email);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  // -----------------------------
  // Get Me
  // -----------------------------
  @override
  Future<UserModel> getMe(String token) async {
    try {
      return await api.getMe(token);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  // -----------------------------
  // Forgot Password
  // -----------------------------
  @override
  Future<void> forgotPassword(String email) async {
    try {
      await api.forgotPassword({"email": email});
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  // -----------------------------
  // Verify OTP
  // -----------------------------
  @override
  Future<void> verifyOtp(String email, String otp) async {
    try {
      await api.verifyOtp({
        "email": email,
        "otp": otp,
      });
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  // -----------------------------
  // Reset Password
  // -----------------------------
  @override
  Future<void> resetPassword(
      String email, String otp, String newPassword) async {
    try {
      await api.resetPassword({
        "email": email,
        "otp": otp,
        "new_password": newPassword,
      });
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }
  @override
  Future<Map<String, dynamic>> getOtpStatus(String email) async {
    try {
      return await api.getOtpStatus(email);
    }on DioException catch (e) {
      throw _extractError(e);
    }
  }
  @override
  Future<void> deleteAccount(String password) async {
    try {
      await api.deleteAccount({"password": password});
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }
}
