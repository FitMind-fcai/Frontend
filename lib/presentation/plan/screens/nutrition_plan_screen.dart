import 'dart:async';

import 'package:fitmind/presentation/authentication/widgets/common_button.dart';
import 'package:fitmind/presentation/plan/screens/workout_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/plan/nutrition_plan_generation_request.dart';
import '../../../data/models/plan/nutrition_plan_model.dart';
import '../../assessment/widgets/tag_input_widget.dart';
import '../manager/plan_bloc.dart';
import 'nutrition_plan_result_screen.dart';
import 'dart:ui' as ui;

class NutritionPlanScreen extends StatefulWidget {
  const NutritionPlanScreen({Key? key, required this.navigationStatus})
      : super(key: key);

  final String navigationStatus;

  @override
  State<NutritionPlanScreen> createState() => _NutritionPlanScreenState();
}

class _NutritionPlanScreenState extends State<NutritionPlanScreen> {
  int currentPage = 0;
  Timer? _loadingMessageTimer;
  int _loadingMessageIndex = 0;

  final List<String> _loadingMessages = [
    'nutrition.creating_plan'.tr(),
    'nutrition.analyzing_goals'.tr(),
    'nutrition.calculating_macros'.tr(),
    'nutrition.almost_ready'.tr(),
  ];

  void _startLoadingMessageCycle() {
    _loadingMessageTimer?.cancel();
    _loadingMessageIndex = 0;
    _loadingMessageTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (_loadingMessageIndex < _loadingMessages.length - 1) {
        setState(() {
          _loadingMessageIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }
  // Nutrition plan data
  int? customCalorieTarget;
  String _selectedUnit = "Kcal";
  String _selectedDays = "3";
  String _selectedComplexity = '';
  List<String> diets = [];
  String _selectedCuisine = '';
  String prefferedCalorieMethod = "Custom";
  int _calorieTarget = 1550;
  bool _isIncrementing = true;

  int _durationWeeks = 12;
  int _customWeeks = 12;
  bool _isCustomWeeks = false;

  // Input controllers
  final TextEditingController calorieController = TextEditingController();
  final TextEditingController ingredientController = TextEditingController();

  @override
  void dispose() {
    calorieController.dispose();
    ingredientController.dispose();
    _loadingMessageTimer?.cancel();
    super.dispose();
  }

  String _getDisplayValue() {
    int displayValue;

    if (_selectedUnit == "Kcal") {
      displayValue = _calorieTarget;
    } else {
      // Convert Kcal to Joules (1 kcal = 4184 joules)
      displayValue = (_calorieTarget * 4.184).round();
    }

    return displayValue.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<PlanBloc, PlanState>(
      listener: (context, state) {
        if (state is NutritionPreferencesSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('nutrition.plan_generated_success'.tr()),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => NutritionPlanResultScreen(
                plan: state.plan,
                navigationStatus: widget.navigationStatus,
                request: _lastRequest,
              ),
            ),
          );
        } else if (state is PlanError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is PlanLoading) {
          return _buildLoadingScreen();
        }
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
                                setState(() => currentPage--);
                              } else {
                                Navigator.pop(context);
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
                            'nutrition.title'.tr(),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E3A5F)
                                  : const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'nutrition.step_counter'.tr(
                                  namedArgs: {'step': '${currentPage + 1}'}),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
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
                        title: currentPage < 5
                            ? 'assessment.continue'.tr()
                            : 'assessment.submit'.tr(),
                        onPressed:
                            state is PlanLoading ? null : _onContinuePressed,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Loading overlay

          ],
        );
      },
    );
  }

  void _onContinuePressed() {
    if (currentPage < 5) {
      setState(() => currentPage++);
    } else {
      _startLoadingMessageCycle();
      _submitNutritionPreferences();
    }
  }

  NutritionPlanGenerationRequest? _lastRequest;

  void _submitNutritionPreferences() {
    final request = NutritionPlanGenerationRequest(
      durationWeeks: _durationWeeks,
      lang: context.locale.languageCode == 'ar' ? 'ar' : 'en',

      nutritionPreferences: NutritionPreferences(

        caloriePreference: CaloriePreference.fromString(prefferedCalorieMethod),
        customCalorieTarget:
            prefferedCalorieMethod == 'Custom' ? _calorieTarget : null,
        mealsPerDay: int.parse(_selectedDays),
        mealComplexity: MealComplexity.fromString(_selectedComplexity),
        cuisinePreference: CuisinePreference.fromString(_selectedCuisine),
        excludeIngredients: diets.isEmpty ? null : diets,
      ),
    );
    _lastRequest = request; // 👈 store it
    context.read<PlanBloc>().add(SubmitNutritionPreferencesEvent(request));
  }

  Widget _getCurrentPage(bool isDark) {
    switch (currentPage) {
      case 0:
        return _buildDurationWeeksPage(isDark);
      case 1:
        return _buildCalorieTargetPage(isDark);
      case 2:
        return _buildMealsPerDayPage(isDark);
      case 3:
        return _buildMealComplexityPage(isDark);
      case 4:
        return _buildCuisinePreferencePage(isDark);
      case 5:
        return _buildExcludeIngredientsPage(isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  // Page 1: Custom Calorie Target
  Widget _buildCalorieTargetPage(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textAlign: TextAlign.center,
          'nutrition.calorie_target_question'.tr(),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            height: 1.2,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          height: 64,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Stack(
              children: [
                // Animated background indicator
                AnimatedAlign(
                  alignment: _selectedUnit == "Kcal"
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    height: 64,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white38 : Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                // Toggle buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedUnit = "Kcal");
                        },
                        child: Container(
                          height: 64,
                          alignment: Alignment.center,
                          child: Text(
                            'nutrition.unit_kcal'.tr(),
                            style: TextStyle(
                              color: _selectedUnit == "Kcal"
                                  ? (isDark ? Colors.black : Colors.white)
                                  : (isDark
                                      ? Colors.white60
                                      : Colors.grey[600]),
                              fontSize: 18,
                              fontFamily: AppConstants.fontRegular,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedUnit = "Joules");
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            'nutrition.unit_joules'.tr(),
                            style: TextStyle(
                              fontFamily: AppConstants.fontRegular,
                              color: _selectedUnit == "Joules"
                                  ? (isDark ? Colors.black : Colors.white)
                                  : (isDark
                                      ? Colors.white60
                                      : Colors.grey[600]),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 48),
        // Calorie counter display
        Center(
          child: Column(
            children: [
              Text(
                _getDisplayValue(),
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontRegular,
                  height: 1,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'nutrition.calories_daily'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                  fontFamily: AppConstants.fontRegular,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Counter buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decrement button
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_calorieTarget > 50) {
                    _calorieTarget -= 50;
                    _isIncrementing = false;
                  }
                });
              },
              child: Container(
                width: 112,
                height: 64,
                decoration: BoxDecoration(
                  color: !_isIncrementing
                      ? AppConstants.primaryColor
                      : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        !_isIncrementing ? Colors.white54 : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '−',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: !_isIncrementing
                          ? Colors.white
                          : (isDark ? Colors.white54 : Colors.black54),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Increment button
            GestureDetector(
              onTap: () {
                setState(() {
                  _calorieTarget += 50;
                  _isIncrementing = true;
                });
              },
              child: Container(
                width: 112,
                height: 64,
                decoration: BoxDecoration(
                  color: _isIncrementing
                      ? AppConstants.primaryColor
                      : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        _isIncrementing ? Colors.white54 : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: _isIncrementing
                          ? Colors.white
                          : (isDark ? Colors.white54 : Colors.black54),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        AppConstants.verticalSpaceL,
        CommonButton(
            title: 'nutrition.let_ai_decide'.tr(),
            onPressed: () {
              setState(() {
                currentPage++;
                prefferedCalorieMethod = 'Auto';
              });
            }),
      ],
    );
  }

  // Page 2: Meals Per Day
  Widget _buildMealsPerDayPage(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textAlign: TextAlign.center,
            'nutrition.meals_per_day_question'.tr(),
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
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Directionality(
              textDirection: ui.TextDirection.ltr,
              child: Stack(
                children: [
                  // Animated background indicator
                  AnimatedPositioned(
                    left: _getLeftPosition(),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 40) / 4,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFFB7C9E2), width: 2),
                      ),
                    ),
                  ),
                  // Toggle buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedDays = "3");
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              "3",
                              style: TextStyle(
                                color: _selectedDays == "3"
                                    ? Colors.white
                                    : (isDark
                                        ? Colors.white60
                                        : Colors.grey[600]),
                                fontSize: 16,
                                fontFamily: AppConstants.fontRegular,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedDays = "4");
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              "4",
                              style: TextStyle(
                                fontFamily: AppConstants.fontRegular,
                                color: _selectedDays == "4"
                                    ? Colors.white
                                    : (isDark
                                        ? Colors.white60
                                        : Colors.grey[600]),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedDays = "5");
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              "5",
                              style: TextStyle(
                                color: _selectedDays == "5"
                                    ? Colors.white
                                    : (isDark
                                        ? Colors.white60
                                        : Colors.grey[600]),
                                fontSize: 16,
                                fontFamily: AppConstants.fontRegular,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedDays = "6");
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              "6",
                              style: TextStyle(
                                color: _selectedDays == "6"
                                    ? Colors.white
                                    : (isDark
                                        ? Colors.white60
                                        : Colors.grey[600]),
                                fontSize: 16,
                                fontFamily: AppConstants.fontRegular,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32),
          Center(
            child: Text(
              'nutrition.meals_daily_message'
                  .tr(namedArgs: {'count': _selectedDays}),
              style: TextStyle(
                fontSize: 16,
                fontFamily: AppConstants.fontRegular,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Helper method to calculate the left position for the animated indicator
  double _getLeftPosition() {
    double buttonWidth = (MediaQuery.of(context).size.width - 40) / 4;
    switch (_selectedDays) {
      case "3":
        return 0;
      case "4":
        return buttonWidth;
      case "5":
        return buttonWidth * 2;
      case "6":
        return buttonWidth * 3;
      default:
        return 0;
    }
  }

  // Page 3: Meal Complexity
  Widget _buildMealComplexityPage(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'nutrition.complexity_question'.tr(),
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
            _buildComplexityOption(
              title: 'nutrition.complexity_quick'.tr(),
              icon: '⚡',
              isSelected: _selectedComplexity == 'Quick',
              isDark: isDark,
              onTap: () => setState(() => _selectedComplexity = 'Quick'),
            ),
            _buildComplexityOption(
              title: 'nutrition.complexity_moderate'.tr(),
              icon: '🍳',
              isSelected: _selectedComplexity == 'Moderate',
              isDark: isDark,
              onTap: () => setState(() => _selectedComplexity = 'Moderate'),
            ),
            _buildComplexityOption(
              title: 'nutrition.complexity_elaborate'.tr(),
              icon: '👨‍🍳',
              isSelected: _selectedComplexity == 'Elaborate',
              isDark: isDark,
              onTap: () => setState(() => _selectedComplexity = 'Elaborate'),
            ),
            _buildComplexityOption(
              title: 'nutrition.complexity_mixed'.tr(),
              icon: '🔀',
              isSelected: _selectedComplexity == 'Mixed',
              isDark: isDark,
              onTap: () => setState(() => _selectedComplexity = 'Mixed'),
            ),
          ],
        ),
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
  Widget _buildCuisinePreferencePage(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'nutrition.cuisine_question'.tr(),
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
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.90,
          children: [
            _buildCuisineOption(
              title: 'nutrition.cuisine_mediterranean'.tr(),
              icon: '🫒',
              isSelected: _selectedCuisine == 'Mediterranean',
              isDark: isDark,
              onTap: () => setState(() => _selectedCuisine = 'Mediterranean'),
            ),
            _buildCuisineOption(
              title: 'nutrition.cuisine_asian'.tr(),
              icon: '🍜',
              isSelected: _selectedCuisine == 'Asian',
              isDark: isDark,
              onTap: () => setState(() => _selectedCuisine = 'Asian'),
            ),
            _buildCuisineOption(
              title: 'nutrition.cuisine_western'.tr(),
              icon: '🍔',
              isSelected: _selectedCuisine == 'Western',
              isDark: isDark,
              onTap: () => setState(() => _selectedCuisine = 'Western'),
            ),
            _buildCuisineOption(
              title: 'nutrition.cuisine_middle_eastern'.tr(),
              icon: '🧆',
              isSelected: _selectedCuisine == 'Middle Eastern',
              isDark: isDark,
              onTap: () => setState(() => _selectedCuisine = 'Middle Eastern'),
            ),
            _buildCuisineOption(
              title: 'nutrition.cuisine_latin_american'.tr(),
              icon: '🌮',
              isSelected: _selectedCuisine == 'Latin American',
              isDark: isDark,
              onTap: () => setState(() => _selectedCuisine = 'Latin American'),
            ),
            _buildCuisineOption(
              title: 'nutrition.cuisine_vegetarian'.tr(),
              icon: '🥗',
              isSelected: _selectedCuisine == 'Vegetarian',
              isDark: isDark,
              onTap: () => setState(() => _selectedCuisine = 'Vegetarian'),
            ),
            _buildCuisineOption(
              title: 'nutrition.cuisine_vegan'.tr(),
              icon: '🌱',
              isSelected: _selectedCuisine == 'Vegan',
              isDark: isDark,
              onTap: () => setState(() => _selectedCuisine = 'Vegan'),
            ),
            _buildCuisineOption(
              title: 'nutrition.complexity_mixed'.tr(),
              icon: '🔀',
              isSelected: _selectedCuisine == 'Mixed',
              isDark: isDark,
              onTap: () => setState(() => _selectedCuisine = 'Mixed'),
            ),
          ],
        ),
      ],
    );
  }

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
                    fontSize: 12,
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
  Widget _buildExcludeIngredientsPage(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
          child: Text(
            'nutrition.exclude_ingredients_question'.tr(),
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
          child: isDark
              ? null
              : Image.asset(
                  'assets/images/diet.jpg',
                  fit: BoxFit.contain,
                ),
        ),
        TagInputWidget(
          initialValues: diets, // Add this line
          onChanged: (values) {
            diets = values;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDurationWeeksPage(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'nutrition.duration_question'.tr(),
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
              _buildWeekCard(4, 'nutrition.month_1'.tr(), isDark),
              _buildWeekCard(8, 'nutrition.months_2'.tr(), isDark),
              _buildWeekCard(12, 'nutrition.months_3'.tr(), isDark),
              _buildWeekCard(16, 'nutrition.months_4'.tr(), isDark),
              _buildWeekCard(24, 'nutrition.months_6'.tr(), isDark),
              _buildWeekCard(52, 'nutrition.year_1'.tr(), isDark),
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
                        'nutrition.custom_duration'.tr(),
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
                                : (isDark
                                    ? const Color(0xFF3A3A3A)
                                    : Colors.grey[300]!),
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
                    _customWeeks == 1 ? 'nutrition.week_singular'.tr() : 'nutrition.week_plural'.tr(),
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
      ),
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
              child: Text(weeks == 1 ? 'nutrition.week_singular'.tr() : 'nutrition.week_plural'.tr()),            ),
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
  Widget _buildLoadingScreen() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark?Colors.black:Colors.white,
      body: Center(
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
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                _loadingMessages[_loadingMessageIndex],
                key: ValueKey(_loadingMessageIndex),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: AppConstants.fontRegular,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
