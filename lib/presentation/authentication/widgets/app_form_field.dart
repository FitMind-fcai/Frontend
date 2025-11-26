import 'package:flutter/material.dart';
import 'package:fitmind/core/constants/app_constants.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final Function(String)? onChanged;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final bool obscureText;
  final VoidCallback? toggleObscureText;
  final String prefixIconPath;
  final String? errorText; // new
  final Color? iconColor;

  const AppTextField({
    Key? key,
    this.focusNode,
    this.onChanged,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.toggleObscureText,
    required this.prefixIconPath,
    this.iconColor,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' $label',
          style: TextStyle(
            fontFamily: AppConstants.fontRegular,
            fontSize: AppConstants.fontSizeM,
            fontWeight: FontWeight.w600,
            color: AppConstants.secondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          focusNode: focusNode,
          onChanged: onChanged,
          style: const TextStyle(fontFamily: AppConstants.fontRegular),
          decoration: InputDecoration(
            prefixIcon: ImageIcon(
              AssetImage(prefixIconPath),
              color: iconColor ?? AppConstants.secondaryColor,
            ),
            suffixIcon: toggleObscureText != null
                ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: toggleObscureText,
            )
                : null,
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: errorText != null ? Colors.red : Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: errorText != null ? Colors.red : Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: errorText != null ? Colors.red : const Color(0xFFFF8C42),
                  width: 2.5),
            ),
            errorText: errorText,
            errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
