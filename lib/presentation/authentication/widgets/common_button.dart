import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../manager/auth_bloc.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = context.locale.languageCode == 'ar'; // Check if the current locale is Arabic (RTL)
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: isDark ? AppConstants.primaryColor : AppConstants.secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: AppConstants.fontRegular,
              ),
            ),
            const SizedBox(width: 12),
            Transform.flip(
              flipX: isRtl, // Flip the arrow horizontally if the locale is RTL
              child: Image.asset(
                'assets/images/Monotone arrow right.png',
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}