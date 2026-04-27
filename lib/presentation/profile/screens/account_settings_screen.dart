import 'package:fitmind/core/constants/app_constants.dart';
import 'package:fitmind/presentation/profile/screens/about_us_screen.dart';
import 'package:fitmind/presentation/profile/screens/help_center_screen.dart';
import 'package:fitmind/presentation/profile/screens/notifications_settings_screen.dart';
import 'package:fitmind/presentation/profile/screens/personal_information_screen.dart'
    hide AppConstants;
import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Black banner app bar ───────────────────────────────────
          _SettingsAppBar(onBack: () => Navigator.of(context).maybePop()),

          const SizedBox(height: 20),

          // ── Scrollable body ────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // ── General ──────────────────────────────────────
                _SectionHeader(title: 'General'),
                _SettingsGroup(
                  children: [
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      onTap: () =>
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => NotificationSettingsPage(),
                            ),
                          ),
                    ),
                    _SettingsTile(
                      icon: Icons.person_outline_rounded,
                      label: 'Personal Information',
                      onTap: () =>
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PersonalInfoPage(),
                            ),
                          ),
                    ),
                    _SettingsTile(
                      icon: Icons.dark_mode_outlined,
                      label: 'Dark Mode',
                      onTap: () {},
                      trailing: _AppToggle(value: false, onChanged: (_) {}),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Security & Privacy ────────────────────────────
                _SectionHeader(
                  title: 'Security & Privacy',
                  badge: 'Beta',
                  badgeColor: const Color(0xFF3A7BFF),
                ),
                _SettingsGroup(
                  children: [

                    _SettingsTile(
                      icon: Icons.shield_outlined,
                      label: 'Privacy Policy',
                      onTap: () {},
                      isLast: true,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Help & Support ────────────────────────────────
                _SectionHeader(title: 'Help & Support'),
                _SettingsGroup(
                  children: [
                    _SettingsTile(
                        icon: Icons.info_outline_rounded,
                        label: 'About Us',
                        onTap: () =>
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AboutUsPage(),
                              ),
                            ),
                    ),
                    _SettingsTile(
                      icon: Icons.help_outline_rounded,
                      label: 'Help Center',
                      onTap: () =>
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => HelpCenterPage(),
                            ),
                          ),
                    ),
                    _SettingsTile(
                      icon: Icons.feedback_outlined,
                      label: 'Submit Feedback',
                      onTap: () {},
                      isLast: true,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Danger Zone ───────────────────────────────────
                _SectionHeader(
                  title: 'Danger Zone',
                  badge: 'Warning',
                  badgeColor: Colors.red,
                  trailingIcon: Icons.warning_amber_rounded,
                  trailingIconColor: const Color(0xFFFF3B30),
                ),
                _DangerButton(onTap: () {}),

                const SizedBox(height: 24),

                // ── Log Out ───────────────────────────────────────
                _SectionHeader(title: 'Log Out'),
                _SettingsGroup(
                  children: [
                    _SettingsTile(
                      icon: Icons.logout_rounded,
                      label: 'Sign Out',
                      onTap: () {},
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Black banner app bar — mirrors ProfileAppBar style, no image, no extra icons
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
              // ── Back button ─────────────────────────────────────
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
              // ── Title ───────────────────────────────────────────
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
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF888888),
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
          Icon(Icons.more_horiz, size: 18, color: Colors.grey[400]),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Settings group — now just a Column, each tile is its own card
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
  final bool isLast; // kept for API compatibility, no longer used

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 34,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: Colors.black),
                ),
                const SizedBox(width: 14),
                // Label
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppConstants.fontRegular,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                // Trailing widget or default chevron
                trailing ??
                    Image.asset(
                      "assets/images/Monotone arrow right.png",
                      width: 20,
                      height: 20,
                      color: Colors.black,
                      // This applies a color filter to the image
                      colorBlendMode: BlendMode
                          .srcIn, // Ensures the color only fills the icon shape
                    )
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
              color: Colors.white, // This applies a color filter to the image
              colorBlendMode: BlendMode
                  .srcIn, // Ensures the color only fills the icon shape
            )
          ],
        ),
      ),
    );
  }
}