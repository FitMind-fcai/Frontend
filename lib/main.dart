import 'package:fitmind/presentation/home/manager/home_bloc.dart';
import 'package:fitmind/presentation/log/manager/log_bloc.dart';
import 'package:fitmind/presentation/plan/manager/plan_bloc.dart';
import 'package:fitmind/presentation/profile/manager/profile_bloc.dart';
import 'package:fitmind/presentation/splash_screen/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/authentication/manager/auth_bloc.dart';
import 'presentation/onboarding/screens/welcome_screen.dart';
import 'di/dependency_injections.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(
    MultiBlocProvider(
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
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    ),
  );
}
