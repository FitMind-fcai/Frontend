import '../../data/models/auth_response_mode.dart';
import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class SignInUseCase {
  final AuthRepository repository;
  SignInUseCase(this.repository);

  Future<AuthResponseModel> call(String email, String password) {
    return repository.signIn(email, password);
  }
}
class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<UserEntity> call(UserEntity user) {
    return repository.signUp(user);
  }
}

class SendVerificationEmailUseCase {
  final AuthRepository repository;

  SendVerificationEmailUseCase(this.repository);

  Future<void> call(String email) {
    return repository.verifyEmail(email);
  }
}

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<UserEntity?> call() async {
    return await repository.fetchUserFromToken();
  }
}
class DeleteUserUseCase {
  final AuthRepository repository;

  DeleteUserUseCase(this.repository);

  Future<void> call() {
    return repository.deleteUser();
  }
}
class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> call(String email) {
    return repository.forgotPassword(email);
  }
}
class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<void> call(String email, String otp) {
    return repository.verifyOtp(email, otp);
  }
}
class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> call(String email, String otp, String newPassword) {
    return repository.resetPassword(email, otp, newPassword);
  }
}
class GetOtpStatusUseCase {
  final AuthRepository repository;

  GetOtpStatusUseCase(this.repository);

  Future<Map<String, dynamic>> call(String email) {
    return repository.getOtpStatus(email);
  }

}
class DeleteUserPermUseCase {
  final AuthRepository repository;
  DeleteUserPermUseCase(this.repository);
  Future<void> call(String password) => repository.deleteUserPerm(password);
}