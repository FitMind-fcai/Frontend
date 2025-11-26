import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/data_sources/local/auth_local_data_source.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/auth_use_cases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SendVerificationEmailUseCase sendEmailVerificationUseCase;
  final AuthLocalDataSource localDataSource;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

// ✅ add local storage

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.sendEmailVerificationUseCase,
    required this.localDataSource,
    required this.checkAuthStatusUseCase,
    required this.deleteUserUseCase,
    required this.forgotPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
  }) : super(AuthInitial()) {
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SendVerificationEmailEvent>(_onSendVerificationEmail);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResetPasswordEvent>(_onResetPassword);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    print("➡️ Starting sign-in request...");
    print("📧 Email: ${event.email}, 🔑 Password: ${event.password}");

    try {
      final authResponse = await signInUseCase(event.email, event.password);

      print("✅ SUCCESS RESPONSE RAW: $authResponse");
      print("✅ SUCCESS RESPONSE JSON: ${authResponse.toJson()}");

      await localDataSource.cacheUser(authResponse.user as UserModel);
      await localDataSource.cacheToken(authResponse.token);

      print("💾 Saved user & token locally");

      emit(AuthSuccess(authResponse.user));
    } catch (e, stack) {
      print("❌ ERROR: $e");
      print("📌 STACK: $stack");
      emit(AuthFailure(e.toString()));
    }
  }
  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signUpUseCase(event.user);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSendVerificationEmail(SendVerificationEmailEvent event,
      Emitter<AuthState> emit,) async {
    await sendEmailVerificationUseCase(event.email);
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event,
      Emitter<AuthState> emit,) async {
    emit(AuthLoading());

    final user = await checkAuthStatusUseCase();

    if (user != null) {
      emit(AuthSuccess(user));
    } else {
      emit(AuthInitial());
    }
  }
// ---------------------- FORGOT PASSWORD ----------------------
  Future<void> _onForgotPassword(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(PasswordLoading());
    try {
      await forgotPasswordUseCase(event.email);
      emit(PasswordSuccess("Forgot password email sent"));
    } catch (e) {
      emit(PasswordFailure(e.toString()));
    }
  }

// ---------------------- VERIFY OTP ----------------------
  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(PasswordLoading());
    try {
      await verifyOtpUseCase(event.email, event.otp);
      emit(PasswordSuccess("OTP verified"));
    } catch (e) {
      emit(PasswordFailure(e.toString()));
    }
  }

// ---------------------- RESET PASSWORD ----------------------
  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(PasswordLoading());
    try {
      await resetPasswordUseCase(event.email, event.otp, event.newPassword);
      emit(PasswordSuccess("Password reset successful"));
    } catch (e) {
      emit(PasswordFailure(e.toString()));
    }
  }
  Future<void> _onDeleteUser(
      DeleteUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await deleteUserUseCase();


    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
