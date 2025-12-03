import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fitmind/core/constants/app_constants.dart';
import '../../../domain/entities/user_entity.dart';
import '../manager/auth_bloc.dart';
import '../widgets/app_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  late FocusNode nameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode confirmFocusNode;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  bool showPasswordError = false;

  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  bool isFormValid = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode()..addListener(() => validateName());
    emailFocusNode = FocusNode()..addListener(() => validateEmail());
    passwordFocusNode = FocusNode()
      ..addListener(() {
        validatePassword();
        validatePasswordMismatchContainer();
      });
    confirmFocusNode = FocusNode()
      ..addListener(() {
        validateConfirmPassword();
        validatePasswordMismatchContainer();
      });
  }

  void validateName() {
    final name = nameController.text.trim();
    setState(() {
      if (name.isEmpty) {
        nameError = 'Please enter your name';
      } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(name)) {
        nameError = 'Only letters and spaces allowed';
      } else {
        nameError = null;
      }
      validateForm();
    });
  }

  void validateEmail() {
    final email = emailController.text.trim();
    setState(() {
      if (email.isEmpty) {
        emailError = 'Please enter your email';
      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
        emailError = 'Enter a valid email';
      } else {
        emailError = null;
      }
      validateForm();
    });
  }

  void validatePassword() {
    final password = passwordController.text;
    setState(() {
      if (password.isEmpty) {
        passwordError = 'Please enter your password';
      } else if (password.length < 6) {
        passwordError = 'Password must be at least 6 characters';
      } else {
        passwordError = null;
      }
      validateForm();
    });
  }

  void validateConfirmPassword() {
    final confirm = confirmPasswordController.text;
    setState(() {
      if (confirm.isEmpty) {
        confirmPasswordError = 'Please confirm your password';
      } else if (confirm != passwordController.text) {
        confirmPasswordError = 'Passwords do not match';
      } else {
        confirmPasswordError = null;
      }
      validateForm();
    });
  }

  void validatePasswordMismatchContainer() {
    setState(() {
      showPasswordError =
          confirmPasswordController.text.isNotEmpty &&
          confirmPasswordController.text != passwordController.text;
    });
  }

  void validateForm() {
    isFormValid = [
      nameError,
      emailError,
      passwordError,
      confirmPasswordError,
    ].every((e) => e == null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image and Logo
            Stack(
              children: [
                Image.asset(
                  width: double.infinity,
                  'assets/images/chest press machine full solid white background.png',
                  fit: BoxFit.cover,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.95),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/MainLogoOrange.svg',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign Up For Free',
                        style: TextStyle(
                          fontFamily: AppConstants.fontRegular,
                          fontWeight: FontWeight.w800,
                          fontSize: AppConstants.fontSizeXXL,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Quickly make your account in 1 minute',
                        style: TextStyle(
                          fontFamily: AppConstants.fontRegular,
                          fontSize: AppConstants.fontSizeL,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Name',
                      controller: nameController,
                      onChanged: (_) => validateName(),
                      errorText: nameError,
                      prefixIconPath: 'assets/images/user.png',
                      focusNode: nameFocusNode,
                    ),
                    const SizedBox(width: 16),

                    AppConstants.verticalSpaceL,

                    AppTextField(
                      label: 'Email Address',
                      controller: emailController,
                      onChanged: (_) => validateEmail(),
                      errorText: emailError,
                      keyboardType: TextInputType.emailAddress,
                      prefixIconPath: 'assets/images/Monotone email.png',
                      focusNode: emailFocusNode,
                    ),
                    AppConstants.verticalSpaceL,

                    AppTextField(
                      label: 'Password',
                      controller: passwordController,
                      onChanged: (_) {
                        validatePassword();
                        validatePasswordMismatchContainer();
                      },
                      errorText: passwordError,
                      obscureText: obscurePassword,
                      toggleObscureText: () =>
                          setState(() => obscurePassword = !obscurePassword),
                      prefixIconPath:
                          'assets/images/Monotone lock password.png',
                      focusNode: passwordFocusNode,
                    ),
                    AppConstants.verticalSpaceL,

                    AppTextField(
                      label: 'Confirm Password',
                      controller: confirmPasswordController,
                      onChanged: (_) {
                        validateConfirmPassword();
                        validatePasswordMismatchContainer();
                      },
                      obscureText: obscureConfirmPassword,
                      toggleObscureText: () => setState(
                        () => obscureConfirmPassword = !obscureConfirmPassword,
                      ),
                      prefixIconPath:
                          'assets/images/Monotone lock password.png',
                      focusNode: confirmFocusNode,
                    ),

                    if (showPasswordError) ...[
                      AppConstants.verticalSpaceS,
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Passwords don't match",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: AppConstants.bold,
                                fontFamily: AppConstants.fontRegular,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    AppConstants.verticalSpaceL,

                    // Sign Up Button
                    Container(
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
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    SignUpEvent(
                                      UserEntity(
                                        name: nameController.text.trim(),
                                        email: emailController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                      ),
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppConstants.fontRegular,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Image.asset(
                              'assets/images/Monotone arrow right.png',
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppConstants.horizontalSpaceXXL,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: AppConstants.lightTextColor,
                            fontSize: AppConstants.fontSizeL,
                            fontWeight: AppConstants.mediumBold,
                            fontFamily: AppConstants.fontRegular,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: AppConstants.primaryColor,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              decorationColor: AppConstants.primaryColor,
                              fontFamily: AppConstants.fontRegular,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppConstants.verticalSpaceM,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
