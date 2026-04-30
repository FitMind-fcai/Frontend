import 'package:bloc/bloc.dart';

import '../../../data/data_sources/local/auth_local_data_source.dart';
import '../../../data/data_sources/local/profile_local_data_source.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/auth_use_cases.dart';
import '../../../domain/use_cases/profile_use_cases.dart';
import '../../../network/profile_api_service.dart';

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
  final GetOtpStatusUseCase getOtpStatusUseCase;
  final ProfileLocalDataSource profileLocalDataSource;
  final GetMyProfileUseCase getMyProfileUseCase;

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
    required this.getOtpStatusUseCase,
    required this.profileLocalDataSource,
    required this.getMyProfileUseCase,
  }) : super(AuthInitial()) {
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SendVerificationEmailEvent>(_onSendVerificationEmail);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResetPasswordEvent>(_onResetPassword);
    on<DeleteUserEvent>(_onDeleteUser);
    on<CheckOtpStatusEvent>(_onCheckOtpStatus);
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final authResponse = await signInUseCase(event.email, event.password);

      await localDataSource.cacheUser(authResponse.user);
      await localDataSource.cacheToken(authResponse.token);

      final profile = await getMyProfileUseCase();

      if (profile != null) {
        await profileLocalDataSource.cacheProfile(profile);
        emit(AuthSuccess(authResponse.user));
      } else {
        emit(AuthSuccessNoProfile(authResponse.user));
      }

    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signUpUseCase(event.user);
      emit(AuthSignUpSuccess());
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
  Future<void> _onForgotPassword(ForgotPasswordEvent event,
      Emitter<AuthState> emit) async {
    print('📧 ForgotPasswordEvent triggered for: ${event.email}');
    emit(PasswordLoading());
    try {
      print('🔄 Calling forgotPasswordUseCase...');
      await forgotPasswordUseCase(event.email);
      print('✅ ForgotPassword successful, emitting PasswordSuccess');
      emit(PasswordSuccess("Forgot password email sent"));
    } catch (e) {
      print('❌ ForgotPassword error: $e');

      String errorMessage = e.toString();

      // Extract message from error if it's a map
      if (e is Map) {
        errorMessage = e['message'] ?? e.toString();
      }

      emit(PasswordFailure(errorMessage));
    }
  }

// ---------------------- VERIFY OTP ----------------------
  Future<void> _onVerifyOtp(VerifyOtpEvent event,
      Emitter<AuthState> emit) async {
    emit(PasswordLoading());
    try {
      await verifyOtpUseCase(event.email, event.otp);
      emit(PasswordSuccess("OTP verified"));
    } catch (e) {
      emit(PasswordFailure(e.toString()));
    }
  }

// ---------------------- RESET PASSWORD ----------------------
  Future<void> _onResetPassword(ResetPasswordEvent event,
      Emitter<AuthState> emit) async {
    emit(PasswordLoading());
    try {
      await resetPasswordUseCase(event.email, event.otp, event.newPassword);
      emit(PasswordSuccess("Password reset successful"));
    } catch (e) {
      emit(PasswordFailure(e.toString()));
    }
  }

  Future<void> _onDeleteUser(
      DeleteUserEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await deleteUserUseCase();
      emit(AuthInitial()); // ← add this
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onCheckOtpStatus(CheckOtpStatusEvent event,
      Emitter<AuthState> emit) async {
    try {
      final status = await getOtpStatusUseCase(event.email);
      emit(OtpStatusState(status));
    } catch (e) {
      print('❌ CheckOtpStatus error: $e');
      emit(AuthFailure("Unable to check OTP status"));
    }
  }
}
