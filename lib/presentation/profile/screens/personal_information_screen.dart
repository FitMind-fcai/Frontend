import 'package:fitmind/presentation/authentication/widgets/common_button.dart';
import 'package:fitmind/presentation/profile/widgets/personal_info_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../authentication/widgets/app_form_field.dart';

// ---------------------------------------------------------------------------
// Minimal stand-ins for your real app constants / AppTextField.
// Replace these with your actual imports.
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Personal Info Page
// ---------------------------------------------------------------------------

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  // Controllers
  final _fullNameController = TextEditingController(text: 'Makise Kurisu');
  final _emailController =
      TextEditingController(text: 'elementary221b@gmail.com');
  final _passwordController = TextEditingController(text: '••••••••••••');
  final _weightController = TextEditingController(text: '3');
  final _locationController = TextEditingController(text: 'Tokyo, Japan');

  bool _obscurePassword = true;

  // Gender dropdown
  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Trans Female',
    'Trans Male',
    'Non-binary',
    'Prefer not to say',
  ];
  String _selectedGender = 'Trans Female';

  // Account type

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _weightController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Top dark header ──────────────────────────────────────────────
          InfoAppBar(),

          // ── Scrollable content ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name
                  AppTextField(
                    label: 'Full Name',
                    controller: _fullNameController,
                    prefixIconPath: 'assets/images/user.png',
                  ),
                  const SizedBox(height: 16),

                  // Email Address
                  AppTextField(
                    label: 'Email Address',
                    controller: _emailController,
                    prefixIconPath: 'assets/images/Monotone email.png',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  AppTextField(
                    label: 'Password',
                    controller: _passwordController,
                    prefixIconPath: 'assets/images/Monotone lock password.png',
                    obscureText: _obscurePassword,
                    toggleObscureText: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  const SizedBox(height: 16),

                  // Weight (text field instead of slider)
                  AppTextField(
                    label: 'Weight',
                    controller: _weightController,
                    prefixIconPath: "assets/images/Monotone email.png",
                    keyboardType: TextInputType.number,
                  ),
                  // "kilograms" hint aligned to the right
                  Padding(
                    padding: const EdgeInsets.only(right: 4, top: 4),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'kilograms',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontFamily: AppConstants.fontRegular,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Gender dropdown
                  _buildGenderDropdown(),
                  const SizedBox(height: 16),

                  // Location

                  // Account Type
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Save Settings button ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonButton(title: "Save Settings", onPressed: () {}),
          ),
        ],
      ),
    );
  }

  // ── Gender dropdown ───────────────────────────────────────────────────────

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' Gender',
          style: TextStyle(
            fontFamily: AppConstants.fontRegular,
            fontSize: AppConstants.fontSizeM,
            fontWeight: FontWeight.w600,
            color: AppConstants.secondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.transgender,
                color: AppConstants.secondaryColor,
              ),
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
            items: _genderOptions
                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedGender = val);
            },
          ),
        ),
      ],
    );
  }
}
