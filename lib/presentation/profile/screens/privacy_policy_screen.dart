import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Privacy Policy',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  // Header Section
                  const Text(
                    "Our Commitment",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Last updated: April 2026",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "At FitMind, we prioritize your privacy. This policy explains how we handle your data when you use our AI Fitness & Training solutions.",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF1A1A1A),
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Data Collection Box (Using your _InfoBox style)
                  const _PolicySectionBox(
                    icon: Icons.security,
                    title: "Data Collection",
                    content: "We collect information you provide directly, such as fitness goals, biometric data, and training schedules to improve your AI experience.",
                  ),
                  const SizedBox(height: 16),

                  // Usage Box
                  const _PolicySectionBox(
                    icon: Icons.visibility_off,
                    title: "Information Sharing",
                    content: "FitMind does not sell your personal data to third parties. Your data is encrypted and used only for personalized training generation.",
                  ),
                  const SizedBox(height: 32),

                  // Standard Text Section for finer details
                  const Text(
                    "Your Rights",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "• Right to access your data\n"
                        "• Right to delete your account and biometrics\n"
                        "• Right to opt-out of AI model training usage",
                    style: TextStyle(
                      fontSize: 14,
                      height: 2.0,
                      color: Color(0xFF7D7D7D),
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Contact Support Button (Consistent with the bottom-padding vibe)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Link to your support email or contact page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Contact Support",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.fontRegular,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusing your _InfoBox pattern but slightly modified for long text
class _PolicySectionBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _PolicySectionBox({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
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
                title,
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
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF7D7D7D),
              fontFamily: AppConstants.fontRegular,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}