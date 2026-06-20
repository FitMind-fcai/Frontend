import 'package:fitmind/presentation/authentication/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fitmind/core/constants/app_constants.dart';
import '../../../domain/entities/user_entity.dart';
import '../manager/auth_bloc.dart';
import '../widgets/app_form_field.dart';
import 'package:easy_localization/easy_localization.dart';

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
        nameError = 'auth.name_required'.tr();
      } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(name)) {
        nameError = 'auth.name_invalid'.tr();
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
        emailError = 'auth.email_required'.tr();
        ;
      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
        emailError = 'auth.email_invalid'.tr();
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
        passwordError = 'auth.password_required'.tr();
      } else if (password.length < 6) {
        passwordError = 'auth.password_min_length'.tr();
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
        confirmPasswordError = 'auth.confirm_password_required'.tr();
      } else if (confirm != passwordController.text) {
        confirmPasswordError = 'auth.passwords_no_match'.tr();
      } else {
        confirmPasswordError = null;
      }
      validateForm();
    });
  }

  void validatePasswordMismatchContainer() {
    setState(() {
      showPasswordError = confirmPasswordController.text.isNotEmpty &&
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final isRtl = context.locale.languageCode == 'ar'; // Check if the current locale is Arabic (RTL)


    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignUpSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => SignInScreen()),
          );
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? colorScheme.surface : Colors.white,
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
                          Colors.transparent,
                          isDark
                              ? colorScheme.surface.withOpacity(0.95)
                              : Colors.white.withOpacity(0.95),
                          isDark ? colorScheme.surface : Colors.white,
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
                          'auth.sign_up_title'.tr(),
                          style: TextStyle(
                            fontFamily: AppConstants.fontRegular,
                            fontWeight: FontWeight.w800,
                            fontSize: AppConstants.fontSizeXXL,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'auth.sign_up_subtitle'.tr(),
                          style: TextStyle(
                            fontFamily: AppConstants.fontRegular,
                            fontSize: AppConstants.fontSizeL,
                            color: isDark ? Colors.white60 : null,
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
                        label: 'auth.name_label'.tr(),
                        controller: nameController,
                        onChanged: (_) => validateName(),
                        errorText: nameError,
                        prefixIconPath: 'assets/images/user.png',
                        focusNode: nameFocusNode,
                      ),
                      AppConstants.verticalSpaceL,

                      AppTextField(
                        label: 'auth.email_label'.tr(),
                        controller: emailController,
                        onChanged: (_) => validateEmail(),
                        errorText: emailError,
                        keyboardType: TextInputType.emailAddress,
                        prefixIconPath: 'assets/images/Monotone email.png',
                        focusNode: emailFocusNode,
                      ),
                      AppConstants.verticalSpaceL,

                      AppTextField(
                        label: 'auth.password_label'.tr(),
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
                        label: 'auth.confirm_password_label'.tr(),
                        controller: confirmPasswordController,
                        onChanged: (_) {
                          validateConfirmPassword();
                          validatePasswordMismatchContainer();
                        },
                        obscureText: obscureConfirmPassword,
                        toggleObscureText: () => setState(
                          () =>
                              obscureConfirmPassword = !obscureConfirmPassword,
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
                              Text(
                                'auth.passwords_no_match'.tr(),
                                style: const TextStyle(
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
                              ? isDark
                                  ? AppConstants.primaryColor
                                  : AppConstants.secondaryColor
                              : isDark
                                  ? Colors.white12
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
                                              email:
                                                  emailController.text.trim(),
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
                              Text(
                                'auth.sign_up'.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppConstants.fontRegular,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Transform.flip(
                                flipX: isRtl, // Flip the arrow horizontally if the locale is RTL
                                child: Image.asset(
                                  'assets/images/Monotone arrow right.png',
                                  width: 24,
                                  height: 24,
                                ),
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
                            'auth.already_have_account'.tr(),
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white60
                                  : AppConstants.lightTextColor,
                              fontSize: AppConstants.fontSizeL,
                              fontWeight: AppConstants.mediumBold,
                              fontFamily: AppConstants.fontRegular,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'auth.sign_in'.tr(),
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
      ),
    );
  }
}
