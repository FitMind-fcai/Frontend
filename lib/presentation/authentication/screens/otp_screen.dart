import 'dart:async';

import 'package:fitmind/presentation/authentication/screens/reset_password_screen.dart';
import 'package:fitmind/presentation/authentication/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../manager/auth_bloc.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();

  String num1 = '', num2 = '', num3 = '', num4 = '', num5 = '';
  String? _lastShownError;
  int _remainingTime = 0;
  Timer? _timer;
  bool _isChecking = true;
  int _verifyAttempts = 0;
  int _remainingSeconds = 0;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    // Check OTP status when screen loads
    _checkOtpStatus();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _checkOtpStatus() {
    context.read<AuthBloc>().add(CheckOtpStatusEvent(widget.email));
  }

  void _startTimer(int seconds) {
    _remainingTime = seconds;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;
        if (_remainingTime <= 0) {
          timer.cancel();
          _checkOtpStatus();
        }
      });
    });
  }

  void _startResendTimer(int seconds) {
    _remainingSeconds = seconds;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          timer.cancel();
          // Reset attempts when timer ends
        }
      });
    });
  }

  void _handleVerifyOtp() {
    _verifyAttempts++;

    if (_verifyAttempts > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum verification attempts reached. Please try again later.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    _formKey.currentState!.save();
    String otp = num1 + num2 + num3 + num4 + num5;
    if (otp.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the full OTP")),
      );
      return;
    }
    context.read<AuthBloc>().add(
      VerifyOtpEvent(widget.email, otp),
    );
  }

  void _handleResendOtp() {
    _verifyAttempts = 0;
    context.read<AuthBloc>().add(
      ForgotPasswordEvent(widget.email),
    );

    // Fetch OTP status after resending to get updated remaining seconds
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _checkOtpStatus();

    }});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is OtpStatusState) {
              // Check if OTP is ready - using correct field names from API
              final canRequest = state.status['can_request'] ?? false;
              final remainingSeconds = state.status['remaining_seconds'] ?? 0;

              setState(() {
                _isChecking = false;
              });

              if (!canRequest && remainingSeconds > 0) {
                _startTimer(remainingSeconds);
                _startResendTimer(remainingSeconds);
              }
            } else if (state is PasswordSuccess && state.message == "OTP verified") {
              _timer?.cancel();
              _resendTimer?.cancel();
              Get.to(
                () => ResetPasswordScreen(
                  email: widget.email,
                  otp: num1 + num2 + num3 + num4 + num5,
                ),
              );
            } else if (state is PasswordSuccess && state.message == "Forgot password email sent") {
              // Reset attempts when resend is successful
              setState(() {
                _verifyAttempts = 0;
                num1 = '';
                num2 = '';
                num3 = '';
                num4 = '';
                num5 = '';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('OTP resent successfully')),
              );
            } else if (state is PasswordFailure) {
              if (_lastShownError != state.error) {
                _lastShownError = state.error;

                // Check if error contains remaining_seconds (from daily limit or rate limit)
                if (state.error.contains('remaining_seconds')) {
                  // Extract remaining_seconds from error string
                  final regex = RegExp(r'remaining_seconds["\s:]*(\d+)');
                  final match = regex.firstMatch(state.error);
                  if (match != null) {
                    final seconds = int.parse(match.group(1)!);
                    setState(() {
                      _remainingSeconds = seconds;
                    });
                    _startResendTimer(seconds);
                  }
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            }
          },
          builder: (context, state) {
            bool isLoading = state is PasswordLoading;
            bool isVerifyDisabled = _verifyAttempts >= 4 || isLoading;
            bool isResendDisabled = _remainingSeconds > 0;

            // Show loading while checking OTP status
            if (_isChecking) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppConstants.primaryColor,
                ),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('OTP Code', style: AppConstants.heading1),
                    AppConstants.verticalSpaceS,
                    Text(
                      'We have sent an OTP to the email address provided.',
                      style: AppConstants.bodyText,
                    ),
                    AppConstants.verticalSpaceXL,
                    Form(
                      key: _formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (index) {
                          return SizedBox(
                            height: 64,
                            width: 68,
                            child: TextFormField(
                              onSaved: (val) {
                                switch (index) {
                                  case 0:
                                    num1 = val ?? '';
                                    break;
                                  case 1:
                                    num2 = val ?? '';
                                    break;
                                  case 2:
                                    num3 = val ?? '';
                                    break;
                                  case 3:
                                    num4 = val ?? '';
                                    break;
                                  case 4:
                                    num5 = val ?? '';
                                    break;
                                }
                              },
                              onChanged: (value) {
                                if (value.length == 1 && index < 4) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              textAlign: TextAlign.center,
                              enabled: true,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF5F5F5),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppConstants.primaryColor,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    AppConstants.verticalSpaceM,
                    // Show attempts counter if user has tried
                    if (_verifyAttempts > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Attempts: $_verifyAttempts/4',
                          style: TextStyle(
                            fontSize: 12,
                            color: _verifyAttempts >= 3 ? Colors.red : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: isResendDisabled ? null : _handleResendOtp,
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(
                              color: isResendDisabled
                                  ? Colors.grey
                                  : AppConstants.primaryColor,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              decorationColor: isResendDisabled
                                  ? Colors.grey
                                  : AppConstants.primaryColor,
                              fontFamily: AppConstants.fontRegular,
                            ),
                          ),
                        ),
                        if (_remainingSeconds > 0) ...[
                          const SizedBox(width: 8),
                          Text(
                            '($_remainingSeconds s)',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFFF9800),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppConstants.primaryColor,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                          left: AppConstants.paddingM,
                          right: AppConstants.paddingM,
                          bottom: AppConstants.paddingL,
                        ),
                        child: CommonButton(
                          title: 'Verify OTP',
                          onPressed: isVerifyDisabled ? null : _handleVerifyOtp,
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}

