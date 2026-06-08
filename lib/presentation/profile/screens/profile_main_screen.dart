import 'package:fitmind/presentation/profile/widgets/profile_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../manager/profile_bloc.dart';
import '../widgets/my_plan_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Optionally trigger the profile fetch event if it hasn't been loaded globally yet
     context.read<ProfileBloc>().add(LoadProfileEvent());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ProfileAppBar(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MyPlanCard(),
                ),
                const SizedBox(height: 16),

                // ── Dynamic Profile Metrics Grid ─────────────────────────────
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    String userAge = '--';
                    String userWeight = '--';

                    // Extracted dynamically whenever state contains loaded profile information
                    if (state is ProfileLoaded) {
                      userAge = '${state.profile.age} yr';
                      userWeight = '${state.profile.weight.round()} kg';
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          _StatCard(
                            icon: Icons.calendar_month,
                            iconColor: Colors.redAccent,
                            value: userAge,
                            label: 'Current Age',
                          ),
                          const SizedBox(width: 12),
                          _StatCard(
                            icon: Icons.monitor_weight_rounded,
                            iconColor: Colors.green,
                            value: userWeight,
                            label: 'Weight',
                          ),
                          const SizedBox(width: 12),
                          const _StatCard(
                            icon: Icons.local_fire_department_rounded,
                            iconColor: Colors.blue,
                            value: '978 kcal', // Kept static or wire up from diet state later
                            label: 'Daily Intake',
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat Card
// ─────────────────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18, // Slightly dropped to avoid overflow with longer text strings
                fontFamily: AppConstants.fontRegular,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontFamily: AppConstants.fontRegular,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}