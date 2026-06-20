import 'package:fitmind/presentation/authentication/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Trans, StringTranslateExtension;
import 'package:easy_localization/easy_localization.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<OnboardingItem> pages = [
    OnboardingItem(
      image:
          'assets/images/sporty fit latin woman boxing exercise making hit boxer isolated white background strength motivation generative ai.png',
      title: "onboarding.plans.title",
      subtitle: "onboarding.plans.subtitle",
    ),
    OnboardingItem(
      image:
          'assets/images/illustration fitness equipments design background.png',
      title: "onboarding.library.title",
      subtitle: "onboarding.library.subtitle",
    ),
    OnboardingItem(
      image: 'assets/images/heart beat is shown black background.png',
      title: "onboarding.analytics.title",
      subtitle: "onboarding.analytics.subtitle",
    ),
    OnboardingItem(
      image:
          'assets/images/banner layout green fruits vegetables generative ai.png',
      title: "onboarding.nutrition.title",
      subtitle: "onboarding.nutrition.subtitle",
    ),
    OnboardingItem(
      image:
          'assets/images/robot futuristic interpretation future virtual reality my collection illustration.png',
      title: "onboarding.coach.title",
      subtitle: "onboarding.coach.subtitle",
    ),
  ];

  void _nextPage() {
    if (currentPage < pages.length - 1) {
      setState(() => currentPage++);
      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.to(() => SignInScreen()); // or HomeScreen()
    }
  }

  void _prevPage() {
    if (currentPage > 0) {
      setState(() => currentPage--);
      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = context.locale.languageCode == 'ar'; // Check if the current locale is Arabic (RTL)

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => currentPage = index),
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Image.asset(
                    pages[index].image,
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
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 200,
                    left: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          pages[index].title.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'WorkSans',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          pages[index].subtitle.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'WorkSans',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          /// Progress bar
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                // Shorter width
                height: 10,
                // Increased height
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.hardEdge,
                // Ensures rounded corners apply to progress bar
                child: LinearProgressIndicator(
                  value: (currentPage + 1) / pages.length,
                  backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFF97316)),
                ),
              ),
            ),
          ),

          /// Navigation buttons
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 163,
                  height: 96,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: currentPage == 0 ? null : _prevPage,
                    child: Transform.flip(
                      flipX: isRtl,
                      child: SvgPicture.asset(
                        'assets/images/Solid arrow right sm.svg',
                        width: 24,
                        height: 24,
                        color: isDark?Colors.white:Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 163,
                  height: 96,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: _nextPage,
                    child: Transform.flip(
                      flipX: isRtl,
                      child: Image.asset(
                        'assets/images/Monotone arrow right.png',
                        color: isDark?Colors.white:Colors.black,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String image;
  final String title;
  final String subtitle;

  OnboardingItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
