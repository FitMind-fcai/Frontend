import 'package:fitmind/presentation/home/manager/home_bloc.dart';
import 'package:fitmind/presentation/log/manager/log_bloc.dart';
import 'package:fitmind/presentation/log/manager_log_history/log_history_bloc.dart';
import 'package:fitmind/presentation/plan/manager/plan_bloc.dart';
import 'package:fitmind/presentation/profile/manager/profile_bloc.dart';
import 'package:fitmind/presentation/splash_screen/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/app_theme.dart';
import 'presentation/authentication/manager/auth_bloc.dart';
import 'presentation/onboarding/screens/welcome_screen.dart';
import 'di/dependency_injections.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await di.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (_) => di.sl<AuthBloc>(),
              ),
              BlocProvider<ProfileBloc>(
                create: (_) => di.sl<ProfileBloc>(),
              ),
              BlocProvider<PlanBloc>(
                create: (_) => di.sl<PlanBloc>(),
              ),
              BlocProvider<LogBloc>(
                create: (_) => di.sl<LogBloc>(),
              ),
              BlocProvider<HomeBloc>(
                create: (_) => di.sl<HomeBloc>(),
              ),
              BlocProvider<LogHistoryBloc>(
                create: (_) => di.sl<LogHistoryBloc>(),
              ),

            ],
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: SplashScreen(),
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: ThemeMode.system,
            ),
          );
        },
      ),
    ),
  );
}