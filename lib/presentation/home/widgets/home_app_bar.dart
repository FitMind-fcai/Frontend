import 'dart:ffi';

import 'package:fitmind/core/constants/app_constants.dart';
import 'package:fitmind/presentation/assessment/screens/assessment_screen.dart';
import 'package:fitmind/presentation/plan/screens/plan_screen.dart';
import 'package:fitmind/presentation/profile/screens/account_settings_screen.dart';
import 'package:fitmind/presentation/profile/screens/personal_information_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../data/data_sources/local/auth_local_data_source.dart';
import '../../../data/models/home/score_response.dart';
import '../../../data/models/user_model.dart';
import '../../notifications/manager/notification_bloc.dart';
import '../../notifications/screens/notifications_screen.dart';

class HomeAppBar extends StatefulWidget {
  final double? score;

  const HomeAppBar({Key? key, required this.score}) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  String? _userName;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
    context.read<NotificationBloc>().add(const LoadCoachingMessagesEvent());
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
    final score = widget.score;
    final isRtl = context.locale.languageCode ==
        'ar'; // Check if the current locale is Arabic (RTL)
    final now = DateTime.now();
    final months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    final dateLabel = DateFormat(
      'home_app_bar.date_format'.tr(),
      context.locale.languageCode,
    ).format(now);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        image: DecorationImage(
          image: AssetImage('assets/images/home_back.jpg'),
          fit: BoxFit.cover,
          // darken the image so text stays readable
          colorFilter: ColorFilter.mode(
            Colors.black54,
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppConstants.verticalSpaceXL,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Date
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      color: Colors.white54, size: 13),
                  const SizedBox(width: 6),
                  Text(
                    dateLabel,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Notification bell
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CoachingMessagesScreen()),
                  );
                },
                child: BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    final unreadCount =
                        state is CoachingMessagesLoaded ? state.unreadCount : 0;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.notifications_rounded,
                              color: Colors.white, size: 22),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              decoration: BoxDecoration(
                                color: AppConstants.primaryColor,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Center(
                                child: Text(
                                  unreadCount > 99 ? '99+' : '$unreadCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: AppConstants.fontRegular,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Bottom row: avatar + name + badges ───────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Large avatar
              CircleAvatar(
                radius: 34,
                backgroundColor: Colors.white12,
                child:
                    const Icon(Icons.person, color: Colors.white54, size: 34),
              ),
              const SizedBox(width: 14),
              // Name + badges
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _loading
                      ? const SizedBox(
                          width: 140,
                          height: 22,
                          child: _ShimmerBox(),
                        )
                      : Row(
                        children: [
                          Row(
                              children: [
                                Text(
                                  'home_app_bar.greeting'.tr(
                                    namedArgs: {
                                      'name': _userName ??
                                          'home_app_bar.fallback_name'.tr(),
                                    },
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: AppConstants.fontRegular,
                                  ),
                                ),
                                AppConstants.horizontalSpaceXXL,
                                AppConstants.horizontalSpaceL,
                                AppConstants.horizontalSpaceL,
                                AppConstants.horizontalSpaceL,
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const AccountSettingsPage()),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Transform.flip(
                                      flipX: isRtl,
                                      // Flip the arrow horizontally if the locale is RTL
                                      child: Image.asset(
                                          "assets/images/Monotone arrow right.png"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _BadgeChip(
                        icon: Icons.add,
                        iconColor: const Color(0xFFFF6B35),
                        label: 'home_app_bar.healthy_score'.tr(
                          namedArgs: {
                            'value': score != null ? score!.toStringAsFixed(0) : '--',
                          },
                        ),
                        textColor: Colors.white70,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Badge chip helper ──────────────────────────────────────────────────────────
class _BadgeChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color textColor;

  const _BadgeChip({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 13),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontFamily: AppConstants.fontRegular,
              fontWeight: FontWeight.w700,
            )),
      ],
    );
  }
}

// ── Shimmer placeholder while loading ─────────────────────────────────────────
class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox();

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
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(_ctrl);
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
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(_anim.value),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
