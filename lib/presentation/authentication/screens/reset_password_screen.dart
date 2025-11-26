import 'package:fitmind/presentation/authentication/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../core/constants/app_constants.dart';
import '../manager/auth_bloc.dart';
import '../widgets/app_form_field.dart';
import '../widgets/common_button.dart';
import 'forget_password_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({Key? key, required this.email, required this.otp})
      : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  late FocusNode passwordFocus;
  late FocusNode confirmFocus;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  String? passwordError;
  String? confirmPasswordError;

  bool showPasswordMismatch = false;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    passwordFocus = FocusNode()..addListener(() => validatePassword());
    confirmFocus = FocusNode()
      ..addListener(() {
        validateConfirmPassword();
        validateMismatch();
      });
  }

  void validateForm() {
    setState(() {
      isFormValid = passwordError == null &&
          confirmPasswordError == null &&
          !showPasswordMismatch &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty;
    });
  }

  void validatePassword() {
    final password = passwordController.text.trim();
    setState(() {
      if (password.isEmpty) {
        passwordError = 'Please enter your password';
      } else if (password.length < 6) {
        passwordError = 'Password must be at least 6 characters';
      } else {
        passwordError = null;
      }
    });
    validateMismatch();
    validateForm();
  }

  void validateConfirmPassword() {
    final confirm = confirmPasswordController.text.trim();
    setState(() {
      if (confirm.isEmpty) {
        confirmPasswordError = 'Please confirm your password';
      } else if (confirm != passwordController.text.trim()) {
        confirmPasswordError = 'Passwords do not match';
      } else {
        confirmPasswordError = null;
      }
    });
    validateMismatch();
    validateForm();
  }

  void validateMismatch() {
    setState(() {
      showPasswordMismatch =
          confirmPasswordController.text.isNotEmpty &&
              confirmPasswordController.text != passwordController.text;
    });
    validateForm();
  }

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
                  colors: [
                    Colors.transparent,
                    Colors.white.withAlpha(200),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 260,
            left: 20,
            right: 20,
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is PasswordSuccess &&
                    state.message == "Password reset successful") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password reset successful")),
                  );
                  Get.offAll(() => SignInScreen());
                } else if (state is PasswordFailure) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                bool isLoading = state is PasswordLoading;
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Reset Password", style: AppConstants.heading1),
                      const SizedBox(height: 6),
                      Text(
                        "Enter your new password below.",
                        textAlign: TextAlign.center,
                        style: AppConstants.bodyText,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        label: 'New Password',
                        controller: passwordController,
                        onChanged: (_) => validatePassword(),
                        errorText: passwordError,
                        obscureText: obscurePassword,
                        toggleObscureText: () =>
                            setState(() => obscurePassword = !obscurePassword),
                        prefixIconPath: 'assets/images/Monotone lock password.png',
                        focusNode: passwordFocus,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Confirm Password',
                        controller: confirmPasswordController,
                        onChanged: (_) => validateConfirmPassword(),
                        errorText: confirmPasswordError,
                        obscureText: obscureConfirmPassword,
                        toggleObscureText: () => setState(
                                () => obscureConfirmPassword = !obscureConfirmPassword),
                        prefixIconPath: 'assets/images/Monotone lock password.png',
                        focusNode: confirmFocus,
                      ),
                      const SizedBox(height: 24),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isFormValid
                              ? AppConstants.secondaryColor
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: isFormValid
                              ? () {
                            context.read<AuthBloc>().add(
                              ResetPasswordEvent(
                                widget.email,
                                 widget.otp,
                                passwordController.text.trim(),
                              ),
                            );
                          }
                              : null,
                          child: const Text(
                            "Reset Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppConstants.fontRegular,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
