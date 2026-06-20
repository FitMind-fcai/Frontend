import 'package:fitmind/presentation/authentication/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/plan/workout_plan_generation_request.dart';
import '../../../data/models/plan/workout_plan_result.dart';
import '../../home/screens/home_screen.dart';
import '../manager/plan_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class WorkoutPlanResultScreen extends StatelessWidget {
  final WorkoutPlanResult plan;
  final WorkoutPlanGenerationRequest? request;

  const WorkoutPlanResultScreen({
    Key? key,
    required this.plan,
    this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : Colors.white,
      body: BlocListener<PlanBloc, PlanState>(
        listener: (context, state) {
          if (state is WorkoutPreferencesSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => WorkoutPlanResultScreen(
                  plan: state.plan,
                  request: request,
                ),
              ),
            );
          } else if (state is WorkoutPlanSaveSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
            );
          } else if (state is PlanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<PlanBloc, PlanState>(
          builder: (context, state) {
            final isLoading = state is PlanLoading;
            final isSaving = state is PlanLoading && state.isSaving;

            return Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header ──────────────────────────────────────
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'workout_result.title'.tr(),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppConstants.fontRegular,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),


                          ],
                        ),

                        const SizedBox(height: 36),

                        // ── Plan name & description ──────────────────────
                        Text(
                          plan.planName,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            fontFamily: AppConstants.fontRegular,
                            height: 1.2,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          plan.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white60 : Colors.grey[500],
                            fontFamily: AppConstants.fontRegular,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 14,
                                color: isDark ? Colors.white38 : Colors.grey[400]),
                            const SizedBox(width: 6),
                            Text(
                              'workout_result.date_range'.tr(namedArgs: {'start': plan.startDate, 'end': plan.endDate}),
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.white60 : Colors.grey[500],
                                fontFamily: AppConstants.fontRegular,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 36),

                        // ── Session Duration card ────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 28),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('⏱️', style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'workout_result.estimated_session_duration'.tr(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      letterSpacing: 1.2,
                                      fontFamily: AppConstants.fontRegular,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'workout_result.duration_value'.tr(namedArgs: {'count': '${plan.estimatedDurationPerSession}'}),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 52,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: AppConstants.fontRegular,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'workout_result.recommended_duration'.tr(),
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                  fontFamily: AppConstants.fontRegular,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'workout_result.plan_overview'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: isDark ? Colors.white60 : const Color(0xFF9CA3AF),
                            fontFamily: AppConstants.fontRegular,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Info cards ───────────────────────────────────
                        Row(
                          children: [
                            Expanded(
                              child: _InfoCard(
                                label: 'workout_result.info_frequency'.tr(),
                                sublabel: 'workout_result.info_frequency_sub'.tr(),
                                value: plan.frequency,
                                emoji: '📅',
                                color: isDark
                                    ? const Color(0xFF3D2E1A)
                                    : const Color(0xFFFFF3E0),
                                borderColor: isDark
                                    ? const Color(0xFF8A6D3B)
                                    : const Color(0xFFFFCC80),
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _InfoCard(
                                label: 'workout_result.info_difficulty'.tr(),
                                sublabel: 'workout_result.info_difficulty_sub'.tr(),
                                value: plan.difficultyLevel,
                                emoji: '🔥',
                                color: isDark
                                    ? const Color(0xFF3D1F22)
                                    : const Color(0xFFFFEBEE),
                                borderColor: isDark
                                    ? const Color(0xFF8A4A4F)
                                    : const Color(0xFFEF9A9A),
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),

                        AppConstants.verticalSpaceXXL,

                        // ── Save button ──────────────────────────────────
                        CommonButton(
                          title: 'workout_result.save_plan'.tr(),
                          onPressed: isLoading
                              ? null
                              : () => context
                              .read<PlanBloc>()
                              .add(SaveWorkoutPlanEvent(plan)),
                        ),

                        const SizedBox(height: 12),

                        // ── Generate Again button ────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton.icon(
                            onPressed: isLoading
                                ? null
                                : () {
                              if (request != null) {
                                context.read<PlanBloc>().add(
                                    SubmitWorkoutPreferencesEvent(
                                        request!));
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(
                              'workout_result.generate_again'.tr(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppConstants.fontRegular,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppConstants.primaryColor,
                              side: BorderSide(
                                  color: AppConstants.primaryColor, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // ── Loading overlay ──────────────────────────────────
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RotatedBox(
                            quarterTurns: -1,
                            child: SizedBox(
                              width: 120,
                              child: LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppConstants.primaryColor),
                                backgroundColor: Colors.white24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            isSaving
                                ? 'workout_result.saving_plan'.tr()
                                : 'workout_result.creating_plan'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: AppConstants.fontRegular,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String sublabel;
  final String value;
  final String emoji;
  final Color color;
  final Color borderColor;
  final bool isDark;

  const _InfoCard({
    required this.label,
    required this.sublabel,
    required this.value,
    required this.emoji,
    required this.color,
    required this.borderColor,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 10),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              fontFamily: AppConstants.fontRegular,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFamily: AppConstants.fontRegular,
              color: isDark ? Colors.white70 : const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sublabel,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
              fontFamily: AppConstants.fontRegular,
            ),
          ),
        ],
      ),
    );
  }
}
