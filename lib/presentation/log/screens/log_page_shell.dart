import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/constants/app_constants.dart';
import 'log_choice_screen.dart';

class LogPageShell extends StatelessWidget {
  final LogType type;
  final String methodLabel;
  final Widget body;

  const LogPageShell({
    required this.type,
    required this.methodLabel,
    required this.body,
  });

  Color get accent => type == LogType.workout
      ? AppConstants.primaryColor
      : const Color(0xFF3B82F6);

  String get typeLabel => type == LogType.workout
      ? 'log_page_shell.type_workout'.tr()
      : 'log_page_shell.type_meal'.tr();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isDark
                          ? colorScheme.surfaceContainerHighest
                          : Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color:
                            isDark ? Colors.white24 : const Color(0xFFEAEAEA),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'log_page_shell.title'
                            .tr(namedArgs: {'type': typeLabel}),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color:
                                isDark ? Colors.white : const Color(0xFF1A1A2E),
                            letterSpacing: -0.4,
                            fontFamily: AppConstants.fontRegular)),
                    Text('log_page_shell.via_method'.tr(namedArgs: {'method': methodLabel}),
                        style: TextStyle(
                            fontSize: 13,
                            color: accent,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ]),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
