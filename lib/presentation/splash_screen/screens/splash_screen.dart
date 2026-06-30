import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../authentication/manager/auth_bloc.dart';
import '../../home/screens/home_screen.dart';
import '../../onboarding/screens/welcome_screen.dart';
import '../../assessment/screens/assessment_screen.dart'; // adjust path
import '../../profile/manager/profile_bloc.dart'; // adjust path

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _minDurationElapsed = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _minDurationElapsed = true);
      _tryNavigate(context.read<AuthBloc>().state, context.read<ProfileBloc>().state);
    });
  }

  void _tryNavigate(AuthState authState, ProfileState profileState) {
    if (_navigated || !_minDurationElapsed) return;

    if (authState is AuthSuccess) {
      if (profileState is ProfileLoaded) {
        _navigated = true;
        Get.offAll(() => HomeScreen());
      } else if (profileState is ProfileError) {
        _navigated = true;
        Get.offAll(() => const AssessmentScreen());
      }
      // else still ProfileLoading/ProfileInitial — wait for next state
    } else if (authState is AuthInitial || authState is AuthFailure) {
      _navigated = true;
      Get.offAll(() => WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.read<ProfileBloc>().add(LoadProfileEvent());
            } else {
              _tryNavigate(state, context.read<ProfileBloc>().state);
            }
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            _tryNavigate(context.read<AuthBloc>().state, state);
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: const SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'common.loading'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}