import 'dart:async';

import 'package:fitmind/presentation/authentication/screens/reset_password_screen.dart';
import 'package:fitmind/presentation/authentication/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

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
        }
      });
    });
  }

  void _handleVerifyOtp() {
    _verifyAttempts++;

    if (_verifyAttempts > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('auth.otp_max_attempts'.tr()),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    _formKey.currentState!.save();
    String otp = num1 + num2 + num3 + num4 + num5;
    if (otp.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('auth.otp_incomplete'.tr())),
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

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _checkOtpStatus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : null,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is OtpStatusState) {
              final canRequest = state.status['can_request'] ?? false;
              final remainingSeconds = state.status['remaining_seconds'] ?? 0;

              setState(() {
                _isChecking = false;
              });

              if (!canRequest && remainingSeconds > 0) {
                _startTimer(remainingSeconds);
                _startResendTimer(remainingSeconds);
              }
            } else if (state is PasswordSuccess &&
                state.message == "OTP verified") {
              _timer?.cancel();
              _resendTimer?.cancel();
              Get.to(
                () => ResetPasswordScreen(
                  email: widget.email,
                  otp: num1 + num2 + num3 + num4 + num5,
                ),
              );
            } else if (state is PasswordSuccess &&
                state.message == "Forgot password email sent") {
              setState(() {
                _verifyAttempts = 0;
                num1 = '';
                num2 = '';
                num3 = '';
                num4 = '';
                num5 = '';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('auth.otp_resent_success'.tr())),
              );
            } else if (state is PasswordFailure) {
              if (_lastShownError != state.error) {
                _lastShownError = state.error;

                if (state.error.contains('remaining_seconds')) {
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
                    Text(
                      'auth.otp_title'.tr(),
                      style: AppConstants.heading1.copyWith(
                        color: isDark ? Colors.white : null,
                      ),
                    ),
                    AppConstants.verticalSpaceS,
                    Text(
                      'auth.otp_subtitle'.tr(),
                      style: AppConstants.bodyText.copyWith(
                        color: isDark ? Colors.white60 : null,
                      ),
                    ),
                    AppConstants.verticalSpaceXL,
                    Form(
                      key: _formKey,
                      child: Directionality(
                        textDirection: ui.TextDirection.ltr,
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
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: isDark
                                      ? colorScheme.surfaceContainerHighest
                                      : const Color(0xFFF5F5F5),
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
                    ),
                    AppConstants.verticalSpaceM,
                    if (_verifyAttempts > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'auth.otp_attempts'.tr(namedArgs: {'count': '$_verifyAttempts'}),
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                _verifyAttempts >= 3 ? Colors.red : Colors.grey,
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
                            'auth.otp_resend'.tr(),
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
                            'auth.otp_resend_countdown'.tr(namedArgs: {'count': '$_remainingSeconds'}),
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
                          title: 'auth.otp_verify'.tr(),
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
