part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  SignInEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvent {
  final UserEntity user;
  SignUpEvent(this.user);
}

class SendVerificationEmailEvent extends AuthEvent {
  final String email;
  SendVerificationEmailEvent(this.email);
}

class CheckAuthStatusEvent extends AuthEvent {}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent(this.email);
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;

  VerifyOtpEvent(this.email, this.otp);
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;

  ResetPasswordEvent(this.email, this.otp, this.newPassword);
}
class DeleteUserEvent extends AuthEvent {
  DeleteUserEvent();
}
