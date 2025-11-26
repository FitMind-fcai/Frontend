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
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService api;

  AuthRemoteDataSourceImpl(this.api);

  @override
  Future<AuthResponseModel> signIn(String email, String password) {
    return api.signIn({
      "email": email,
      "password": password,
    });
  }

  @override
  Future<UserModel> signUp(UserModel user) {
    return api.signUp(user.toJson());
  }

  @override
  Future<void> verifyEmail(String email) {
    return api.verifyEmail(email);
  }
  Future<UserModel> getMe(String token) {
    return api.getMe(token); // token will be sent in x-auth-token header
  }
  Future<void> forgotPassword(String email) {
    return api.forgotPassword({"email": email});
  }

  Future<void> verifyOtp(String email, String otp) {
    return api.verifyOtp({"email": email, "otp": otp});
  }

  Future<void> resetPassword(String email, String otp, String newPassword) {
    return api.resetPassword({
      "email": email,
      "otp": otp,
      "new_password": newPassword,
    });
  }
}
