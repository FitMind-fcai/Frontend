import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'privacy_policy.title'.tr(),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'privacy_policy.commitment_title'.tr(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: AppConstants.fontRegular,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'privacy_policy.last_updated'.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white60 : Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'privacy_policy.intro'.tr(),
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: isDark ? Colors.white70 : const Color(0xFF1A1A1A),
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _PolicySectionBox(
                    icon: Icons.security,
                    title: 'privacy_policy.data_collection_title'.tr(),
                    content: 'privacy_policy.data_collection_content'.tr(),
                  ),
                  const SizedBox(height: 16),
                  _PolicySectionBox(
                    icon: Icons.visibility_off,
                    title: 'privacy_policy.information_sharing_title'.tr(),
                    content: 'privacy_policy.information_sharing_content'.tr(),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'privacy_policy.rights_title'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.fontRegular,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• ${'privacy_policy.right_access'.tr()}\n'
                        '• ${'privacy_policy.right_delete'.tr()}\n'
                        '• ${'privacy_policy.right_opt_out'.tr()}',
                    style: TextStyle(
                      fontSize: 14,
                      height: 2.0,
                      color: isDark ? Colors.white60 : const Color(0xFF7D7D7D),
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'privacy_policy.contact_support'.tr(),
                  style: const TextStyle(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
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
                title,
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
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white60 : const Color(0xFF7D7D7D),
              fontFamily: AppConstants.fontRegular,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}