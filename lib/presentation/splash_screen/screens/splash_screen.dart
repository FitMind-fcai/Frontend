import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../authentication/manager/auth_bloc.dart';
import '../../home/screens/home_screen.dart';
import '../../onboarding/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger auth check
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (!mounted) return;

        // Minimum splash duration
        await Future.delayed(const Duration(seconds: 2));

        if (state is AuthSuccess) {
          // ✅ User is logged in → go to Home
          Get.offAll(() => HomeScreen());
        } else if (state is AuthInitial || state is AuthFailure) {
          // ❌ Not logged in → go to Welcome
          Get.offAll(() => WelcomeScreen());
        }
      },
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
              const Text(
                "Loading...",
                style: TextStyle(
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
