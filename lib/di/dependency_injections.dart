import 'package:fitmind/data/data_sources/remote/log_remote_data_source.dart';
import 'package:fitmind/data/data_sources/remote/plan_remote_data_source.dart';
import 'package:fitmind/domain/use_cases/log_use_cases.dart';
import 'package:fitmind/network/log_api_service.dart';
import 'package:fitmind/network/plan_api_service.dart';
import 'package:fitmind/presentation/plan/manager/plan_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../data/data_sources/local/auth_local_data_source.dart';
import '../data/data_sources/local/profile_local_data_source.dart';
import '../data/data_sources/remote/auth_remote_data_source.dart';
import '../data/data_sources/remote/profile_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/log_repository_impl.dart';
import '../data/repositories/plan_repository_impl.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/log_repository.dart';
import '../domain/repositories/plan_repository.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/use_cases/auth_use_cases.dart';
import '../domain/use_cases/plan_use_cases.dart';
import '../domain/use_cases/profile_use_cases.dart';
import '../network/auth_api_service.dart';
import '../network/profile_api_service.dart';
import '../presentation/authentication/manager/auth_bloc.dart';
import '../presentation/log/manager/log_bloc.dart';
import '../presentation/profile/manager/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Dio
  sl.registerLazySingleton<Dio>(() => Dio());

  // Retrofit API Service
  sl.registerLazySingleton<AuthApiService>(() => AuthApiService(sl()));
  sl.registerLazySingleton<ProfileApiService>(
      () => ProfileApiService(sl(), sl()));
  sl.registerLazySingleton<PlanApiService>(() => PlanApiService(sl(), sl()));
  sl.registerLazySingleton<LogApiService>(() => LogApiService(sl(), sl()));

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl());
  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<ProfileLocalDataSource>(
      () => ProfileLocalDataSourceImpl());

  sl.registerLazySingleton<PlanRemoteDataSource>(
      () => PlanRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<LogRemoteDataSource>(
      () => LogRemoteDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl()));

  sl.registerLazySingleton<PlanRepository>(() => PlanRepositoryImpl(sl()));
  sl.registerLazySingleton<LogRepository>(() => LogRepositoryImpl(sl()));

  // UseCases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SendVerificationEmailUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => GetOtpStatusUseCase(sl()));
  sl.registerLazySingleton(() => CreateProfileUseCase(sl()));
  sl.registerLazySingleton(() => CreateNutritionPreferencesUseCase(sl()));
  sl.registerLazySingleton(() => CreateWorkoutPreferencesUseCase(sl()));
  sl.registerLazySingleton(() => GetMyProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => SaveNutritionPlanUseCase(sl()));
  sl.registerLazySingleton(() => SaveWorkoutPlanUseCase(sl()));
  sl.registerLazySingleton(() => GetActiveNutritionPlanUseCase(sl()));
  sl.registerLazySingleton(() => GetNutritionPlanByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetActiveWorkoutPlanUseCase(sl()));
  sl.registerLazySingleton(() => GetWorkoutPlanByIdUseCase(sl()));
  sl.registerLazySingleton(() => DeleteNutritionPlanUseCase(sl()));
  sl.registerLazySingleton(() => DeleteWorkoutPlanUseCase(sl()));

  sl.registerLazySingleton(() => ScanMealUseCase(sl()));

  sl.registerLazySingleton(() => ScanMealVoiceUseCase(sl()));
  sl.registerLazySingleton(() => ScanWorkoutVoiceUseCase(sl()));

  sl.registerLazySingleton(() => SearchFoodsUseCase(sl()));
  sl.registerLazySingleton(() => SearchExercisesUseCase(sl()));
  sl.registerLazySingleton(() => SaveLogsUseCase(sl()));

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      sendEmailVerificationUseCase: sl(),
      localDataSource: sl(),
      checkAuthStatusUseCase: sl(),
      deleteUserUseCase: sl(),
      forgotPasswordUseCase: sl(),
      verifyOtpUseCase: sl(),
      resetPasswordUseCase: sl(),
      getOtpStatusUseCase: sl(),
      getMyProfileUseCase: sl(),
      profileLocalDataSource: sl(),
    ),
  );
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      createProfile: sl(),
      getProfile: sl(),
      updateProfile: sl(),
    ),
  );
  sl.registerFactory<PlanBloc>(
    () => PlanBloc(
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerFactory<LogBloc>(
    () => LogBloc(
      scanMealVoiceUseCase: sl(),
      scanWorkoutVoiceUseCase: sl(),
      scanMealUseCase: sl(),
      searchExercisesUseCase: sl(),
      searchFoodsUseCase: sl(),
      saveLogsUseCase: sl(),
    ),
  );
}
