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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is PasswordSuccess && state.message == "OTP verified") {
              Get.to(() => ResetPasswordScreen( email: widget.email,otp: num1+num2+num3+num4+num5,));
            } else if (state is PasswordFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            bool isLoading = state is PasswordLoading;

            return Column(
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                              BorderSide(color: AppConstants.primaryColor),
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
                AppConstants.verticalSpaceL,
                AppConstants.verticalSpaceL,AppConstants.verticalSpaceL,
                AppConstants.verticalSpaceL,


                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CommonButton(
                  title: 'Verify OTP',
                  onPressed: () {
                    _formKey.currentState!.save();
                    String otp = num1 + num2 + num3 + num4 + num5;
                    if (otp.length != 5) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter the full OTP")),
                      );
                      return;
                    }
                    context.read<AuthBloc>().add(
                      VerifyOtpEvent( widget.email,  otp),
                    );
                  },
                ),
                AppConstants.verticalSpaceM,
                CommonButton(
                  title: 'Resend OTP',
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(ForgotPasswordEvent(widget.email));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
