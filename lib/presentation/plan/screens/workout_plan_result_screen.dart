import 'package:fitmind/presentation/authentication/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/plan/workout_plan_generation_request.dart';
import '../../../data/models/plan/workout_plan_result.dart';
import '../../home/screens/home_screen.dart';
import '../manager/plan_bloc.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
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
                              child: const Icon(Icons.arrow_back_ios, size: 20),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Your Workout Plan Summary',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppConstants.fontRegular,
                              ),
                            ),


                          ],
                        ),

                        const SizedBox(height: 36),

                        // ── Plan name & description ──────────────────────
                        Text(
                          plan.planName,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            fontFamily: AppConstants.fontRegular,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          plan.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontFamily: AppConstants.fontRegular,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 14, color: Colors.grey[400]),
                            const SizedBox(width: 6),
                            Text(
                              '${plan.startDate}  →  ${plan.endDate}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
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
                                children: const [
                                  Text('⏱️', style: TextStyle(fontSize: 18)),
                                  SizedBox(width: 8),
                                  Text(
                                    'ESTIMATED SESSION DURATION',
                                    style: TextStyle(
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
                                '${plan.estimatedDurationPerSession} min',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 52,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: AppConstants.fontRegular,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Recommended duration per session',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                  fontFamily: AppConstants.fontRegular,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'PLAN OVERVIEW',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: Color(0xFF9CA3AF),
                            fontFamily: AppConstants.fontRegular,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Info cards ───────────────────────────────────
                        Row(
                          children: [
                            Expanded(
                              child: _InfoCard(
                                label: 'Frequency',
                                sublabel: 'per week',
                                value: plan.frequency,
                                emoji: '📅',
                                color: const Color(0xFFFFF3E0),
                                borderColor: const Color(0xFFFFCC80),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _InfoCard(
                                label: 'Difficulty',
                                sublabel: 'level',
                                value: plan.difficultyLevel,
                                emoji: '🔥',
                                color: const Color(0xFFFFEBEE),
                                borderColor: const Color(0xFFEF9A9A),
                              ),
                            ),
                          ],
                        ),

                        AppConstants.verticalSpaceXXL,

                        // ── Save button ──────────────────────────────────
                        CommonButton(
                          title: 'Save Plan',
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
                            label: const Text(
                              'Generate Again',
                              style: TextStyle(
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
                                ? 'Saving your plan...'
                                : 'Creating your plan...',
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

  const _InfoCard({
    required this.label,
    required this.sublabel,
    required this.value,
    required this.emoji,
    required this.color,
    required this.borderColor,
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              fontFamily: AppConstants.fontRegular,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFamily: AppConstants.fontRegular,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sublabel,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
              fontFamily: AppConstants.fontRegular,
            ),
          ),
        ],
      ),
    );
  }
}