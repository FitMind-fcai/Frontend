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
  final String? errorText;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' $label',
          style: TextStyle(
            fontFamily: AppConstants.fontRegular,
            fontSize: AppConstants.fontSizeM,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppConstants.secondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          focusNode: focusNode,
          onChanged: onChanged,
          style: TextStyle(
            fontFamily: AppConstants.fontRegular,
            color: isDark ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: ImageIcon(
              AssetImage(prefixIconPath),
              color: isDark ? Colors.white54 : (iconColor ?? AppConstants.secondaryColor),
            ),
            suffixIcon: toggleObscureText != null
                ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: isDark ? Colors.white38 : Colors.grey,
              ),
              onPressed: toggleObscureText,
            )
                : null,
            filled: true,
            fillColor: isDark
                ? colorScheme.surfaceContainerHighest
                : const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : const Color(0xFFFF8C42),
                width: 2.5,
              ),
            ),
            errorText: errorText,
            errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }
}