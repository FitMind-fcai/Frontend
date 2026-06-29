import 'package:fitmind/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

import '../../../data/data_sources/local/auth_local_data_source.dart';
import '../../../data/models/user_model.dart';
import '../screens/account_settings_screen.dart';

class ProfileAppBar extends StatefulWidget {
  const ProfileAppBar();

  @override
  State<ProfileAppBar> createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  String? _userName;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final UserModel? user = await AuthLocalDataSourceImpl().getCachedUser();
    if (mounted) {
      setState(() {
        _userName = user?.name;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // How far the avatar overhangs below the banner
    const double avatarRadius = 42.0;
    const double overlap = avatarRadius; // avatar is half inside, half outside

    return Column(
      children: [
        // ── Banner + overlapping avatar ──────────────────────────────
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // ── Photo banner ────────────────────────────────────────
            Container(
              width: double.infinity,
              height: 220,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/ProfileAppBar.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black38,
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 2,
                      right: 16,
                      child: _GlassIconButton(
                        icon: Icons.settings_rounded,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AccountSettingsPage(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Avatar — centred, overlapping ───────────────────────
            Positioned(
              bottom: -overlap,
              child: Container(
                width: avatarRadius * 2,
                height: avatarRadius * 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  // ── swap with a real NetworkImage / AssetImage ──
                  child: Icon(
                    Icons.person,
                    color: Colors.white54,
                    size: 44,
                  ),
                ),
              ),
            ),
          ],
        ),

        // ── Space so content clears the overlapping avatar ──────────
        SizedBox(height: overlap + 12),

        // ── Name ────────────────────────────────────────────────────
        _loading
            ? const _ShimmerBox(width: 160, height: 22)
            : Text(
                '${_userName ?? 'User'}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppConstants.fontRegular,
                ),
              ),

        const SizedBox(height: 6),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Frosted-glass icon button (edit / settings)
// ─────────────────────────────────────────────────────────────────────────────
class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[700]!.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shimmer placeholder
// ─────────────────────────────────────────────────────────────────────────────
class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;

  const _ShimmerBox({required this.width, required this.height});

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.15, end: 0.40).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(_anim.value),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
