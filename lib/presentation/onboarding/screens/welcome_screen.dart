import 'package:fitmind/core/constants/app_constants.dart';
import 'package:fitmind/presentation/authentication/screens/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get/get_core/src/get_main.dart';
import 'package:easy_localization/easy_localization.dart';


import 'onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar'; // Check if the current locale is Arabic (RTL)
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/WelcomeImage.png'), // Your image path
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Center(
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    const SizedBox(height: 400,),
                    Image.asset('assets/images/MainLogo.png',height: 150,),
                    Text(
                      'welcome.title'.tr(),
                      style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800,fontFamily: 'WorkSans' ),
                    ),
                    Text('welcome.subtitle'.tr(),
                      style: TextStyle(color: Colors.white, fontSize: 18,fontFamily: 'WorkSans' ),),
                    const SizedBox(height: 30,),
                    Container(
                      width: 207,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Color(0xFFF97316),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => OnboardingScreen());

                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'welcome.get_started'.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'WorkSans',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Transform.flip(
                              flipX: isRtl, // Flip the icon horizontally if in RTL mode
                              child: Image.asset(
                                'assets/images/Monotone arrow right.png', // replace with your icon path
                                width: 24,
                                height: 24,
                              ),
                            ),


                            // space between icon and text

                          ],
                        ),

                      ),
                    ),
                    SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'welcome.already_have_account'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'WorkSans',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => SignInScreen()),
                            );
                          },
                          child: Text(
                            'welcome.sign_in'.tr(),
                            style: TextStyle(
                              color: Color(0xFFF97316),
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              decorationColor: AppConstants.primaryColor,
                              fontFamily: 'WorkSans',
                            ),
                          ),

                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    IconButton(
                      icon: const Icon(Icons.language_rounded, color: AppConstants.primaryColor),
                      onPressed: () => _showLanguagePicker(context),
                    ),


                  ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}

void _showLanguagePicker(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    backgroundColor: isDark ? const Color(0xFF1C1C2E) : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'account_settings.choose_language'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('English'),
                trailing: context.locale.languageCode == 'en'
                    ? const Icon(Icons.check_rounded, color: Color(0xFF3A7BFF))
                    : null,
                onTap: () async {
                  Navigator.pop(context);
                  await context.setLocale(const Locale('en'));
                  Get.updateLocale(const Locale('en'));
                },
              ),
              ListTile(
                title: const Text('العربية'),
                trailing: context.locale.languageCode == 'ar'
                    ? const Icon(Icons.check_rounded, color: Color(0xFF3A7BFF))
                    : null,
                onTap: () async {
                  Navigator.pop(context);
                  await context.setLocale(const Locale('ar'));
                  Get.updateLocale(const Locale('ar'));
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}