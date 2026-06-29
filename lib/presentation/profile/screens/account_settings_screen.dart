import 'package:fitmind/core/constants/app_constants.dart';
import 'package:fitmind/presentation/profile/screens/about_us_screen.dart';
import 'package:fitmind/presentation/profile/screens/feedback_screen.dart';
import 'package:fitmind/presentation/profile/screens/help_center_screen.dart';
import 'package:fitmind/presentation/profile/screens/notifications_settings_screen.dart';
import 'package:fitmind/presentation/profile/screens/personal_information_screen.dart'
    hide AppConstants;
import 'package:fitmind/presentation/profile/screens/privacy_policy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../authentication/manager/auth_bloc.dart';
import '../../onboarding/screens/welcome_screen.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => WelcomeScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? colorScheme.surface : Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingsAppBar(onBack: () => Navigator.of(context).maybePop()),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _SectionHeader(
                    title: 'account_settings.section_general'.tr(),
                  ),
                  _SettingsGroup(
                    children: [
                      _SettingsTile(
                        icon: Icons.notifications_outlined,
                        label: 'account_settings.notifications'.tr(),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => NotificationSettingsPage()),
                        ),
                      ),
                      _SettingsTile(
                        icon: Icons.person_outline_rounded,
                        label: 'account_settings.personal_information'.tr(),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PersonalInfoPage()),
                        ),
                      ),
                      _SettingsTile(
                        icon: Icons.dark_mode_outlined,
                        label: 'account_settings.dark_mode'.tr(),
                        onTap: () {},
                        trailing: _AppToggle(value: false, onChanged: (_) {}),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'account_settings.section_security_privacy'.tr(),
                    badge: 'account_settings.badge_beta'.tr(),
                    badgeColor: const Color(0xFF3A7BFF),
                  ),
                  _SettingsGroup(
                    children: [
                      _SettingsTile(
                        icon: Icons.shield_outlined,
                        label: 'account_settings.privacy_policy'.tr(),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => PrivacyPolicyPage()),
                        ),
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'account_settings.section_help_support'.tr(),
                  ),
                  _SettingsGroup(
                    children: [
                      _SettingsTile(
                        icon: Icons.info_outline_rounded,
                        label: 'account_settings.about_us'.tr(),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AboutUsPage()),
                        ),
                      ),
                      _SettingsTile(
                        icon: Icons.help_outline_rounded,
                        label: 'account_settings.help_center'.tr(),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => HelpCenterPage()),
                        ),
                      ),
                      _SettingsTile(
                        icon: Icons.feedback_outlined,
                        label: 'account_settings.submit_feedback'.tr(),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => FeedbackPage()),
                        ),
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'account_settings.section_danger_zone'.tr(),
                    badge: 'account_settings.badge_warning'.tr(),
                    badgeColor: Colors.red,
                    trailingIcon: Icons.warning_amber_rounded,
                    trailingIconColor: const Color(0xFFFF3B30),
                  ),
                  _DangerButton(onTap: () {}),
                  const SizedBox(height: 24),
                  _SectionHeader(
                      title: 'account_settings.section_log_out'.tr()),
                  _SettingsGroup(
                    children: [
                      _SettingsTile(
                        icon: Icons.logout_rounded,
                        label: 'account_settings.sign_out'.tr(),
                        onTap: () {
                          context.read<AuthBloc>().add(DeleteUserEvent());
                        },
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Black banner app bar
// ─────────────────────────────────────────────────────────────────────────────
class _SettingsAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const _SettingsAppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.20),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppConstants.fontRegular,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? badge;
  final Color? badgeColor;
  final IconData? trailingIcon;
  final Color? trailingIconColor;

  const _SectionHeader({
    required this.title,
    this.badge,
    this.badgeColor,
    this.trailingIcon,
    this.trailingIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white54 : const Color(0xFF888888);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: labelColor,
              letterSpacing: 0.2,
            ),
          ),
          if (badge != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor!.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badge!,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppConstants.fontRegular,
                  color: badgeColor,
                ),
              ),
            ),
          ],
          const Spacer(),
          if (trailingIcon != null)
            Icon(trailingIcon, size: 16, color: trailingIconColor),
          const SizedBox(width: 4),
          Icon(Icons.more_horiz,
              size: 18, color: isDark ? Colors.white38 : Colors.grey[400]),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Settings group
// ─────────────────────────────────────────────────────────────────────────────
class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(children: children);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual settings tile
// ─────────────────────────────────────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isLast;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final isRtl = context.locale.languageCode ==
        'ar'; // Check if the current locale is Arabic (RTL)

    final tileBg = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final iconBg = isDark ? colorScheme.surfaceContainerHighest : Colors.white;
    final iconColor = isDark ? Colors.white : Colors.black;
    final labelColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final arrowColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: tileBg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppConstants.fontRegular,
                      color: labelColor,
                    ),
                  ),
                ),
                Transform.flip(
                  flipX: isRtl,
                  // Flip the arrow horizontally if the locale is RTL
                  child: trailing ??
                      Image.asset(
                        "assets/images/Monotone arrow right.png",
                        width: 20,
                        height: 20,
                        color: arrowColor,
                        colorBlendMode: BlendMode.srcIn,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Toggle switch
// ─────────────────────────────────────────────────────────────────────────────
class _AppToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AppToggle({required this.value, required this.onChanged});

  @override
  State<_AppToggle> createState() => _AppToggleState();
}

class _AppToggleState extends State<_AppToggle> {
  late bool _val;

  @override
  void initState() {
    super.initState();
    _val = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _val,
      onChanged: (v) {
        setState(() => _val = v);
        widget.onChanged(v);
      },
      activeColor: Colors.white,
      activeTrackColor: AppConstants.primaryColor,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xFFDDDDDD),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Danger zone close account button
// ─────────────────────────────────────────────────────────────────────────────
class _DangerButton extends StatelessWidget {
  final VoidCallback onTap;

  const _DangerButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF3B30).withOpacity(0.30),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Close Account',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: AppConstants.fontRegular,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 172),
            Image.asset(
              "assets/images/Monotone arrow right.png",
              width: 20,
              height: 20,
              color: Colors.white,
              colorBlendMode: BlendMode.srcIn,
            ),
          ],
        ),
      ),
    );
  }
}
