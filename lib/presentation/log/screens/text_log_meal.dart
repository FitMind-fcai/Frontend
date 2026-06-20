import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import 'log_choice_screen.dart';
import 'log_page_shell.dart';

class TextLogPage extends StatefulWidget {
  final LogType type;
  const TextLogPage({super.key, required this.type});

  @override
  State<TextLogPage> createState() => _TextLogPageState();
}

class _TextLogPageState extends State<TextLogPage> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  bool _hasText = false;

  Color get accent =>
      widget.type == LogType.workout
          ? AppConstants.primaryColor
          : const Color(0xFF3B82F6);

  @override
  void initState() {
    super.initState();
    _controller.addListener(
            () =>
            setState(() =>
            _hasText = _controller.text
                .trim()
                .isNotEmpty));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return LogPageShell(
      type: widget.type,
      methodLabel: 'Text',
      body: GestureDetector(
        onTap: () => _focus.unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // ── Quick chips ──
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickFills()
                      .map((q) =>
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            _controller.text = q;
                            _controller.selection =
                                TextSelection.fromPosition(
                                  TextPosition(offset: q.length),
                                );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: accent.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: accent.withOpacity(0.25)),
                            ),
                            child: Text(q,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: accent,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ))
                      .toList(),
                ),
              ),

              const SizedBox(height: 16),

              // ── Text field ──
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _focus.hasFocus
                          ? accent
                          : const Color(0xFFEAEAEA),
                      width: _focus.hasFocus ? 2 : 1,
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focus,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1A1A2E),
                        height: 1.6),
                    decoration: InputDecoration(
                      hintText: _placeholder(),
                      hintStyle: const TextStyle(
                          color: Color(0xFFB0B7C3),
                          fontSize: 15,
                          height: 1.6),
                      contentPadding: const EdgeInsets.all(18),
                      border: InputBorder.none,
                    ),
                    onTap: () => setState(() {}),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Character count & submit ──
              Row(
                children: [
                  Text(
                    '${_controller.text.length} characters',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 54,
                    width: 180,
                    child: ElevatedButton(
                      onPressed:
                      _hasText ? () => Navigator.pop(context) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        disabledBackgroundColor: const Color(0xFFEAEAEA),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Save Log',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: _hasText
                                      ? Colors.white
                                      : const Color(0xFF9CA3AF),
                                  fontFamily: AppConstants.fontRegular)),
                          if (_hasText) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
  String _placeholder() => widget.type == LogType.workout
      ? 'e.g. "Bench press: 3 sets × 10 reps @ 80kg\nPull-ups: 4 sets × 8 reps"'
      : 'e.g. "Breakfast: 2 scrambled eggs, oats with honey, black coffee"';

  List<String> _quickFills() => widget.type == LogType.workout
      ? ['Push-ups', 'Squats', 'Bench Press', 'Pull-ups', 'Deadlift']
      : ['Breakfast', 'Lunch', 'Dinner', 'Snack', 'Protein shake'];
}