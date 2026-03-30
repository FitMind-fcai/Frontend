import 'package:fitmind/presentation/authentication/widgets/common_button.dart';
import 'package:fitmind/presentation/plan/screens/workout_plan_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/plan/nutrition_plan_result.dart';

class NutritionPlanResultScreen extends StatelessWidget {
  final NutritionPlanResult plan;
  final String navigationStatus;

  const NutritionPlanResultScreen({
    Key? key,
    required this.plan,
    this.navigationStatus = 'normal', // 👈 default
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                    child: const Icon(Icons.arrow_back_ios, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Your Nutrition Plan Summary',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // ── Plan name ─────────────────────────────────────────────
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
                  color: Colors.grey[700],
                  fontFamily: AppConstants.fontRegular,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 14, color: Colors.black),
                  const SizedBox(width: 6),
                  Text(
                    '${plan.startDate}  →  ${plan.endDate}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
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
              const Text(
                'DAILY MACRONUTRIENTS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Color(0xFF9CA3AF),
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
                      color: const Color(0xFFFFF3E0),
                      borderColor: const Color(0xFFFFCC80),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MacroCard(
                      label: 'Carbs',
                      sublabel: '',
                      value: '${plan.dailyCarbsG}g',
                      emoji: '🌾',
                      color: const Color(0xFFE8F5E9),
                      borderColor: const Color(0xFFA5D6A7),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MacroCard(
                      label: 'Fats',
                      sublabel: '',
                      value: '${plan.dailyFatsG}g',
                      emoji: '🥑',
                      color: const Color(0xFFE3F2FD),
                      borderColor: const Color(0xFF90CAF9),
                    ),
                  ),
                ],
              ),
              AppConstants.verticalSpaceXXL,
              navigationStatus == 'both'
                  ? CommonButton(
                title: "Next: Workout Plan",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => WorkoutPlanScreen()),
                  );
                },
              )
                  : CommonButton(
                title: "Go to Home",
                onPressed: () {
                  // your existing home navigation
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  final String label;
  final String sublabel;
  final String value;
  final String emoji;
  final Color color;
  final Color borderColor;

  const _MacroCard({
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
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              fontFamily: AppConstants.fontRegular,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Daily $label',
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