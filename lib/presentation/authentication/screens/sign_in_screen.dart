import 'package:fitmind/core/constants/app_constants.dart';
import 'package:fitmind/presentation/authentication/screens/forget_password_screen.dart';
import 'package:fitmind/presentation/authentication/screens/sign_up_screen.dart';
import 'package:fitmind/presentation/home/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get/get_core/src/get_main.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../assessment/screens/assessment_screen.dart';
import '../manager/auth_bloc.dart';
import '../widgets/common_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Signing in...")),
          );
        }
        if (state is AuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        }
        if (state is AuthSuccessNoProfile) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AssessmentScreen()),
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
                          isDark ? colorScheme.surface : Colors.white,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 150,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          'auth.sign_in_title'.tr(),
                          style: TextStyle(
                            fontFamily: AppConstants.fontRegular,
                            fontWeight: FontWeight.w800,
                            fontSize: AppConstants.fontSizeXXL,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          'auth.sign_in_subtitle'.tr(),
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeL,
                            fontFamily: AppConstants.fontRegular,
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
                      // Email Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'auth.email_label'.tr(),
                            style: TextStyle(
                              fontFamily: AppConstants.fontRegular,
                              fontSize: AppConstants.fontSizeM,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : AppConstants.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              fontFamily: AppConstants.fontRegular,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: ImageIcon(
                                const AssetImage(
                                    'assets/images/Monotone email.png'),
                                color: isDark
                                    ? Colors.white54
                                    : AppConstants.secondaryColor,
                              ),
                              filled: true,
                              fillColor: isDark
                                  ? colorScheme.surfaceContainerHighest
                                  : const Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFF8C42),
                                  width: 2.5,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'auth.email_required'.tr();
                              }
                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return 'auth.email_invalid'.tr();
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      AppConstants.verticalSpaceL,

                      // Password Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'auth.password_label'.tr(),
                            style: TextStyle(
                              fontFamily: AppConstants.fontRegular,
                              fontSize: AppConstants.fontSizeM,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : AppConstants.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            style: TextStyle(
                              fontFamily: AppConstants.fontRegular,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: ImageIcon(
                                const AssetImage(
                                    'assets/images/Monotone lock password.png'),
                                color: isDark
                                    ? Colors.white54
                                    : AppConstants.secondaryColor,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: isDark ? Colors.white38 : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(
                                      () => obscurePassword = !obscurePassword);
                                },
                              ),
                              filled: true,
                              fillColor: isDark
                                  ? colorScheme.surfaceContainerHighest
                                  : const Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFF8C42),
                                  width: 2.5,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return'auth.password_required'.tr();
                              }
                              if (value.length < 6) {
                                return 'auth.password_min_length'.tr();
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      AppConstants.verticalSpaceL,

                      CommonButton(
                        title: 'auth.sign_in'.tr(),
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                SignInEvent(
                                  emailController.text,
                                  passwordController.text,
                                ),
                              );
                        },
                      ),
                      AppConstants.horizontalSpaceXXL,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'auth.no_account'.tr(),
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
                            onTap: () => Get.off(() => SignUpScreen()),
                            child: Text(
                              'auth.sign_up'.tr(),
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
                      GestureDetector(
                        onTap: () => Get.to(() => ForgetPasswordScreen()),
                        child: Text(
                          'auth.forget_password'.tr(),
                          style: TextStyle(
                            color: AppConstants.primaryColor,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            decorationColor: AppConstants.primaryColor,
                            fontFamily: AppConstants.fontRegular,
                          ),
                        ),
                      ),
                      AppConstants.verticalSpaceM,
                      Center(
                        child: SvgPicture.asset(
                          'assets/images/MainLogoOrange.svg',
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
