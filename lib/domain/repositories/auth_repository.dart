
import '../../data/models/auth_response_mode.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Sign in with email & password, returns the logged-in user
  Future<AuthResponseModel> signIn(String email, String password);

  /// Sign up a new user, returns the registered user
  Future<UserEntity> signUp(UserEntity user);

  /// Send verification email
  Future<void> verifyEmail(String email);

  /// Check if a user is logged in (token exists in local storage)


  /// Get token from local storage
  Future<String?> getToken();

  /// Fetch user from token via API (for splash screen)
  Future<UserEntity?> fetchUserFromToken();
  Future<void> deleteUser();
  Future<void> forgotPassword(String email);
  Future<void> verifyOtp(String email, String otp);
  Future<void> resetPassword(String email, String otp, String newPassword);
  Future<Map<String, dynamic>> getOtpStatus(String email);

}