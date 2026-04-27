import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_constants.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.black,
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
                  // App Logo
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: SvgPicture.asset("assets/images/MainLogoOrange.svg"),
                  ),
                  const Text(
                    "FitMind",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: AppConstants.fontRegular),
                  ),
                  const Text(
                    "AI Fitness & Training Solution",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppConstants.fontRegular),
                  ),
                  const SizedBox(height: 40),

                  // Custom Info Boxes
                  const _InfoBox(
                    icon: Icons.location_on,
                    label: "Address",
                    value: "578 Boolean Ave\nTuring St\nNew York, NY",
                  ),
                  const SizedBox(height: 16),
                  const _InfoBox(
                    icon: Icons.phone_android,
                    label: "Telephone",
                    value: "+123-456-789\n+44-887-449",
                  ),
                ],
              ),
            ),
          ),

          // Social Media Icons
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
    return Container(
      width: double.infinity,
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2), // Light gray background
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blueGrey),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF1A1A1A),
                  fontFamily: AppConstants.fontRegular,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7D7D7D),
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
        width: 28, // Adjusted to match the design scale
        height: 28,
        // If your images are colored and you want them gray like the UI:
        // color: Colors.grey[400],
        // colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}
