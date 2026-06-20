import 'package:fitmind/presentation/authentication/widgets/common_button.dart';
import 'package:fitmind/presentation/plan/screens/workout_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/plan/nutrition_plan_generation_request.dart';
import '../../../data/models/plan/nutrition_plan_result.dart';
import '../../../presentation/plan/manager/plan_bloc.dart';
import '../../home/screens/home_screen.dart';

class NutritionPlanResultScreen extends StatelessWidget {
  final NutritionPlanResult plan;
  final String navigationStatus;
  final NutritionPlanGenerationRequest? request;

  const NutritionPlanResultScreen({
    Key? key,
    required this.plan,
    this.navigationStatus = 'normal', // 👈 default
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
            if (state is NutritionPreferencesSuccess) {
              // After generating another plan, show the new result
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => NutritionPlanResultScreen(
                    plan: state.plan,
                    navigationStatus: navigationStatus,
                    request: request,
                  ),
                ),
              );
            } else if (state is NutritionPlanSaveSuccess) {
              // Navigate based on navigationStatus
              if (navigationStatus == 'both') {
                // Go to workout plan
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutPlanScreen(),
                  ),
                );
              } else {
                // Go to home screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                );
              }
            } else if (state is PlanError) {
              // Show error message if save fails
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<PlanBloc, PlanState>(
            builder: (context, state) {
              return Stack(
                children: [
                  // Main content
                  SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Header ────────────────────────────────────────────────
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
                                'Your Nutrition Plan Summary',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppConstants.fontRegular,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              SizedBox(width: 32),

                            ],
                          ),

                          const SizedBox(height: 36),

                          // ── Plan name ─────────────────────────────────────────────
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
                              color: isDark ? Colors.white60 : Colors.grey[700],
                              fontFamily: AppConstants.fontRegular,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  size: 14, color: isDark ? Colors.white : Colors.black),
                              const SizedBox(width: 6),
                              Text(
                                '${plan.startDate}  →  ${plan.endDate}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? Colors.white : Colors.black,
                                  fontFamily: AppConstants.fontRegular,
                                  fontWeight: AppConstants.mediumBold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 36),

                          // ── Daily Calories card ────────────────────────────────────
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
                                    const Text(
                                      '🔥',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'DAILY CALORIE TARGET',
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
                                  '${plan.dailyCalories} kcal',
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
                                  'Recommended intake per day',
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

                          // ── Section label ──────────────────────────────────────────
                          Text(
                            'DAILY MACRONUTRIENTS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: isDark ? Colors.white60 : const Color(0xFF9CA3AF),
                              fontFamily: AppConstants.fontRegular,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ── Macros row ─────────────────────────────────────────────
                          Row(
                            children: [
                              Expanded(
                                child: _MacroCard(
                                  label: 'Protein',
                                  sublabel: '',
                                  value: '${plan.dailyProteinG}g',
                                  emoji: '🥩',
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
                                child: _MacroCard(
                                  label: 'Carbs',
                                  sublabel: '',
                                  value: '${plan.dailyCarbsG}g',
                                  emoji: '🌾',
                                  color: isDark
                                      ? const Color(0xFF1E3324)
                                      : const Color(0xFFE8F5E9),
                                  borderColor: isDark
                                      ? const Color(0xFF4F7A57)
                                      : const Color(0xFFA5D6A7),
                                  isDark: isDark,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _MacroCard(
                                  label: 'Fats',
                                  sublabel: '',
                                  value: '${plan.dailyFatsG}g',
                                  emoji: '🥑',
                                  color: isDark
                                      ? const Color(0xFF1A2E3D)
                                      : const Color(0xFFE3F2FD),
                                  borderColor: isDark
                                      ? const Color(0xFF4A7BA6)
                                      : const Color(0xFF90CAF9),
                                  isDark: isDark,
                                ),
                              ),
                            ],
                          ),
                          AppConstants.verticalSpaceXXL,
                          // ── Choice: Save or Generate Another ────────────────────────
                          CommonButton(
                            title: navigationStatus == 'both'
                                ? "Save & Continue to Workout"
                                : "Save Plan",
                            onPressed: () {
                              context
                                  .read<PlanBloc>()
                                  .add(SaveNutritionPlanEvent(plan));
                            },
                          ),
                          const SizedBox(height: 12),
                          CommonButton(
                            title: "Generate Another",
                            onPressed: () {
                              if (request != null) {
                                // Regenerate with the same request
                                context
                                    .read<PlanBloc>()
                                    .add(SubmitNutritionPreferencesEvent(request!));
                              } else {
                                // Fallback: go back to edit preferences
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Loading overlay
                  if (state is PlanLoading)
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
                            const Text(
                              "Creating your plan...",
                              style: TextStyle(
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
        ));
  }
}

class _MacroCard extends StatelessWidget {
  final String label;
  final String sublabel;
  final String value;
  final String emoji;
  final Color color;
  final Color borderColor;
  final bool isDark;

  const _MacroCard({
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
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              fontFamily: AppConstants.fontRegular,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Daily $label',
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