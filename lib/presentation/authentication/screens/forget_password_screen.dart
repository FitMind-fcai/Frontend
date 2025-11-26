import 'package:fitmind/presentation/authentication/widgets/app_form_field.dart';
import 'package:fitmind/presentation/authentication/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../manager/auth_bloc.dart';
import 'otp_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            "assets/images/BigLock.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.white.withAlpha(200)],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 300,
            left: 20,
            right: 20,
            child: Container(
              height: 342,
              width: 324,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is PasswordSuccess) {
                    Get.to(() => OtpScreen(email: emailController.text));
                  } else if (state is PasswordFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                builder: (context, state) {
                  bool isLoading = state is PasswordLoading;

                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Forget Password", style: AppConstants.heading1),
                        const SizedBox(height: 10),
                        Text(
                          "Enter your Email.",
                          textAlign: TextAlign.center,
                          style: AppConstants.bodyText,
                        ),
                        const SizedBox(height: 10),
                        AppTextField(
                          label: '',
                          controller: emailController,
                          prefixIconPath: 'assets/images/Monotone email.png',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        isLoading
                            ? const CircularProgressIndicator()
                            : CommonButton(
                                title: "Receive OTP",
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      ForgotPasswordEvent(emailController.text),
                                    );
                                  }
                                },
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
