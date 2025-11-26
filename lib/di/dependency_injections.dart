import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../data/data_sources/local/auth_local_data_source.dart';
import '../data/data_sources/remote/auth_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/use_cases/auth_use_cases.dart';
import '../network/auth_api_service.dart';
import '../presentation/authentication/manager/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Dio
  sl.registerLazySingleton<Dio>(() => Dio());

  // Retrofit API Service
  sl.registerLazySingleton<AuthApiService>(() => AuthApiService(sl()));

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(
          () => AuthLocalDataSourceImpl());

  // Repository
  sl.registerLazySingleton<AuthRepository>(() =>
      AuthRepositoryImpl(sl(), sl()));

  // UseCases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SendVerificationEmailUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));

  sl.registerFactory<AuthBloc>(
        () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      sendEmailVerificationUseCase: sl(), localDataSource: sl(), checkAuthStatusUseCase: sl(),deleteUserUseCase: sl(),forgotPasswordUseCase: sl(),verifyOtpUseCase: sl(),resetPasswordUseCase: sl(),

    ),
  );
}