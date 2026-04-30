import 'package:fitmind/presentation/authentication/widgets/common_button.dart';
import 'package:fitmind/presentation/profile/widgets/personal_info_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/profile_body.dart';
import '../../assessment/widgets/tag_input_widget.dart';
import '../../authentication/widgets/app_form_field.dart';
import '../manager/profile_bloc.dart';

// ---------------------------------------------------------------------------
// Personal Info Page — synced with GET /v1/profiles/me & PUT /v1/profiles/me
// ---------------------------------------------------------------------------

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  // ── Basic text field controllers ─────────────────────────────────────────
  final _fullNameController   = TextEditingController();
  final _emailController      = TextEditingController();
  final _passwordController   = TextEditingController(text: '');
  final _ageController        = TextEditingController();
  final _heightController     = TextEditingController();
  final _weightController     = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading       = true;

  // ── Enum selections ──────────────────────────────────────────────────────
  Gender        _selectedGender      = Gender.Male;
  FitnessGoal   _selectedFitnessGoal = FitnessGoal.LoseWeight;
  ActivityLevel _selectedActivity    = ActivityLevel.Sedentary;

  // ── Tag lists ────────────────────────────────────────────────────────────
  List<String> _dietaryPreferences = [];
  List<String> _medicalConditions  = [];
  List<String> _allergies          = [];
  List<String> _injuries           = [];
  List<String> _medications        = [];

  // ── Cached profile for userId ────────────────────────────────────────────
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // ── Populate fields from fetched profile ─────────────────────────────────
  void _populateFromProfile(ProfileBody profile) {
    _userId = profile.userId;
    _ageController.text    = profile.age.toString();
    _heightController.text = profile.height.toString();
    _weightController.text = profile.weight.toString();
    _selectedGender        = profile.gender;
    _selectedFitnessGoal   = profile.fitnessGoal;
    _selectedActivity      = profile.activityLevel;
    _dietaryPreferences    = List.from(profile.dietaryPreferences);
    _medicalConditions     = List.from(profile.medicalConditions);
    _allergies             = List.from(profile.allergies);
    _injuries              = List.from(profile.injuries);
    _medications           = List.from(profile.medications);
  }

  // ── Build the PUT body from current field state ──────────────────────────
  ProfileBody _buildProfileBody() => ProfileBody(
    userId:              _userId,
    age:                 int.tryParse(_ageController.text) ?? 0,
    height:              double.tryParse(_heightController.text) ?? 0,
    weight:              double.tryParse(_weightController.text) ?? 0,
    gender:              _selectedGender,
    fitnessGoal:         _selectedFitnessGoal,
    activityLevel:       _selectedActivity,
    dietaryPreferences:  _dietaryPreferences,
    medicalConditions:   _medicalConditions,
    allergies:           _allergies,
    injuries:            _injuries,
    medications:         _medications,
  );

  // ── Shared label style ───────────────────────────────────────────────────
  TextStyle get _labelStyle => TextStyle(
    fontFamily: AppConstants.fontRegular,
    fontSize: AppConstants.fontSizeM,
    fontWeight: FontWeight.w600,
    color: AppConstants.secondaryColor,
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          setState(() {
            _populateFromProfile(state.profile);
            _isLoading = false;
          });
        } else if (state is ProfileLoading) {
          setState(() => _isLoading = true);
        } else if (state is ProfileSuccess) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
        } else if (state is ProfileError) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // ── Top dark header ──────────────────────────────────────
            InfoAppBar(),

            // ── Scrollable content ───────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Age ─────────────────────────────────────────
                    AppTextField(
                      label: 'Age',
                      controller: _ageController,
                      prefixIconPath: 'assets/images/user.png',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // ── Height ──────────────────────────────────────
                    AppTextField(
                      label: 'Height',
                      controller: _heightController,
                      prefixIconPath: 'assets/images/user.png',
                      keyboardType: TextInputType.number,
                    ),
                    _unitHint('centimeters'),
                    const SizedBox(height: 16),

                    // ── Weight ──────────────────────────────────────
                    AppTextField(
                      label: 'Weight',
                      controller: _weightController,
                      prefixIconPath: 'assets/images/user.png',
                      keyboardType: TextInputType.number,
                    ),
                    _unitHint('kilograms'),
                    const SizedBox(height: 16),

                    // ── Gender ──────────────────────────────────────
                    _buildEnumDropdown<Gender>(
                      label: 'Gender',
                      icon: Icons.transgender,
                      value: _selectedGender,
                      items: Gender.values,
                      itemLabel: (g) => g.name,
                      onChanged: (v) =>
                          setState(() => _selectedGender = v!),
                    ),
                    const SizedBox(height: 16),

                    // ── Fitness Goal ─────────────────────────────────
                    _buildEnumDropdown<FitnessGoal>(
                      label: 'Fitness Goal',
                      icon: Icons.flag_outlined,
                      value: _selectedFitnessGoal,
                      items: FitnessGoal.values,
                      itemLabel: getFitnessGoalString,
                      onChanged: (v) =>
                          setState(() => _selectedFitnessGoal = v!),
                    ),
                    const SizedBox(height: 16),

                    // ── Activity Level ───────────────────────────────
                    _buildEnumDropdown<ActivityLevel>(
                      label: 'Activity Level',
                      icon: Icons.directions_run,
                      value: _selectedActivity,
                      items: ActivityLevel.values,
                      itemLabel: (a) => a.name
                          .replaceAllMapped(RegExp(r'(?<=[a-z])(?=[A-Z])'),
                              (_) => ' '),
                      onChanged: (v) =>
                          setState(() => _selectedActivity = v!),
                    ),
                    const SizedBox(height: 24),

                    // ── Dietary Preferences ──────────────────────────
                    _buildTagSection(
                      label: 'Dietary Preferences',
                      values: _dietaryPreferences,
                      onChanged: (v) =>
                          setState(() => _dietaryPreferences = v),
                    ),
                    const SizedBox(height: 20),

                    // ── Medical Conditions ───────────────────────────
                    _buildTagSection(
                      label: 'Medical Conditions',
                      values: _medicalConditions,
                      onChanged: (v) =>
                          setState(() => _medicalConditions = v),
                    ),
                    const SizedBox(height: 20),

                    // ── Allergies ────────────────────────────────────
                    _buildTagSection(
                      label: 'Allergies',
                      values: _allergies,
                      onChanged: (v) => setState(() => _allergies = v),
                    ),
                    const SizedBox(height: 20),

                    // ── Injuries ─────────────────────────────────────
                    _buildTagSection(
                      label: 'Injuries',
                      values: _injuries,
                      onChanged: (v) => setState(() => _injuries = v),
                    ),
                    const SizedBox(height: 20),

                    // ── Medications ──────────────────────────────────
                    _buildTagSection(
                      label: 'Medications',
                      values: _medications,
                      onChanged: (v) => setState(() => _medications = v),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Save Settings button ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommonButton(
                title: 'Save Settings',
                onPressed: () {
                  context.read<ProfileBloc>().add(
                    UpdateProfileEvent(_buildProfileBody()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _unitHint(String unit) => Padding(
    padding: const EdgeInsets.only(right: 4, top: 4),
    child: Align(
      alignment: Alignment.centerRight,
      child: Text(
        unit,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade500,
          fontFamily: AppConstants.fontRegular,
        ),
      ),
    ),
  );

  Widget _buildTagSection({
    required String label,
    required List<String> values,
    required ValueChanged<List<String>> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(' $label', style: _labelStyle),
        const SizedBox(height: 8),
        TagInputWidget(
          initialValues: values,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildEnumDropdown<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(' $label', style: _labelStyle),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppConstants.secondaryColor),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                    color: AppConstants.primaryColor, width: 2.5),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
            style: const TextStyle(
              color: AppConstants.secondaryColor,
              fontFamily: AppConstants.fontRegular,
              fontSize: 15,
            ),
            icon: const Icon(Icons.keyboard_arrow_down,
                color: AppConstants.secondaryColor),
            items: items
                .map((item) => DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item)),
            ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}