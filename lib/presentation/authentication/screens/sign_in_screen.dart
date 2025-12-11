import 'package:fitmind/core/constants/app_constants.dart';
import 'package:fitmind/presentation/authentication/screens/forget_password_screen.dart';
import 'package:fitmind/presentation/authentication/screens/sign_up_screen.dart';
import 'package:fitmind/presentation/home/screens/home_screen.dart';
import 'package:fitmind/presentation/plan/screens/plan_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
      if (state is AuthLoading) {
        // ✅ Optional loading UI
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signing in...")),
        );
      }

      if (state is AuthSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PlanSelectionScreen()),
        );
      }

      if (state is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    },

      child:Scaffold(
      backgroundColor: Colors.white,
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
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white,
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
                        'Sign in to FitMind',
                        style: TextStyle(
                          fontFamily: AppConstants.fontRegular,
                          fontWeight: FontWeight.w800,

                          fontSize: AppConstants.fontSizeXXL,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Let’s personalize your fitness with AI',
                        style: TextStyle(fontSize: AppConstants.fontSizeL,
                          fontFamily: AppConstants.fontRegular,

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
                          ' Email Address',
                          style: TextStyle(
                            fontFamily: AppConstants.fontRegular,
                            fontSize: AppConstants.fontSizeM,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,

                          style: const TextStyle(
                            fontFamily: AppConstants.fontRegular,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: ImageIcon(
                              const AssetImage(
                                'assets/images/Monotone email.png',
                              ),
                              color: AppConstants.secondaryColor,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
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
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                              return 'Enter a valid email';
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
                          ' Password',
                          style: TextStyle(
                            fontFamily: AppConstants.fontRegular,
                            fontSize: AppConstants.fontSizeM,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          style: const TextStyle(
                            fontFamily: AppConstants.fontRegular,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: ImageIcon(
                              const AssetImage(
                                'assets/images/Monotone lock password.png',
                              ),
                              color: AppConstants.secondaryColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
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
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    AppConstants.verticalSpaceL,

                    // Login Button
                    CommonButton(
                      title: 'Sign In',
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          SignInEvent(
                            emailController.text,
                            passwordController.text,
                          ),
                        );
                      }
                    ),
                    AppConstants.horizontalSpaceXXL,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            color: AppConstants.lightTextColor,
                            fontSize: AppConstants.fontSizeL,
                            fontWeight:AppConstants.mediumBold,

                            fontFamily: AppConstants.fontRegular,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => SignUpScreen());
                          },
                          child: Text(
                            'Sign Up',
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
                      onTap: () {
                        Get.to(()=>ForgetPasswordScreen());
                      },
                      child: Text(
                        'Forget Password',
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
      ));
  }
}


