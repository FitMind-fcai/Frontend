import 'package:fitmind/core/constants/app_constants.dart';
import 'package:fitmind/presentation/authentication/widgets/common_button.dart';
import 'package:fitmind/presentation/plan/screens/plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unit_ruler/flutter_unit_ruler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;
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
  String? selectedActivityLevel;
  String _selectedUnit = 'kg';
  double? weight;
  FixedExtentScrollController _ageController = FixedExtentScrollController();

  int selectedAge = 0;
  List<String> physicalLimitations = [];
  List<String> medicalConditions = [];
  List<String> allergies = [];
  List<String> diets = [];
  List<String> medications = [];
  String _selectedHeightUnit = "cm";
  double? height;

  // Store theme state for use in sub-methods
  late bool _isDark;
  late ColorScheme _colorScheme;

  double kgToLbs(double kg) => kg * 2.20462;

  double lbsToKg(double lbs) => lbs * 0.45359237;

  @override
  Widget build(BuildContext context) {
    _isDark = Theme.of(context).brightness == Brightness.dark;
    _colorScheme = Theme.of(context).colorScheme;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoading) {
          showDialog(
            context: context,
            builder: (_) => const Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );
        } else if (state is ProfileSuccess) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => PlanSelectionScreen()),
          );
        } else if (state is ProfileError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: _isDark ? _colorScheme.surface : Colors.white,
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
                        }
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: _isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'assessment.title'.tr(),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: _isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _isDark
                            ? _colorScheme.surfaceContainerHighest
                            : const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'assessment.step_counter'
                            .tr(namedArgs: {'step': '${currentPage + 1}'}),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _isDark
                              ? Colors.white70
                              : const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                Expanded(child: _getCurrentPage()),

                const SizedBox(height: 20),
                CommonButton(
                  title: currentPage < 11
                      ? 'assessment.continue'.tr()
                      : 'assessment.submit'.tr(),
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
    // Commit any tag text the user typed but didn't press Enter on.
    FocusManager.instance.primaryFocus?.unfocus();

    if (currentPage < 10) {
      setState(() => currentPage++);
    } else {
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
        age: selectedAgeNotifier.value + 1,
        height: height ?? 0,
        weight: weight ?? 0,
        gender: selectedGender == 'male' ? Gender.Male : Gender.Female,
        fitnessGoal: selectedGoal == 'lose_weight'
            ? FitnessGoal.LoseWeight
            : selectedGoal == 'ai_coach'
                ? FitnessGoal.TryAICoach
                : selectedGoal == 'get_bulks'
                    ? FitnessGoal.GetBulks
                    : selectedGoal == 'gain_endurance'
                        ? FitnessGoal.ImproveEndurance
                        : FitnessGoal.LoseWeight,
        activityLevel: ActivityLevel.Sedentary,
        dietaryPreferences: diets,
        medicalConditions: medicalConditions,
        allergies: allergies,
        injuries: physicalLimitations,
        medications: medications,
      );

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
        Text(
          textAlign: TextAlign.center,
          'assessment.goal_question'.tr(),
          style: TextStyle(
            fontSize: 32,
            fontFamily: AppConstants.fontRegular,
            fontWeight: FontWeight.bold,
            height: 1.2,
            color: _isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView(
            children: [
              _buildOptionTile(
                icon: const AssetImage('assets/images/coldair.png'),
                label: 'assessment.goal_lose_weight'.tr(),
                value: 'lose_weight',
                selectionGroup: 'goal',
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: const AssetImage('assets/images/robothead.png'),
                label: 'assessment.goal_ai_coach'.tr(),
                value: 'ai_coach',
                selectionGroup: 'goal',
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: const AssetImage('assets/images/dumbbell.png'),
                label: 'assessment.goal_bulk'.tr(),
                value: 'get_bulks',
                selectionGroup: 'goal',
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: const AssetImage('assets/images/heartbeats.png'),
                label: 'assessment.goal_endurance'.tr(),
                value: 'gain_endurance',
                selectionGroup: 'goal',
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
        Text(
          textAlign: TextAlign.center,
          'assessment.activity_question'.tr(),
          style: TextStyle(
            fontSize: 32,
            fontFamily: AppConstants.fontRegular,
            fontWeight: FontWeight.bold,
            height: 1.2,
            color: _isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView(
            children: [
              _buildOptionTile(
                icon: const AssetImage('assets/images/coldair.png'),
                label: 'assessment.activity_sedentary'.tr(),
                value: 'lose_weight',
                selectionGroup: 'activity',
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: const AssetImage('assets/images/robothead.png'),
                label: 'assessment.activity_light'.tr(),
                value: 'ai_coach',
                selectionGroup: 'activity',
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: const AssetImage('assets/images/dumbbell.png'),
                label: 'assessment.activity_moderate'.tr(),
                value: 'get_bulks',
                selectionGroup: 'activity',
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: const AssetImage('assets/images/heartbeats.png'),
                label: 'assessment.activity_very'.tr(),
                value: 'Extra Active',
                selectionGroup: 'activity',
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
          Text(
            'assessment.gender_question'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontFamily: AppConstants.fontRegular,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: _isDark ? Colors.white : Colors.black,
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
    required String selectionGroup,
  }) {
    final isSelected = switch (selectionGroup) {
      'goal' => selectedGoal == value,
      'gender' => selectedGender == value,
      'activity' => selectedActivityLevel == value,
      _ => false,
    };

    return GestureDetector(
        onTap: () {
          setState(() {
            switch (selectionGroup) {
              case 'goal':
                selectedGoal = value;
              case 'gender':
                selectedGender = value;
              case 'activity':
                selectedActivityLevel = value;
            }
          });
        },
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
                ? AppConstants.primaryColor
                : _isDark
                    ? _colorScheme.surfaceContainerHighest
                    : const Color(0xFFF5F5F5),
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
                color: isSelected
                    ? Colors.white
                    : _isDark
                        ? Colors.white54
                        : Colors.grey[700],
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
                        : _isDark
                            ? Colors.white
                            : Colors.black87,
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
                    color: isSelected
                        ? Colors.white
                        : _isDark
                            ? Colors.white38
                            : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: isSelected
                      ? const Icon(Icons.check,
                          size: 16, color: Color(0xFFFF6B35), key: ValueKey(1))
                      : const SizedBox(key: ValueKey(2)),
                ),
              ),
            ],
          ),
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
      onTap: () => setState(() => selectedGender = value),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        scale: isSelected ? 1.03 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          height: 180,
          decoration: BoxDecoration(
            color: _colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
              width: 3,
            ),
          ),
          child: Stack(
            children: [
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
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: Row(
                  children: [
                    Icon(
                      gender == 'Male' ? Icons.male : Icons.female,
                      color:  Colors.black,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      gender == 'Male'
                          ? 'assessment.male'.tr()
                          : 'assessment.female'.tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppConstants.fontRegular,
                        color:  Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
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
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: isSelected
                        ? const Icon(Icons.check,
                            size: 18, color: Colors.white, key: ValueKey(1))
                        : const SizedBox(key: ValueKey(2)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeightPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'assessment.weight_question'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontFamily: AppConstants.fontRegular,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: _isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _isDark
                  ? _colorScheme.surfaceContainerHighest
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Directionality(
              textDirection: ui.TextDirection.ltr,
              child: Stack(
                children: [
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
                        border: Border.all(
                            color: const Color(0xFFB7C9E2), width: 2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedUnit = "kg"),
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'assessment.unit_kg'.tr(),
                              style: TextStyle(
                                color: _selectedUnit == "kg"
                                    ? Colors.white
                                    : _isDark
                                        ? Colors.white38
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
                          onTap: () => setState(() => _selectedUnit = "lbs"),
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'assessment.unit_lbs'.tr(),
                              style: TextStyle(
                                fontFamily: AppConstants.fontRegular,
                                color: _selectedUnit == "lbs"
                                    ? Colors.white
                                    : _isDark
                                        ? Colors.white38
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
          ),
          const SizedBox(height: 48),
          WeightPicker(
            unit: _selectedUnit,
            initialValue: weight,
            onChanged: (value) => setState(() => weight = value),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'assessment.height_question'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontFamily: AppConstants.fontRegular,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: _isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _isDark
                  ? _colorScheme.surfaceContainerHighest
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Directionality(
              textDirection: ui.TextDirection.ltr,
              child: Stack(
                children: [
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
                        border: Border.all(
                            color: const Color(0xFFB7C9E2), width: 2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedHeightUnit = "cm"),
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'assessment.unit_cm'.tr(),
                              style: TextStyle(
                                color: _selectedHeightUnit == "cm"
                                    ? Colors.white
                                    : _isDark
                                        ? Colors.white38
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
                          onTap: () =>
                              setState(() => _selectedHeightUnit = "ft"),
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'assessment.unit_ft'.tr(),
                              style: TextStyle(
                                fontFamily: AppConstants.fontRegular,
                                color: _selectedHeightUnit == "ft"
                                    ? Colors.white
                                    : _isDark
                                        ? Colors.white38
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
          ),
          const SizedBox(height: 48),
          HeightPicker(
            unit: _selectedHeightUnit,
            initialValue: height,
            onChanged: (value) => setState(() => height = value),
          ),
        ],
      ),
    );
  }

  final ValueNotifier<int> selectedAgeNotifier = ValueNotifier<int>(25);

  Widget _buildAgeScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_ageController.hasClients && _ageController.positions.isNotEmpty) {
        _ageController.jumpToItem(selectedAgeNotifier.value);
      }
    });
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text(
            'assessment.age_question'.tr(),
            style: TextStyle(
              fontSize: 32,
              fontFamily: AppConstants.fontRegular,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: _isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: selectedAgeNotifier,
                  builder: (context, selectedAge, _) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      width: selectedAge % 2 == 0 ? 290 : 285,
                      height: selectedAge % 2 == 0 ? 165 : 160,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        borderRadius: BorderRadius.circular(32),
                      ),
                    );
                  },
                ),
                ListWheelScrollView.useDelegate(
                  controller: _ageController,
                  itemExtent: 160,
                  perspective: 0.005,
                  diameterRatio: 3,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    selectedAgeNotifier.value = index;
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
          Center(
            child: Text(
              'assessment.physical_limitations_question'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontFamily: AppConstants.fontRegular,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: _isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Container(
            height: 196,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: _isDark
                ? null
                : Image.asset('assets/images/wheelchair.png',
                    fit: BoxFit.contain),
          ),
          TagInputWidget(
            key: const ValueKey('physical'),
            initialValues: physicalLimitations,
            onChanged: (values) => physicalLimitations = values,
          ),
          const SizedBox(height: 16),
        ],
      );
  }

  Widget _medicalConditionInput() {
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text(
              'assessment.medical_conditions_question'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontFamily: AppConstants.fontRegular,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: _isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Container(
            height: 196,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: _isDark
                ? null
                : Image.asset('assets/images/medical.jpg', fit: BoxFit.contain),
          ),
          TagInputWidget(
            key: const ValueKey('medical'),
            initialValues: medicalConditions,
            onChanged: (values) => medicalConditions = values,
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
          Center(
            child: Text(
              'assessment.allergies_question'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontFamily: AppConstants.fontRegular,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: _isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Container(
            height: 196,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: _isDark
                ? null
                : Image.asset('assets/images/allergies.jpg',
                    fit: BoxFit.contain),
          ),
          TagInputWidget(
            key: const ValueKey('allergies'),
            initialValues: allergies,
            onChanged: (values) => allergies = values,
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
          Center(
            child: Text(
              'assessment.diet_question'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontFamily: AppConstants.fontRegular,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: _isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Container(
            height: 196,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: _isDark
                ? null
                : Image.asset('assets/images/diet.jpg', fit: BoxFit.contain),
          ),
          TagInputWidget(
            key: const ValueKey('diet'),
            initialValues: diets,
            onChanged: (values) => diets = values,
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
          Center(
            child: Text(
              'assessment.medications_question'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontFamily: AppConstants.fontRegular,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: _isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Container(
            height: 196,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: _isDark
                ? null
                : Image.asset('assets/images/medications.jpg',
                    fit: BoxFit.contain),
          ),
          TagInputWidget(
            key: const ValueKey('medications'),
            initialValues: medications,
            onChanged: (values) => medications = values,
          ),
          const SizedBox(height: 16),
        ],
      );
  }
}
