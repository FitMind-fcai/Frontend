import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import 'log_choice_screen.dart';
import 'log_page_shell.dart';

class ImageLogPage extends StatefulWidget {
  final LogType type;
  const ImageLogPage({super.key, required this.type});

  @override
  State<ImageLogPage> createState() => _ImageLogPageState();
}

class _ImageLogPageState extends State<ImageLogPage> {
  bool _imagePicked = false;

  Color get accent => widget.type == LogType.workout
      ? AppConstants.primaryColor
      : const Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    return LogPageShell(
      type: widget.type,
      methodLabel: 'Image',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // ── Hint card ──
            Container(
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
                    Icon(Icons.lightbulb_outline_rounded,
                        color: accent, size: 18),
                    const SizedBox(width: 8),
                    Text('Tips for a good photo',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: accent,
                            fontSize: 14,
                            fontFamily: AppConstants.fontRegular)),
                  ]),
                  const SizedBox(height: 10),
                  ..._hints(),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Drop zone / preview ──
            GestureDetector(
              onTap: () => setState(() => _imagePicked = !_imagePicked),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: 230,
                decoration: BoxDecoration(
                  color: _imagePicked
                      ? accent.withOpacity(0.08)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: _imagePicked
                        ? accent
                        : const Color(0xFFEAEAEA),
                    width: _imagePicked ? 2 : 1.5,
                    style: _imagePicked
                        ? BorderStyle.solid
                        : BorderStyle.solid,
                  ),
                ),
                child: _imagePicked
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check_circle_outline_rounded,
                          color: accent, size: 48),
                    ),
                    const SizedBox(height: 12),
                    Text('Photo selected!',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: accent,
                            fontFamily: AppConstants.fontRegular)),
                    const SizedBox(height: 4),
                    Text('Tap to change',
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF9CA3AF))),
                  ],
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt_outlined,
                          color: accent, size: 44),
                    ),
                    const SizedBox(height: 14),
                    const Text('Take or upload a photo',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E))),
                    const SizedBox(height: 6),
                    const Text('Tap to open camera or gallery',
                        style: TextStyle(
                            fontSize: 13, color: Color(0xFF9CA3AF))),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Source buttons ──
            Row(children: [
              Expanded(
                child: _SourceButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  accent: accent,
                  onTap: () => setState(() => _imagePicked = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SourceButton(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  accent: accent,
                  onTap: () => setState(() => _imagePicked = true),
                ),
              ),
            ]),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _imagePicked ? () => Navigator.pop(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  disabledBackgroundColor: const Color(0xFFEAEAEA),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _imagePicked ? 'Analyse & Save' : 'Select a photo first',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _imagePicked
                          ? Colors.white
                          : const Color(0xFF9CA3AF),
                      fontFamily: AppConstants.fontRegular),
                ),
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  List<Widget> _hints() {
    final tips = widget.type == LogType.workout
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
    return tips
        .map((t) => Padding(
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
                      color: Color(0xFF6B7280), fontSize: 13))),
        ],
      ),
    ))
        .toList();
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