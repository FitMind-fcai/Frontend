import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/meal_log/meal_scan_request.dart';
import '../manager/log_bloc.dart';
import 'log_choice_screen.dart';
import 'log_page_shell.dart';
import 'meal_scan_result_page.dart';

class ImageLogPage extends StatefulWidget {
  final LogType type;
  const ImageLogPage({super.key, required this.type});

  @override
  State<ImageLogPage> createState() => _ImageLogPageState();
}

class _ImageLogPageState extends State<ImageLogPage> {
  File? _pickedFile;
  final _picker = ImagePicker();
  String _selectedMealType = 'BREAKFAST';

  static const _mealTypes = ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK'];
  static const _mealTypeLabels = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
  static const _mealTypeIcons = [
    Icons.wb_sunny_outlined,
    Icons.lunch_dining_outlined,
    Icons.dinner_dining_outlined,
    Icons.apple_outlined,
  ];

  Color get accent => widget.type == LogType.workout
      ? AppConstants.primaryColor
      : const Color(0xFF3B82F6);

  bool get _imagePicked => _pickedFile != null;

  // ── Image picking ──────────────────────────────────────────────────────────

  Future<void> _pickImage(ImageSource source) async {
    final xFile = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
    );
    if (xFile == null) return;
    setState(() => _pickedFile = File(xFile.path));
  }

  // ── Analyse ────────────────────────────────────────────────────────────────

  void _onAnalyse() {
    if (_pickedFile == null) return;

    final ext = _pickedFile!.path.split('.').last.toLowerCase();
    final format = (ext == 'png') ? 'png' : 'jpeg';

    final request = MealScanRequest(
      filePath: _pickedFile!.path,
      imageFormat: format,
      mealType: _selectedMealType,
    );

    context.read<LogBloc>().add(ScanMealLogEvent(request));
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogBloc, LogState>(
      listener: (context, state) {
        if (state is MealScanSuccess) {
          final ext = _pickedFile!.path.split('.').last.toLowerCase();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<LogBloc>(),
                child: MealScanResultPage(
                  scanResult: state.result,
                  filePath: _pickedFile!.path,
                  imageFormat: ext == 'png' ? 'png' : 'jpeg',
                ),
              ),
            ),
          );
        } else if (state is LogError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: LogPageShell(
        type: widget.type,
        methodLabel: 'Image',
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // ── Hint card ──────────────────────────────────────────────────
              _HintCard(accent: accent, type: widget.type),

              const SizedBox(height: 24),

              // ── Meal type selector ─────────────────────────────────────────
              _MealTypeSelector(
                selected: _selectedMealType,
                accent: accent,
                onChanged: (val) => setState(() => _selectedMealType = val),
              ),

              const SizedBox(height: 24),

              // ── Drop zone / preview ────────────────────────────────────────
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: _imagePicked
                        ? accent.withOpacity(0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: _imagePicked ? accent : const Color(0xFFEAEAEA),
                      width: _imagePicked ? 2 : 1.5,
                    ),
                  ),
                  child: _imagePicked
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(_pickedFile!, fit: BoxFit.cover),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8),
                            color: Colors.black.withOpacity(0.4),
                            child: const Text(
                              'Tap to change',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.camera_alt_outlined,
                            color: accent, size: 44),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Take or upload a photo',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E)),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tap to open camera or gallery',
                        style: TextStyle(
                            fontSize: 13, color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Source buttons ─────────────────────────────────────────────
              Row(children: [
                Expanded(
                  child: _SourceButton(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    accent: accent,
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SourceButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    accent: accent,
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                ),
              ]),

              const Spacer(),

              // ── CTA button ─────────────────────────────────────────────────
              BlocBuilder<LogBloc, LogState>(
                builder: (context, state) {
                  final isLoading = state is LogLoading;
                  return SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed:
                      (_imagePicked && !isLoading) ? _onAnalyse : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        disabledBackgroundColor: const Color(0xFFEAEAEA),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: isLoading
                          ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white.withOpacity(0.8)),
                      )
                          : Text(
                        _imagePicked
                            ? 'Analyse'
                            : 'Select a photo first',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _imagePicked
                                ? Colors.white
                                : const Color(0xFF9CA3AF),
                            fontFamily: AppConstants.fontRegular),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Meal Type Selector ────────────────────────────────────────────────────────

class _MealTypeSelector extends StatelessWidget {
  final String selected;
  final Color accent;
  final ValueChanged<String> onChanged;

  static const _mealTypes = ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK'];
  static const _mealTypeLabels = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
  static const _mealTypeIcons = [
    Icons.wb_sunny_outlined,
    Icons.lunch_dining_outlined,
    Icons.dinner_dining_outlined,
    Icons.apple_outlined,
  ];

  const _MealTypeSelector({
    required this.selected,
    required this.accent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meal type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(_mealTypes.length, (i) {
            final isSelected = selected == _mealTypes[i];
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(_mealTypes[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? accent.withOpacity(0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? accent : const Color(0xFFEAEAEA),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _mealTypeIcons[i],
                        size: 20,
                        color: isSelected ? accent : const Color(0xFF9CA3AF),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _mealTypeLabels[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? accent
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _HintCard extends StatelessWidget {
  final Color accent;
  final LogType type;
  const _HintCard({required this.accent, required this.type});

  @override
  Widget build(BuildContext context) {
    final tips = type == LogType.workout
        ? [
      'A clear photo of you or the equipment works best',
      'Make sure the background is not too cluttered',
      'Good lighting helps with recognition',
    ]
        : [
      'Place the food in a well-lit area',
      'Capture the whole plate from above',
      'Include any packaging if available',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.lightbulb_outline_rounded, color: accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Tips for a good photo',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: accent,
                  fontSize: 14,
                  fontFamily: AppConstants.fontRegular),
            ),
          ]),
          const SizedBox(height: 10),
          ...tips.map(
                (t) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(
                          color: Color(0xFF9CA3AF), fontSize: 13)),
                  Expanded(
                    child: Text(t,
                        style: const TextStyle(
                            color: Color(0xFF6B7280), fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEAEAEA)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: accent, size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A2E),
                    fontFamily: AppConstants.fontRegular)),
          ],
        ),
      ),
    );
  }
}