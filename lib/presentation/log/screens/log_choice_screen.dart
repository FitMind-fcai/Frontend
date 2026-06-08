import 'dart:ui';

import 'package:fitmind/presentation/log/screens/text_log_meal.dart';
import 'package:fitmind/presentation/log/screens/voice_log_meal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import 'image_log_meal.dart';

enum LogType { workout, meal }
enum LogMethod { voice, image, text }

// ─────────────────────────────────────────────────────────────────────────────
//  Log Entry Page  (Step 1 → type, Step 2 → method)
// ─────────────────────────────────────────────────────────────────────────────

class LogEntryPage extends StatefulWidget {
  const LogEntryPage({super.key});

  @override
  State<LogEntryPage> createState() => _LogEntryPageState();
}

class _LogEntryPageState extends State<LogEntryPage>
    with SingleTickerProviderStateMixin {
  LogType? _selectedType;
  LogMethod? _selectedMethod;

  late AnimationController _methodCtrl;
  late Animation<double> _methodFade;
  late Animation<Offset> _methodSlide;

  @override
  void initState() {
    super.initState();
    _methodCtrl = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _methodFade =
        CurvedAnimation(parent: _methodCtrl, curve: Curves.easeOut);
    _methodSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _methodCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _methodCtrl.dispose();
    super.dispose();
  }

  Color get _accent => _selectedType == LogType.workout
      ? AppConstants.primaryColor
      : const Color(0xFF3B82F6);

  void _selectType(LogType type) {
    setState(() {
      _selectedType = type;
      _selectedMethod = null;
    });
    _methodCtrl.forward(from: 0);
  }

  void _navigate() {
    if (_selectedType == null || _selectedMethod == null) return;
    Widget page;
    switch (_selectedMethod!) {
      case LogMethod.voice:
        page = VoiceLogPage(type: _selectedType!);
      case LogMethod.image:
        page = ImageLogPage(type: _selectedType!);
      case LogMethod.text:
        page = TextLogPage(type: _selectedType!);
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('What would you like to log?'),
                    const SizedBox(height: 16),
                    _buildTypeCards(),
                    if (_selectedType != null) ...[
                      const SizedBox(height: 32),
                      SlideTransition(
                        position: _methodSlide,
                        child: FadeTransition(
                          opacity: _methodFade,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionLabel('How would you like to log it?'),
                              const SizedBox(height: 16),
                              _buildMethodCards(),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (_selectedType != null && _selectedMethod != null) ...[
                      const SizedBox(height: 36),
                      _buildContinueButton(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              border:
              Border.all(color: const Color(0xFFEAEAEA)),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: Color(0xFF1A1A2E)),
          ),
        ),
        const SizedBox(width: 14),
        const Text('Log',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
                letterSpacing: -0.5,
                fontFamily: AppConstants.fontRegular)),
      ],
    ),
  );

  Widget _sectionLabel(String text) => Text(text,
      style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A2E),
          fontFamily: AppConstants.fontRegular));

  Widget _buildTypeCards() => Column(children: [
    _ImageLogCard(
      label: 'Workout',
      subtitle: 'Log your exercise & sets',
      imagePath: 'assets/images/workout_card.png',
      accentColor: AppConstants.primaryColor,
      isSelected: _selectedType == LogType.workout,
      onTap: () => _selectType(LogType.workout),
    ),
    const SizedBox(height: 14),
    _ImageLogCard(
      label: 'Meal',
      subtitle: 'Log your food & calories',
      imagePath: 'assets/images/meal_card.png',
      accentColor: const Color(0xFF3B82F6),
      isSelected: _selectedType == LogType.meal,
      onTap: () => _selectType(LogType.meal),
    ),
  ]);

  Widget _buildMethodCards() {
    final methods = [
      (LogMethod.voice, Icons.mic_rounded, 'Voice', 'Speak your log naturally'),
      (LogMethod.image, Icons.camera_alt_rounded, 'Image', 'Snap a photo to log'),
      (LogMethod.text, Icons.edit_rounded, 'Text', 'Type in your details'),
    ];
    return Column(
      children: methods.map((m) {
        final (method, icon, label, subtitle) = m;
        final isSelected = _selectedMethod == method;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => setState(() => _selectedMethod = method),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              decoration: BoxDecoration(
                color: isSelected ? _accent.withOpacity(0.06) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? _accent : const Color(0xFFEAEAEA),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _accent.withOpacity(0.12)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon,
                      color: isSelected ? _accent : const Color(0xFF9CA3AF),
                      size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? _accent
                                  : const Color(0xFF1A1A2E),
                              fontFamily: AppConstants.fontRegular)),
                      const SizedBox(height: 3),
                      Text(subtitle,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF9CA3AF))),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? _accent : Colors.transparent,
                    border: Border.all(
                        color: isSelected ? _accent : const Color(0xFFD1D5DB),
                        width: 2),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 13)
                      : null,
                ),
              ]),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContinueButton() {
    final typeLabel =
    _selectedType == LogType.workout ? 'Workout' : 'Meal';
    final methodLabel = _selectedMethod!.name[0].toUpperCase() +
        _selectedMethod!.name.substring(1);
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _navigate,
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Log $typeLabel via $methodLabel',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                    fontFamily: AppConstants.fontRegular)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Shared Image Card Widget
// ─────────────────────────────────────────────────────────────────────────────

class _ImageLogCard extends StatelessWidget {
  final String label, subtitle, imagePath;
  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _ImageLogCard({
    required this.label,
    required this.subtitle,
    required this.imagePath,
    required this.accentColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(25),
          border: isSelected
              ? Border.all(color: accentColor, width: 3)
              : null,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? accentColor.withOpacity(0.35)
                  : Colors.black.withOpacity(0.10),
              blurRadius: isSelected ? 20 : 10,
              offset: const Offset(0, 6),
            )
          ],
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(isSelected ? 0.35 : 0.45),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(children: [
          if (isSelected)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration:
                BoxDecoration(color: accentColor, shape: BoxShape.circle),
                child:
                const Icon(Icons.check, color: Colors.white, size: 16),
              ),
            ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppConstants.fontRegular)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 22),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Shared Page Shell
// ─────────────────────────────────────────────────────────────────────────────


