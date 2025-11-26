part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess(this.user);
}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
class PasswordSuccess extends AuthState {
  final String message; // optional, e.g., "OTP verified", "Password reset"
  PasswordSuccess([this.message = "Success"]);
}

class PasswordFailure extends AuthState {
  final String error;
  PasswordFailure(this.error);

}
class PasswordLoading extends AuthState {}

class AuthLoggedOut extends AuthState {}
