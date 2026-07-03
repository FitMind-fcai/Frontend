import 'package:fitmind/core/constants/app_constants.dart';
import 'package:fitmind/presentation/plan/screens/workout_plan_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'nutrition_plan_screen.dart';

class PlanSelectionScreen extends StatefulWidget {
  const PlanSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
  bool isWorkoutSelected = false;
  bool isNutritionSelected = false;

  bool get hasSelection => isWorkoutSelected || isNutritionSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 20),
                            onPressed: () =>Navigator.of(context).maybePop(),
                            color: isDark ? Colors.white60 : Colors.grey,
                          ),
                          Text(
                            'plan_selection.title'.tr(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(height: 40),

                      // Question
                      Center(
                        child: Text(
                          'plan_selection.question'.tr(),

                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: AppConstants.fontRegular,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      AppConstants.verticalSpaceXXL,
                      AppConstants.verticalSpaceXXL,
                      AppConstants.verticalSpaceXXL,


                      // Option Tiles
                      _buildOptionTile(
                        icon: Icons.fitness_center,
                        label: 'plan_selection.workout_plan'.tr(),
                        isSelected: isWorkoutSelected,
                        isDark: isDark,
                        onTap: () {
                          setState(() {
                            isWorkoutSelected = !isWorkoutSelected;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      _buildOptionTile(
                        icon: Icons.restaurant,
                        label: 'plan_selection.nutrition_plan'.tr(),
                        isSelected: isNutritionSelected,
                        isDark: isDark,
                        onTap: () {
                          setState(() {
                            isNutritionSelected = !isNutritionSelected;
                          });
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Continue Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: hasSelection
                      ? () {
                    // Navigate based on selection
                    if (isWorkoutSelected && isNutritionSelected) {
                      // Navigate to workout plan first, then nutrition
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  NutritionPlanScreen(navigationStatus: 'both'
                          ),
                        ),
                      );
                    } else if (isWorkoutSelected) {
                      // Navigate to workout plan only
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>WorkoutPlanScreen(
                          ),
                        ),
                      );
                    } else if (isNutritionSelected) {
                      // Navigate to nutrition plan only
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  NutritionPlanScreen(navigationStatus: 'normal',),
                        ),
                      );
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    disabledBackgroundColor: isDark
                        ? Colors.white12
                        : Colors.grey.shade300,
                    elevation: hasSelection ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'plan_selection.continue_button'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.fontRegular,
                      color: hasSelection
                          ? (isDark ? Colors.black : Colors.white)
                          : (isDark ? Colors.white38 : Colors.grey.shade500),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: isSelected ? 1.03 : 1.0,
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFF6B35)
                : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.white54 : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.grey[700]),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppConstants.fontRegular,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ),

              // Animated checkmark
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.white : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white38 : Colors.grey[400]!),
                    width: 2,
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: isSelected
                      ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Color(0xFFFF6B35),
                    key: ValueKey(1),
                  )
                      : const SizedBox(key: ValueKey(2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}