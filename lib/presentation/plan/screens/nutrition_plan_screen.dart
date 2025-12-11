import 'package:fitmind/presentation/authentication/widgets/common_button.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../assessment/widgets/tag_input_widget.dart';

class NutritionPlanScreen extends StatefulWidget {
  const NutritionPlanScreen({Key? key}) : super(key: key);

  @override
  State<NutritionPlanScreen> createState() => _NutritionPlanScreenState();
}

class _NutritionPlanScreenState extends State<NutritionPlanScreen> {
  int currentPage = 0;

  // Nutrition plan data
  int? customCalorieTarget;
  String _selectedUnit = "";
  String _selectedDays = "";
  String _selectedComplexity = '';
  List<String> diets = [];
  String _selectedCuisine = '';
  String prefferedCalorieMethod = "Custom";
  int _calorieTarget = 1550;
  bool _isIncrementing = true;

  int? mealsPerDay;
  String? mealComplexity;
  String? cuisinePreference;
  List<String> excludeIngredients = [];

  // Input controllers
  final TextEditingController calorieController = TextEditingController();
  final TextEditingController ingredientController = TextEditingController();

  @override
  void dispose() {
    calorieController.dispose();
    ingredientController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    child: const Icon(Icons.arrow_back_ios, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Nutrition Plan',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${currentPage + 1} of 5',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Content based on current page
              Expanded(child: _getCurrentPage()),

              // Continue Button
              const SizedBox(height: 20),
              CommonButton(
                title: currentPage < 11 ? 'Continue' : 'Submit',
                onPressed: _onContinuePressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinuePressed() {
    if (currentPage < 4) {
      setState(() => currentPage++);
    } else {
      // Submit nutrition plan
      print('Nutrition Plan Data:');
      print('Calorie Target: $customCalorieTarget');
      print('Meals Per Day: $mealsPerDay');
      print('Meal Complexity: $mealComplexity');
      print('Cuisine Preference: $cuisinePreference');
      print('Exclude Ingredients: $excludeIngredients');

      // TODO: Send to backend or BLoC
    }
  }

  bool _canContinue() {
    switch (currentPage) {
      case 0:
        return _calorieTarget != null;
      case 1:
        return mealsPerDay != null;
      case 2:
        return mealComplexity != null;
      case 3:
        return cuisinePreference != null;
      case 4:
        return true; // Exclude ingredients is optional
      default:
        return false;
    }
  }

  Widget _getCurrentPage() {
    switch (currentPage) {
      case 0:
        return _buildCalorieTargetPage();
      case 1:
        return _buildMealsPerDayPage();
      case 2:
        return _buildMealComplexityPage();
      case 3:
        return _buildCuisinePreferencePage();
      case 4:
        return _buildExcludeIngredientsPage();
      default:
        return const SizedBox.shrink();
    }
  }

  // Page 1: Custom Calorie Target
  Widget _buildCalorieTargetPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          textAlign: TextAlign.center,
          'What is your daily calorie target?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          height: 64,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2 - 20,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey, width: 2),
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
                          "Kcal",
                          style: TextStyle(
                            color: _selectedUnit == "Kcal"
                                ? Colors.white
                                : Colors.grey[600],
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
                          "Joules",
                          style: TextStyle(
                            fontFamily: AppConstants.fontRegular,
                            color: _selectedUnit == "Joules"
                                ? Colors.white
                                : Colors.grey[600],
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
        const SizedBox(height: 48),
        // Calorie counter display
        Center(
          child: Column(
            children: [
              Text(
                _getDisplayValue(),
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontRegular,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'calories daily',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
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
                      : Colors.grey[200],
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
                      color: !_isIncrementing ? Colors.white : Colors.black54,
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
                      : Colors.grey[200],
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
                      color: _isIncrementing ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        AppConstants.verticalSpaceL,
        CommonButton(
            title: "Let the Ai Decide!",
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
  Widget _buildMealsPerDayPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          textAlign: TextAlign.center,
          'How many Meals do you want to eat in a day?',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            height: 1.2,
          ),
        ),
        Center(
          child: Text('${_selectedDays}x',
              style: const TextStyle(
                fontSize: 256,
                fontFamily: AppConstants.fontRegular,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              )),
        ),
        const SizedBox(height: 30),
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Animated background indicator
              AnimatedPositioned(
                left: _getLeftPosition(),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Container(
                  width: (MediaQuery
                      .of(context)
                      .size
                      .width - 40) / 4,
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
                                : Colors.grey[600],
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
                                : Colors.grey[600],
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
                                : Colors.grey[600],
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
                                : Colors.grey[600],
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
        SizedBox(height: 32),
        Center(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                fontFamily: AppConstants.fontRegular,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              children: [
                TextSpan(text: 'I want to eat '),
                TextSpan(
                text: '${_selectedDays}',
                  style: TextStyle(fontWeight: AppConstants.extraBold),
                ),
                TextSpan(text: ' meals Daily'),
              ],
            ),
          ),
        )
      ],
    );
  }

// Helper method to calculate the left position for the animated indicator
  double _getLeftPosition() {
    double buttonWidth = (MediaQuery
        .of(context)
        .size
        .width - 40) / 4;
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

  Widget _buildMealCountChip(int count) {
    final isSelected = mealsPerDay == count;
    return GestureDetector(
      onTap: () {
        setState(() {
          mealsPerDay = count;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white54 : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          '$count meals',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  // Page 3: Meal Complexity
  Widget _buildMealComplexityPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cooking time and complexity preference',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            height: 1.2,
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
              title: 'Quick',
              icon: '⚡',
              isSelected: _selectedComplexity == 'Quick',
              onTap: () => setState(() => _selectedComplexity = 'Quick'),
            ),
            _buildComplexityOption(
              title: 'Moderate',
              icon: '🍳',
              isSelected: _selectedComplexity == 'Moderate',
              onTap: () => setState(() => _selectedComplexity = 'Moderate'),
            ),
            _buildComplexityOption(
              title: 'Elaborate',
              icon: '👨‍🍳',
              isSelected: _selectedComplexity == 'Elaborate',
              onTap: () => setState(() => _selectedComplexity = 'Elaborate'),
            ),
            _buildComplexityOption(
              title: 'Mixed',
              icon: '🔀',
              isSelected: _selectedComplexity == 'Mixed',
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
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.primaryColor : Colors.grey[200],
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
                  color: isSelected ? Colors.white : Colors.black,
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
  Widget _buildCuisinePreferencePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select your cuisine preference',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            height: 1.2,
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
              title: 'Mediterranean',
              icon: '🫒',
              isSelected: _selectedCuisine == 'Mediterranean',
              onTap: () => setState(() => _selectedCuisine = 'Mediterranean'),
            ),
            _buildCuisineOption(
              title: 'Asian',
              icon: '🍜',
              isSelected: _selectedCuisine == 'Asian',
              onTap: () => setState(() => _selectedCuisine = 'Asian'),
            ),
            _buildCuisineOption(
              title: 'Western',
              icon: '🍔',
              isSelected: _selectedCuisine == 'Western',
              onTap: () => setState(() => _selectedCuisine = 'Western'),
            ),
            _buildCuisineOption(
              title: 'Middle Eastern',
              icon: '🧆',
              isSelected: _selectedCuisine == 'Middle Eastern',
              onTap: () => setState(() => _selectedCuisine = 'Middle Eastern'),
            ),
            _buildCuisineOption(
              title: 'Latin American',
              icon: '🌮',
              isSelected: _selectedCuisine == 'Latin American',
              onTap: () => setState(() => _selectedCuisine = 'Latin American'),
            ),
            _buildCuisineOption(
              title: 'Vegetarian',
              icon: '🥗',
              isSelected: _selectedCuisine == 'Vegetarian',
              onTap: () => setState(() => _selectedCuisine = 'Vegetarian'),
            ),
            _buildCuisineOption(
              title: 'Vegan',
              icon: '🌱',
              isSelected: _selectedCuisine == 'Vegan',
              onTap: () => setState(() => _selectedCuisine = 'Vegan'),
            ),
            _buildCuisineOption(
              title: 'Mixed',
              icon: '🔀',
              isSelected: _selectedCuisine == 'Mixed',
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
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.primaryColor : Colors.grey[200],
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
                color: isSelected ? Colors.white : Colors.grey[400],
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
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                  child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppConstants.fontRegular,
                    color: isSelected ? Colors.white : Colors.grey[600],
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
  Widget _buildExcludeIngredientsPage() {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Center(
        child: Text(
          "Do you want to exclude any ingredients from your plan?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontFamily: AppConstants.fontRegular,
            // Uncomment when you have this
            fontWeight: FontWeight.bold,
            height: 1.2,
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

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required String value,
    required String? selectedValue,
    required Function(String) onTap,
  }) {
    final isSelected = selectedValue == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: isSelected ? 1.03 : 1.0,
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color:
            isSelected ? const Color(0xFFFF6B35) : const Color(0xFFF5F5F5),
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
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
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

  Widget _buildContinueButton() {
    final canContinue = _canContinue();
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: canContinue ? _onContinuePressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6B35),
          disabledBackgroundColor: Colors.grey.shade300,
          elevation: canContinue ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          currentPage < 4 ? 'Continue' : 'Create Plan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: canContinue ? Colors.white : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}
