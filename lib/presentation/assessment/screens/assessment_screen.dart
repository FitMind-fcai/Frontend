import 'package:fitmind/core/constants/app_constants.dart';
import 'package:fitmind/presentation/authentication/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unit_ruler/flutter_unit_ruler.dart';

import '../../../data/data_sources/local/auth_local_data_source.dart';
import '../../../data/models/profile_body.dart';
import '../../profile/manager/profile_bloc.dart';
import '../widgets/height_ruler.dart';
import '../widgets/tag_input_widget.dart';
import '../widgets/weight_ruler.dart';
import '../widgets/tag_chip.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({Key? key}) : super(key: key);

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  int currentPage = 0;
  String? selectedGoal;
  String? selectedGender;
  String _selectedUnit = 'kg';
  double? weight;
  FixedExtentScrollController   _ageController = FixedExtentScrollController();

  int selectedAge = 0;
  List<String> physicalLimitations = [];
  List<String> medicalConditions = [];
  List<String> allergies = [];
  List<String> diets = [];
  List<String> medications = [];
  String _selectedHeightUnit = "cm";
  double? height;

  double kgToLbs(double kg) => kg * 2.20462;

  double lbsToKg(double lbs) => lbs * 0.45359237;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoading) {
          showDialog(
            context: context,
            builder: (_) => const Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );
        } else if (state is ProfileSuccess) {
          Navigator.pop(context); // remove loading
          Navigator.pushReplacementNamed(context, '/home'); // navigate
        } else if (state is ProfileError) {
          Navigator.pop(context); // remove loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
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
                      'Assessment',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
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
                        '${currentPage + 1} of 11',
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
                  title: currentPage < 9 ? 'Continue' : 'Submit',
                  onPressed: _onContinuePressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onContinuePressed() async {
    if (currentPage < 10) {
      setState(() => currentPage++);
    } else {
      // Get cached user
      final authLocal = AuthLocalDataSourceImpl();
      final cachedUser = await authLocal.getCachedUser();
      print("🔍 Cached User: $cachedUser");
      print("🔍 User ID: ${cachedUser?.id}");
      print("🔍 User toJson: ${cachedUser?.toJson()}");

      if (cachedUser?.id == null) {
        print("No cached user ID found");
        return;
      }

      final profile = ProfileBody(
        userId: cachedUser!.id!,
        // replace with actual user ID
        age: selectedAge,
        height: height ?? 0,
        // replace with actual height input if available
        weight: weight ?? 0,
        gender: selectedGender == 'male' ? Gender.Male : Gender.Female,
        fitnessGoal: selectedGoal == 'lose_weight'
            ? FitnessGoal.LoseWeight
            : selectedGoal == 'get_bulks'
                ? FitnessGoal.BuildMuscle
                : FitnessGoal.MaintainWeight,
        activityLevel: ActivityLevel.Sedentary,
        // replace with actual selection
        dietaryPreferences: diets,
        medicalConditions: medicalConditions,
        allergies: allergies,
        injuries: physicalLimitations,
        medications: medications,
      );

      // Dispatch BLoC event
      context.read<ProfileBloc>().add(SubmitProfileEvent(profile));
    }
  }

  Widget _getCurrentPage() {
    switch (currentPage) {
      case 0:
        return _buildGoalPage();
      case 1:
        return _buildGenderPage();
      case 2:
        return _buildWeightPage();
      case 3:
        return _buildHeightPage();
      case 4:
        return _buildActivityLeveLPage();
      case 5:
        return _buildAgeScroll();
      case 6:
        return _physicalTagInput();
      case 7:
        return _medicalConditionInput();
      case 8:
        return _AllergiesInput();
      case 9:
        return _dietInput();
      case 10:
        return _medicationsInput();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildGoalPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          textAlign: TextAlign.center,
          "What's your fitness goal/target?",
          style: TextStyle(
            fontSize: 32,
            fontFamily: AppConstants.fontRegular,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView(
            children: [
              _buildOptionTile(
                icon: const AssetImage('assets/images/coldair.png'),
                label: 'Lose Weight',
                value: 'lose_weight',
                isGoal: true,
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: const AssetImage('assets/images/robothead.png'),
                label: 'I wanna try AI Coach',
                value: 'ai_coach',
                isGoal: true,
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: const AssetImage('assets/images/dumbbell.png'),
                label: 'I wanna get bulks',
                value: 'get_bulks',
                isGoal: true,
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: const AssetImage('assets/images/heartbeats.png'),
                label: 'I wanna gain endurance',
                value: 'gain_endurance',
                isGoal: true,
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: const AssetImage('assets/images/Solid head heart.png'),
                label: 'Just trying out the app! 👍',
                value: 'trying_app',
                isGoal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityLeveLPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          textAlign: TextAlign.center,
          "What's your fitness Level",
          style: TextStyle(
            fontSize: 32,
            fontFamily: AppConstants.fontRegular,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView(
            children: [
              _buildOptionTile(
                icon: const AssetImage('assets/images/coldair.png'),
                label: 'Sedentary',
                value: 'lose_weight',
                isGoal: true,
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: const AssetImage('assets/images/robothead.png'),
                label: 'Lightly Active',
                value: 'ai_coach',
                isGoal: true,
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: const AssetImage('assets/images/dumbbell.png'),
                label: 'Moderately Active',
                value: 'get_bulks',
                isGoal: true,
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: const AssetImage('assets/images/heartbeats.png'),
                label: 'Very Active',
                value: 'Extra Active',
                isGoal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What is your gender?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontFamily: AppConstants.fontRegular,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView(
            children: [
              _buildGenderCard(
                gender: 'Male',
                imagePath:
                    'assets/images/man running with shirt that says jogger it.png',
                value: 'male',
              ),
              const SizedBox(height: 16),
              _buildGenderCard(
                gender: 'Female',
                imagePath:
                    'assets/images/woman running sportswear with white background.png',
                value: 'female',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required ImageProvider icon,
    required String label,
    required String value,
    required bool isGoal,
  }) {
    final isSelected = isGoal ? selectedGoal == value : selectedGender == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isGoal) {
            selectedGoal = value;
          } else {
            selectedGender = value;
          }
        });
      },
      child: Container(
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
            ImageIcon(
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
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Container(
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
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Color(0xFFFF6B35))
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderCard({
    required String gender,
    required String imagePath,
    required String value,
  }) {
    final isSelected = selectedGender == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = value;
        });
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
            width: 3,
          ),
        ),
        child: Stack(
          children: [
            // Image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                  ),
                ),
              ),
            ),
            // Gender label and icon
            Positioned(
              left: 16,
              top: 16,
              child: Row(
                children: [
                  Icon(
                    gender == 'Male' ? Icons.male : Icons.female,
                    color: Colors.black87,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    gender,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppConstants.fontRegular,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Checkbox
            Positioned(
              left: 16,
              bottom: 16,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected ? const Color(0xFFFF6B35) : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFF6B35)
                        : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What is your weight?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontFamily: AppConstants.fontRegular,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          height: 50,
          width: double.infinity, // Adjust width as needed
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Animated background indicator
              AnimatedAlign(
                alignment: _selectedUnit == "kg"
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 - 20,
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
                        setState(() => _selectedUnit = "kg");
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "kg",
                          style: TextStyle(
                            color: _selectedUnit == "kg"
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
                        setState(() => _selectedUnit = "lbs");
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "lbs",
                          style: TextStyle(
                            fontFamily: AppConstants.fontRegular,
                            color: _selectedUnit == "lbs"
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
        WeightPicker(
          unit: _selectedUnit,
          initialValue: weight,
          onChanged: (value) {
            setState(() {
              weight = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildHeightPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What is your height?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontFamily: AppConstants.fontRegular,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 32),
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
              AnimatedAlign(
                alignment: _selectedHeightUnit == "cm"
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 - 20,
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
                        setState(() => _selectedHeightUnit = "cm");
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "cm",
                          style: TextStyle(
                            color: _selectedHeightUnit == "cm"
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
                        setState(() => _selectedHeightUnit = "ft");
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "ft",
                          style: TextStyle(
                            fontFamily: AppConstants.fontRegular,
                            color: _selectedHeightUnit == "ft"
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
        HeightPicker(
          unit: _selectedHeightUnit,
          initialValue: height,
          onChanged: (value) {
            setState(() {
              height = value;
            });
          },
        ),
      ],
    );
  }

  final ValueNotifier<int> selectedAgeNotifier = ValueNotifier<int>(25);

  Widget _buildAgeScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_ageController.hasClients && _ageController.positions.isNotEmpty) {
        _ageController.jumpToItem(selectedAgeNotifier.value);
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        const Text(
          "What is your Age?",
          style: TextStyle(
            fontSize: 32,
            fontFamily: AppConstants.fontRegular,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated orange container
              ValueListenableBuilder<int>(
                valueListenable: selectedAgeNotifier,
                builder: (context, selectedAge, _) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: selectedAge % 2 == 0 ? 290 : 285,
                    height: selectedAge % 2 == 0 ? 165 : 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                      borderRadius: BorderRadius.circular(32),
                    ),
                  );
                },
              ),

              // Scrollable numbers
              ListWheelScrollView.useDelegate(
                controller: _ageController,
                itemExtent: 160,
                perspective: 0.005,
                diameterRatio: 3,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  selectedAgeNotifier.value =
                      index; // <- updates without setState
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    return ValueListenableBuilder<int>(
                      valueListenable: selectedAgeNotifier,
                      builder: (context, selectedAge, _) {
                        int distance = (index - selectedAge).abs();

                        double fontSize;
                        Color textColor;

                        if (distance == 0) {
                          fontSize = 140;
                          textColor = Colors.white;
                        } else if (distance == 1) {
                          fontSize = 110;
                          textColor = const Color(0xFF9EA0A5);
                        } else if (distance == 2) {
                          fontSize = 95;
                          textColor = const Color(0xFFD7D8D9);
                        } else {
                          fontSize = 80;
                          textColor = const Color(0xFFD1D5DB);
                        }

                        return Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w900,
                              fontFamily: AppConstants.fontRegular,
                              color: textColor,
                              height: 1,
                            ),
                            child: Text('${index + 1}'),
                          ),
                        );
                      },
                    );
                  },
                  childCount: 100,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _physicalTagInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Center(
          child: Text(
            "Do you have any physical limitations?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontFamily: AppConstants.fontRegular,
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
            'assets/images/wheelchair.png',
            fit: BoxFit.contain,
          ),
        ),
        TagInputWidget(
          initialValues: physicalLimitations, // Add this line
          onChanged: (values) {
            physicalLimitations = values;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _medicalConditionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Center(
          child: Text(
            "Do you have any medical conditions?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontFamily: AppConstants.fontRegular,
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
            'assets/images/medical.jpg',
            fit: BoxFit.contain,
          ),
        ),
        TagInputWidget(
          initialValues: medicalConditions, // Add this line
          onChanged: (values) {
            medicalConditions = values;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _AllergiesInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Center(
          child: Text(
            "Do you have any Allergies?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontFamily: AppConstants.fontRegular,
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
            'assets/images/allergies.jpg',
            fit: BoxFit.contain,
          ),
        ),
        TagInputWidget(
          initialValues: allergies, // Add this line
          onChanged: (values) {
            allergies = values;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _dietInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Center(
          child: Text(
            "Do you have any Dietary Preferences?",
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

  Widget _medicationsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Center(
          child: Text(
            "Are you currently on any medications?",
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
            'assets/images/medications.jpg',
            fit: BoxFit.contain,
          ),
        ),
        TagInputWidget(
          initialValues: medications, // Add this line
          onChanged: (values) {
            medications = values;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
