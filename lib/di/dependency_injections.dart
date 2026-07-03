import 'package:fitmind/data/data_sources/remote/log_remote_data_source.dart';
import 'package:fitmind/data/data_sources/remote/notifications_remote_data_source.dart';
import 'package:fitmind/data/data_sources/remote/plan_remote_data_source.dart';
import 'package:fitmind/domain/use_cases/log_use_cases.dart';
import 'package:fitmind/domain/use_cases/notifications_use_cases.dart';
import 'package:fitmind/network/log_api_service.dart';
import 'package:fitmind/network/plan_api_service.dart';
import 'package:fitmind/network/recommendations_api_service.dart';
import 'package:fitmind/presentation/log/manager_log_history/log_history_bloc.dart';
import 'package:fitmind/presentation/notifications/manager/notification_bloc.dart';
import 'package:fitmind/presentation/plan/manager/plan_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../core/services/fcm_service.dart';
import '../core/services/theme_cubit.dart';
import '../data/data_sources/local/auth_local_data_source.dart';
import '../data/data_sources/local/profile_local_data_source.dart';
import '../data/data_sources/remote/auth_remote_data_source.dart';
import '../data/data_sources/remote/profile_remote_data_source.dart';
import '../data/data_sources/remote/recommendations_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/log_repository_impl.dart';
import '../data/repositories/notifications_repository_impl.dart';
import '../data/repositories/plan_repository_impl.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../data/repositories/recommendations_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/log_repository.dart';
import '../domain/repositories/notifications_repository.dart';
import '../domain/repositories/plan_repository.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/repositories/recommendations_repository.dart';
import '../domain/use_cases/auth_use_cases.dart';
import '../domain/use_cases/plan_use_cases.dart';
import '../domain/use_cases/profile_use_cases.dart';
import '../domain/use_cases/recommendations_use_cases.dart';
import '../network/auth_api_service.dart';
import '../network/notifications_api_service.dart';
import '../network/profile_api_service.dart';
import '../presentation/authentication/manager/auth_bloc.dart';
import '../presentation/home/manager/home_bloc.dart';
import '../presentation/log/manager/log_bloc.dart';
import '../presentation/profile/manager/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Dio
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  // Retrofit API Service
  sl.registerLazySingleton<AuthApiService>(() => AuthApiService(sl()));
  sl.registerLazySingleton<ProfileApiService>(
      () => ProfileApiService(sl(), sl()));
  sl.registerLazySingleton<PlanApiService>(() => PlanApiService(sl(), sl()));
  sl.registerLazySingleton<LogApiService>(() => LogApiService(sl(), sl()));
  sl.registerLazySingleton(() => RecommendationsApiService(sl(), sl()));
  sl.registerLazySingleton(() => NotificationsApiService(sl(), sl()));
  sl.registerLazySingleton<FcmService>(() => FcmService());

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
  sl.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<RecommendationsRemoteDataSource>(
      () => RecommendationsRemoteDataSourceImpl(sl()));
  // Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl()));

  sl.registerLazySingleton<PlanRepository>(() => PlanRepositoryImpl(sl()));
  sl.registerLazySingleton<LogRepository>(() => LogRepositoryImpl(sl()));
  sl.registerLazySingleton<RecommendationsRepository>(
      () => RecommendationsRepositoryImpl(sl()));
  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(sl()));
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
  sl.registerLazySingleton(() => GetWorkoutDayExercisesUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserPermUseCase(sl()));
  sl.registerLazySingleton(() => ScanMealUseCase(sl()));

  sl.registerLazySingleton(() => ScanMealVoiceUseCase(sl()));
  sl.registerLazySingleton(() => ScanWorkoutVoiceUseCase(sl()));

  sl.registerLazySingleton(() => SearchFoodsUseCase(sl()));
  sl.registerLazySingleton(() => SearchExercisesUseCase(sl()));
  sl.registerLazySingleton(() => SaveLogsUseCase(sl()));
  sl.registerLazySingleton(() => GetMealsSummaryUseCase(sl()));
  sl.registerLazySingleton(() => GetMealLogsUseCase(sl()));
  sl.registerLazySingleton(() => GetWorkoutLogsUseCase(sl()));
  sl.registerLazySingleton(() => GetWeightLogsUseCase(sl()));
  sl.registerLazySingleton(() => GetHydrationLogsUseCase(sl()));
  sl.registerLazySingleton(() => GetSleepLogsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteLogUseCase(sl()));

  sl.registerLazySingleton(() => GetNextMealUseCase(sl()));
  sl.registerLazySingleton(() => GetTodayWorkoutUseCase(sl()));
  sl.registerLazySingleton(() => GetScoreUseCase(sl()));

  sl.registerLazySingleton(() => GetNotificationPreferencesUseCase(sl()));
  sl.registerLazySingleton(() => DeleteDeviceTokenUseCase(sl()));
  sl.registerLazySingleton(() => UpdateNotificationPreferencesUseCase(sl()));
  sl.registerLazySingleton(() => TriggerReminderUseCase(sl()));
  sl.registerLazySingleton(() => RegisterDeviceTokenUseCase(sl()));
  sl.registerLazySingleton(() => GetCoachingMessagesUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllCoachingMessagesReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkCoachingMessageReadUseCase(sl()));
  sl.registerLazySingleton(() => DismissCoachingMessageUseCase(sl()));

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
      deleteDeviceTokenUseCase: sl(),
      fcmService: sl(),
      registerDeviceTokenUseCase: sl(),
      deleteUserPermanentlyUseCase: sl(),
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
      getMealsSummaryUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => HomeBloc(
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerFactory(() => LogHistoryBloc(
      getMealLogs: sl(),
      getWorkoutLogs: sl(),
      getWeightLogs: sl(),
      getSleepLogs: sl(),
      getHydrationLogs: sl(),
      deleteLog: sl()));

  sl.registerFactory(() => NotificationBloc(
      getPreferences: sl(),
      updatePreferences: sl(),
      triggerReminder: sl(),
      dismissCoachingMessageUseCase: sl(),
      getCoachingMessagesUseCase: sl(),
      markAllCoachingMessagesReadUseCase: sl(),
      markCoachingMessageReadUseCase: sl()));
}
