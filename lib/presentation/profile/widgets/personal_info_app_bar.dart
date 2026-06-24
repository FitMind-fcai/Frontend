import 'package:fitmind/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../data/data_sources/local/auth_local_data_source.dart';
import '../../../data/models/user_model.dart';
import '../screens/account_settings_screen.dart';

class InfoAppBar extends StatefulWidget {
  const InfoAppBar();

  @override
  State<InfoAppBar> createState() => _InfoAppBarState();
}

class _InfoAppBarState extends State<InfoAppBar> {
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
              height: 160,
              decoration: const BoxDecoration(
                color: Colors.black, // Placeholder for your image
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SafeArea(
                  bottom: false, // We only care about the top notch area
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        // ── Back Button ─────────────────────────────────────
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              // Translucent white background
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.chevron_left_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                        // ── Title Text ──────────────────────────────────────
                        Text(
                          'personal_info.title'.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: AppConstants.fontRegular,
                          ),
                        ),
                      ],
                    ),
                  ),
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

        const SizedBox(height: 16),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Frosted-glass icon button (edit / settings)
// ─────────────────────────────────────────────────────────────────────────────

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
