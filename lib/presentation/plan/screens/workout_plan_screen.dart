import 'package:fitmind/presentation/plan/screens/workout_plan_result_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/plan/workout_plan_generation_request.dart';
import '../../../data/models/plan/workout_plan_model.dart';
import '../../assessment/widgets/tag_input_widget.dart';
import '../../authentication/widgets/common_button.dart';
import '../manager/plan_bloc.dart';

class WorkoutPlanScreen extends StatefulWidget {
  @override
  _WorkoutPlanScreenState createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  int currentPage = 0;

  // Nutrition plan data
  String _selectedDays = "1";
  String _selectedWorkoutFocus = "";
  int _sessionDuration = 60;
  String? _selectedEquipment;
  String? _selectedDifficulty;
  String _selectedWorkoutLocation = '';
  List<String> focusAreas = [];
  int _durationWeeks = 12;
  int _customWeeks = 12;
  bool _isCustomWeeks = false;

  // Input controllers

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<PlanBloc, PlanState>(
      listener: (context, state) {
        if (state is WorkoutPreferencesSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => WorkoutPlanResultScreen(plan: state.plan,request: _lastRequest),
            ),
          );
        } else if (state is PlanError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {  // 👈 now state is in scope
        return Stack(
          children: [
            Scaffold(
              backgroundColor: isDark ? colorScheme.surface : Colors.white,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (currentPage > 0) {
                                setState(() {
                                  currentPage--;
                                });
                              }
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Workout Plan',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppConstants.fontRegular,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E3A5F)
                                  : const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${currentPage + 1} of 8',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppConstants.fontRegular,
                                color: isDark
                                    ? const Color(0xFF90CAF9)
                                    : const Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      Expanded(child: _getCurrentPage(isDark)),

                      const SizedBox(height: 20),
                      CommonButton(
                        title: currentPage < 11 ? 'Continue' : 'Submit',
                        onPressed: _onContinuePressed,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 👇 now state is accessible here
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
                            valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
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
    );
  }
  WorkoutPlanGenerationRequest? _lastRequest;

  void _submitWorkoutPreferences() {
    final request = WorkoutPlanGenerationRequest(
      durationWeeks: _durationWeeks,
      workoutPreferences: WorkoutPreferences(
        workoutDaysPerWeek: int.parse(_selectedDays),
        workoutLocation: WorkoutLocation.fromString(_selectedWorkoutLocation),
        equipmentAvailability:
        EquipmentAvailability.fromString(_selectedEquipment ?? ''),
        workoutFocus: WorkoutFocus.fromString(_selectedWorkoutFocus),
        workoutDifficulty:
        WorkoutDifficulty.fromString(_selectedDifficulty ?? ''),
        sessionDurationMinutes: _sessionDuration,
        focusAreas: focusAreas.isEmpty ? null : focusAreas,
      ),
    );
    _lastRequest = request; // 👈 store it
    context.read<PlanBloc>().add(SubmitWorkoutPreferencesEvent(request));
  }

  void _onContinuePressed() {
    if (currentPage < 7) {
      setState(() => currentPage++);
    } else {
      _submitWorkoutPreferences();
    }
  }

  Widget _getCurrentPage(bool isDark) {
    switch (currentPage) {
      case 0:
        return _buildDurationWeeksPage(isDark);
      case 1:
        return _buildWorkoutsPerWeekPage(isDark);
      case 2:
        return _buildWorkoutLocationPage(isDark);
      case 3:
        return _buildEquipmentAvailabilityPage(isDark);
      case 4:
        return _buildWorkoutFocusPage(isDark);
      case 5:
        return _buildWorkoutDifficultyPage(isDark);
      case 6:
        return _buildSessionDurationPage(isDark);
      case 7:
        return _buildFocusAreasPage(isDark);

      default:
        return const SizedBox.shrink();
    }
  }

  // Page 1: Custom Calorie Target

  // Page 2: Meals Per Day
  Widget _buildWorkoutsPerWeekPage(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textAlign: TextAlign.center,
          'How many days/wk will you commit?',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            height: 1.2,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        Center(
          child: Text('${_selectedDays}x',
              style: TextStyle(
                fontSize: 256,
                fontFamily: AppConstants.fontRegular,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black,
              )),
        ),
        const SizedBox(height: 30),
        LayoutBuilder(
          builder: (context, constraints) {
            final buttonWidth = constraints.maxWidth / 7;
            final index = ((int.tryParse(_selectedDays) ?? 1) - 1).clamp(0, 6);

            return Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    left: index * buttonWidth,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: buttonWidth,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFB7C9E2),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(7, (index) {
                      final day = (index + 1).toString();
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedDays = day),
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                color: _selectedDays == day
                                    ? Colors.white
                                    : (isDark ? Colors.white60 : Colors.grey[600]),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 32),
        Center(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                fontFamily: AppConstants.fontRegular,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
              children: [
                TextSpan(text: 'I\'m commited to excersing '),
                TextSpan(
                  text: '${_selectedDays}x',
                  style: TextStyle(fontWeight: AppConstants.extraBold),
                ),
                TextSpan(text: ' weekly'),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildComplexityOption({
    required String title,
    required String icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor
              : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white54 : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
              : null,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppConstants.fontRegular,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white : Colors.black),
                ),
                child: Text(title),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                opacity: isSelected ? 0.5 : 0.3,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontSize: isSelected ? 44 : 40,
                  ),
                  child: Text(icon),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Page 4: Cuisine Preference

  Widget _buildCuisineOption({
    required String title,
    required String icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor
              : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white54 : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              style: TextStyle(
                fontSize: isSelected ? 44 : 40,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white38 : Colors.grey[400]),
              ),
              child: Text(icon),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppConstants.fontRegular,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white60 : Colors.grey[600]),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppConstants.fontRegular,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white60 : Colors.grey[600]),
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

// Add this to your state class

  // Page 5: Exclude Ingredients
  Widget _buildFocusAreasPage(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
          child: Text(
            "Have you got any areas you want to focus on?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontFamily: AppConstants.fontRegular,
              // Uncomment when you have this
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        Container(
          height: 196,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(
            'assets/images/gym workout emblem.png',
            fit: BoxFit.contain,
          ),
        ),
        TagInputWidget(
          initialValues: focusAreas, // Add this line
          onChanged: (values) {
            focusAreas = values;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEquipmentAvailabilityPage(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What equipment do you have access to?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            height: 1.2,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        Column(
          children: [
            _buildEquipmentOption(
              title: 'Full Gym Equipment',
              subtitle: 'Complete gym access',
              icon: '🏋️',
              isSelected: _selectedEquipment == 'Full Gym Equipment',
              isDark: isDark,
              onTap: () =>
                  setState(() => _selectedEquipment = 'Full Gym Equipment'),
            ),
            const SizedBox(height: 16),
            _buildEquipmentOption(
              title: 'Basic Equipment',
              subtitle: 'Dumbbells, resistance bands',
              icon: '🎯',
              isSelected: _selectedEquipment == 'Basic Equipment',
              isDark: isDark,
              onTap: () =>
                  setState(() => _selectedEquipment = 'Basic Equipment'),
            ),
            const SizedBox(height: 16),
            _buildEquipmentOption(
              title: 'No Equipment',
              subtitle: 'Bodyweight workouts only',
              icon: '🤸',
              isSelected: _selectedEquipment == 'No Equipment',
              isDark: isDark,
              onTap: () => setState(() => _selectedEquipment = 'No Equipment'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEquipmentOption({
    required String title,
    required String subtitle,
    required String icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor
              : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white54 : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppConstants.fontRegular,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white : Colors.black),
                    ),
                    child: Text(title),
                  ),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppConstants.fontRegular,
                      color: isSelected
                          ? Colors.white70
                          : (isDark ? Colors.white60 : Colors.grey[600]),
                    ),
                    child: Text(subtitle),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              opacity: isSelected ? 1.0 : 0.4,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: isSelected ? 48 : 44,
                ),
                child: Text(icon),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutFocusPage(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s your workout focus?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            height: 1.2,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        _buildWorkoutOption(
          title: 'Strength Training',
          icon: Icons.fitness_center,
          description: 'Build muscle & power',
          isSelected: _selectedWorkoutFocus == 'Strength Training',
          isDark: isDark,
          onTap: () =>
              setState(() => _selectedWorkoutFocus = 'Strength Training'),
        ),
        _buildWorkoutOption(
          title: 'Cardio-\nvascular',
          icon: Icons.favorite,
          description: 'Improve endurance',
          isSelected: _selectedWorkoutFocus == 'Cardiovascular',
          isDark: isDark,
          onTap: () => setState(() => _selectedWorkoutFocus = 'Cardiovascular'),
        ),
        _buildWorkoutOption(
          title: 'Flexibility',
          icon: Icons.self_improvement,
          description: 'Enhance mobility',
          isSelected: _selectedWorkoutFocus == 'Flexibility',
          isDark: isDark,
          onTap: () => setState(() => _selectedWorkoutFocus = 'Flexibility'),
        ),
        _buildWorkoutOption(
          title: 'Hybrid',
          icon: Icons.stars,
          description: 'Balanced approach',
          isSelected: _selectedWorkoutFocus == 'Hybrid',
          isDark: isDark,
          onTap: () => setState(() => _selectedWorkoutFocus = 'Hybrid'),
        ),
        _buildWorkoutOption(
          title: 'Sport Specific',
          icon: Icons.sports_soccer,
          description: 'Sport-focused training',
          isSelected: _selectedWorkoutFocus == 'Sport Specific',
          isDark: isDark,
          onTap: () => setState(() => _selectedWorkoutFocus = 'Sport Specific'),
        ),
      ],
    );
  }

  Widget _buildWorkoutOption({
    required String title,
    required IconData icon,
    required String description,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF6B35)
              : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[200]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white54 : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.3)
                    : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.white54 : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white60 : Colors.grey[600]),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppConstants.fontRegular,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white : Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                fontFamily: AppConstants.fontRegular,
                color: isSelected
                    ? Colors.white.withOpacity(0.9)
                    : (isDark ? Colors.white60 : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutLocationPage(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where will you perform workouts?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            height: 1.2,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            _buildLocationOption(
              title: 'Gym',
              icon: '🏋️',
              isSelected: _selectedWorkoutLocation == 'Gym',
              isDark: isDark,
              onTap: () => setState(() => _selectedWorkoutLocation = 'Gym'),
            ),
            _buildLocationOption(
              title: 'Home',
              icon: '🏠',
              isSelected: _selectedWorkoutLocation == 'Home',
              isDark: isDark,
              onTap: () => setState(() => _selectedWorkoutLocation = 'Home'),
            ),
            _buildLocationOption(
              title: 'Outdoor',
              icon: '🌳',
              isSelected: _selectedWorkoutLocation == 'Outdoor',
              isDark: isDark,
              onTap: () => setState(() => _selectedWorkoutLocation = 'Outdoor'),
            ),
            _buildLocationOption(
              title: 'Hybrid',
              icon: '🔀',
              isSelected: _selectedWorkoutLocation == 'Hybrid',
              isDark: isDark,
              onTap: () => setState(() => _selectedWorkoutLocation = 'Hybrid'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationOption({
    required String title,
    required String icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor
              : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white54 : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
              : null,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppConstants.fontRegular,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white : Colors.black),
                ),
                child: Text(title),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                opacity: isSelected ? 0.5 : 0.3,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontSize: isSelected ? 44 : 40,
                  ),
                  child: Text(icon),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutDifficultyPage(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s your workout intensity level?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            height: 1.2,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        Column(
          children: [
            _buildDifficultyOption(
              title: 'Beginner',
              subtitle: 'Just starting out',
              icon: '🌱',
              isSelected: _selectedDifficulty == 'Beginner',
              isDark: isDark,
              onTap: () => setState(() => _selectedDifficulty = 'Beginner'),
            ),
            const SizedBox(height: 16),
            _buildDifficultyOption(
              title: 'Intermediate',
              subtitle: 'Regular training',
              icon: '💪',
              isSelected: _selectedDifficulty == 'Intermediate',
              isDark: isDark,
              onTap: () => setState(() => _selectedDifficulty = 'Intermediate'),
            ),
            const SizedBox(height: 16),
            _buildDifficultyOption(
              title: 'Advanced',
              subtitle: 'Intense workouts',
              icon: '🔥',
              isSelected: _selectedDifficulty == 'Advanced',
              isDark: isDark,
              onTap: () => setState(() => _selectedDifficulty = 'Advanced'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDifficultyOption({
    required String title,
    required String subtitle,
    required String icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor
              : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white54 : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppConstants.fontRegular,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white : Colors.black),
                    ),
                    child: Text(title),
                  ),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppConstants.fontRegular,
                      color: isSelected
                          ? Colors.white70
                          : (isDark ? Colors.white60 : Colors.grey[600]),
                    ),
                    child: Text(subtitle),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              opacity: isSelected ? 1.0 : 0.4,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: isSelected ? 48 : 44,
                ),
                child: Text(icon),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionDurationPage(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s your target session duration?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            height: 1.2,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 48),
        Center(
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '⏱️',
                      style: TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 12),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConstants.fontRegular,
                        color: Colors.white,
                      ),
                      child: Text('$_sessionDuration'),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'minutes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppConstants.fontRegular,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: AppConstants.primaryColor,
                        inactiveTrackColor: isDark
                            ? const Color(0xFF3A3A3A)
                            : Colors.grey[300],
                        thumbColor: AppConstants.primaryColor,
                        overlayColor:
                        AppConstants.primaryColor.withOpacity(0.2),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 14,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 28,
                        ),
                        trackHeight: 6,
                      ),
                      child: Slider(
                        value: _sessionDuration.toDouble(),
                        min: 15,
                        max: 180,
                        divisions: 33,
                        onChanged: (value) {
                          setState(() {
                            _sessionDuration = value.round();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '15 min',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppConstants.fontRegular,
                            color: isDark ? Colors.white60 : Colors.grey[600],
                          ),
                        ),
                        Text(
                          '180 min',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppConstants.fontRegular,
                            color: isDark ? Colors.white60 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _buildQuickSelectButton(30, isDark),
                  _buildQuickSelectButton(45, isDark),
                  _buildQuickSelectButton(60, isDark),
                  _buildQuickSelectButton(90, isDark),
                  _buildQuickSelectButton(120, isDark),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSelectButton(int minutes, bool isDark) {
    final isSelected = _sessionDuration == minutes;

    return GestureDetector(
      onTap: () => setState(() => _sessionDuration = minutes),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor
              : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[200]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white54 : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ]
              : null,
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: AppConstants.fontRegular,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white : Colors.black),
          ),
          child: Text('$minutes min'),
        ),
      ),
    );
  }

  Widget _buildDurationWeeksPage(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How many weeks do you want your plan to be?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            height: 1.2,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: [
            _buildWeekCard(4, '1 Month', isDark),
            _buildWeekCard(8, '2 Months', isDark),
            _buildWeekCard(12, '3 Months', isDark),
            _buildWeekCard(16, '4 Months', isDark),
            _buildWeekCard(24, '6 Months', isDark),
            _buildWeekCard(52, '1 Year', isDark),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF3A3A3A) : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '✏️',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Custom Duration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppConstants.fontRegular,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isCustomWeeks
                              ? AppConstants.primaryColor
                              : (isDark ? const Color(0xFF3A3A3A) : Colors.grey[300]!),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_customWeeks > 1) {
                                setState(() {
                                  _customWeeks--;
                                  _durationWeeks = _customWeeks;
                                  _isCustomWeeks = true;
                                });
                              }
                            },
                            icon: const Icon(Icons.remove_circle_outline,
                                size: 28),
                            color: AppConstants.primaryColor,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '$_customWeeks',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppConstants.fontRegular,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: () {
                              if (_customWeeks < 52) {
                                setState(() {
                                  _customWeeks++;
                                  _durationWeeks = _customWeeks;
                                  _isCustomWeeks = true;
                                });
                              }
                            },
                            icon:
                            const Icon(Icons.add_circle_outline, size: 28),
                            color: AppConstants.primaryColor,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _customWeeks == 1 ? 'week' : 'weeks',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppConstants.fontRegular,
                    color: isDark ? Colors.white60 : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekCard(int weeks, String label, bool isDark) {
    final isSelected = _durationWeeks == weeks && !_isCustomWeeks;

    return GestureDetector(
      onTap: () {
        setState(() {
          _durationWeeks = weeks;
          _customWeeks = weeks;
          _isCustomWeeks = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor
              : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.white54
                : (isDark ? const Color(0xFF3A3A3A) : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: AppConstants.fontRegular,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black),
              ),
              child: Text('$weeks'),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: AppConstants.fontRegular,
                color: isSelected
                    ? Colors.white70
                    : (isDark ? Colors.white60 : Colors.grey[600]),
              ),
              child: Text(weeks == 1 ? 'week' : 'weeks'),
            ),
            const SizedBox(height: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: AppConstants.fontRegular,
                color: isSelected ? Colors.white : AppConstants.primaryColor,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}