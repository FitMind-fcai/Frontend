import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Notification Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("General"),
                _SettingsGroup(
                  children: [
                    _SettingsTile(
                      icon: Icons.notifications_none_outlined,
                      label: 'Push Notifications',
                      onTap: () {},
                      trailing: _AppToggle(value: true, onChanged: (v) {}),
                    ),
                    _SettingsTile(
                      icon: Icons.face_retouching_natural,
                      label: 'AI Coach Notification',
                      onTap: () {},
                      trailing: _AppToggle(value: false, onChanged: (v) {}),
                    ),
                    _SettingsTile(
                      icon: Icons.bar_chart_rounded,
                      label: 'Metrics Notification',
                      onTap: () {},
                      trailing: _AppToggle(value: true, onChanged: (v) {}),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionHeader("Sound"),
                _SettingsGroup(
                  children: [
                    _SettingsTile(
                      icon: Icons.vibration,
                      label: 'Vibrations',
                      onTap: () {},
                      trailing: _AppToggle(value: false, onChanged: (v) {}),
                    ),
                    _SettingsTile(
                      icon: Icons.volume_up_outlined,
                      label: 'Sound',
                      onTap: () {},
                      trailing: _AppToggle(value: true, onChanged: (v) {}),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const SizedBox(height: 100), // Space for the floating button
              ],
            ),
          ),

          // Fixed Save Settings Button at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to save settings
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Save Settings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.check, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: AppConstants.fontRegular,
              color: Colors.black,
            ),
          ),
          const Icon(Icons.more_vert, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}
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