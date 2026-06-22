import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_constants.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? colorScheme.surface : Colors.white,
        elevation: 0,
        leading: BackButton(color: isDark ? Colors.white : Colors.black),
        title: Text(
          'about_us.title'.tr(),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: SvgPicture.asset("assets/images/MainLogoOrange.svg"),
                  ),
                  Text(
                    "FitMind",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: AppConstants.fontRegular,
                        color: isDark ? Colors.white : Colors.black),
                  ),
                  Text(
                    'about_us.app_tagline'.tr(),
                    style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white60 : Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppConstants.fontRegular),
                  ),
                  const SizedBox(height: 40),
                  _InfoBox(
                    icon: Icons.location_on,
                    label: 'about_us.address'.tr(),
                    value: "578 Boolean Ave\nTuring St\nNew York, NY",
                  ),
                  const SizedBox(height: 16),
                  _InfoBox(
                    icon: Icons.phone_android,
                    label: 'about_us.telephone'.tr(),
                    value: "+123-456-789\n+44-887-449",
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialIcon(imagePath: "assets/images/facebook.png"),
                _SocialIcon(imagePath: "assets/images/instagram.png"),
                _SocialIcon(imagePath: "assets/images/linkedin.png"),
                _SocialIcon(imagePath: "assets/images/youtube.png"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHigh : const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: isDark ? Colors.white54 : Colors.blueGrey),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  fontFamily: AppConstants.fontRegular,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white60 : const Color(0xFF7D7D7D),
                fontFamily: AppConstants.fontRegular,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final String imagePath;

  const _SocialIcon({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Image.asset(
        imagePath,
        width: 28,
        height: 28,
      ),
    );
  }
}