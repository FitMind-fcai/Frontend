import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/local/auth_local_data_source.dart';
import '../data_sources/remote/auth_remote_data_source.dart';
import '../models/auth_response_mode.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl(this.remote, this.local);

  @override
  Future<AuthResponseModel> signIn(String email, String password) async {
    final userModel = await remote.signIn(email, password);
    return userModel;
  }

  @override
  Future<UserEntity> signUp(UserEntity user) async {
    final userModel = UserModel(
      name: user.name,
      age: user.age,
      email: user.email,
      password: user.password,
      token: user.token,
    );

    final registeredModel = await remote.signUp(userModel);
    await local.cacheUser(registeredModel);
    return registeredModel;
  }

  @override
  Future<void> verifyEmail(String email) async {
    await remote.verifyEmail(email);
  }
  // ✅ Added methods for splash screen
  Future<String?> getToken() async {
    return local.getCachedToken();
  }

  Future<UserModel?> fetchUserFromToken() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final user = await remote.getMe("Bearer $token"); // send x-auth-token
      return user;
    } catch (_) {
      return null;
    }
  }
  Future<void> deleteUser() async {
    await local.deleteCachedData();
  }
  @override
  Future<void> forgotPassword(String email) {
    return remote.forgotPassword(email);
  }

  @override
  Future<void> verifyOtp(String email, String otp) {
    return remote.verifyOtp(email, otp);
  }

  @override
  Future<void> resetPassword(String email, String otp, String newPassword) {
    return remote.resetPassword(email, otp, newPassword);
  }


}
