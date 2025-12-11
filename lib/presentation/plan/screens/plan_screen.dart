import 'package:fitmind/core/constants/app_constants.dart';
import 'package:fitmind/presentation/plan/screens/workout_plan_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
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
                            onPressed: () {},
                            color: Colors.grey,
                          ),
                          const Text(
                            'Create Plan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(height: 40),

                      // Question
                      Center(
                        child: const Text(
                          'What type of plan\ndo you want to\ncreate?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: AppConstants.fontRegular,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Image/Icon Area
                      Center(
                        child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.blue.shade50,
                                Colors.purple.shade50,
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.fitness_center,
                                size: 80,
                                color: Colors.blue.shade600,
                              ),
                              const SizedBox(width: 40),
                              Icon(
                                Icons.restaurant,
                                size: 80,
                                color: Colors.green.shade600,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Option Tiles
                      _buildOptionTile(
                        icon: Icons.fitness_center,
                        label: 'Workout Plan',
                        isSelected: isWorkoutSelected,
                        onTap: () {
                          setState(() {
                            isWorkoutSelected = !isWorkoutSelected;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      _buildOptionTile(
                        icon: Icons.restaurant,
                        label: 'Nutrition Plan',
                        isSelected: isNutritionSelected,
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
                          builder: (context) =>  WorkoutPlanScreen(
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
                          builder: (context) => const NutritionPlanScreen(),
                        ),
                      );
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey.shade300,
                    elevation: hasSelection ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.fontRegular,
                      color: hasSelection ? Colors.white : Colors.grey.shade500,
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
            color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFF5F5F5),
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
                color: isSelected ? Colors.white : Colors.grey[700],
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
                    color: isSelected ? Colors.white : Colors.black87,
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
                    color: isSelected ? Colors.white : Colors.grey[400]!,
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