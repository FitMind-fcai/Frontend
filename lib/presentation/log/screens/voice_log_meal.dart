import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import 'log_choice_screen.dart';
import 'log_page_shell.dart';

class VoiceLogPage extends StatefulWidget {
  final LogType type;
  const VoiceLogPage({super.key, required this.type});

  @override
  State<VoiceLogPage> createState() => _VoiceLogPageState();
}

class _VoiceLogPageState extends State<VoiceLogPage>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  bool _isDone = false;
  int _seconds = 0;

  late AnimationController _pulseCtrl;
  late AnimationController _ringCtrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _ringAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this)
      ..repeat(reverse: true);
    _ringCtrl = AnimationController(
        duration: const Duration(milliseconds: 1400), vsync: this)
      ..repeat();
    _pulseAnim =
        Tween<double>(begin: 1.0, end: 1.12).animate(_pulseCtrl);
    _ringAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_ringCtrl);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _ringCtrl.dispose();
    super.dispose();
  }

  Color get accent => widget.type == LogType.workout
      ? AppConstants.primaryColor
      : const Color(0xFF3B82F6);

  void _toggleRecording() {
    setState(() {
      if (_isDone) {
        _isDone = false;
        _isRecording = false;
        _seconds = 0;
      } else if (_isRecording) {
        _isRecording = false;
        _isDone = true;
      } else {
        _isRecording = true;
        _runTimer();
      }
    });
  }

  void _runTimer() async {
    while (_isRecording && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (_isRecording && mounted) setState(() => _seconds++);
    }
  }

  String get _timerText {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return LogPageShell(
      type: widget.type,
      methodLabel: 'Voice',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 32),

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
                    Text('How to use voice logging',
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

            const Spacer(),

            // ── Timer ──
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isRecording ? 1.0 : 0.0,
              child: Text(_timerText,
                  style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                      letterSpacing: 2,
                      fontFamily: AppConstants.fontRegular)),
            ),

            const SizedBox(height: 28),

            // ── Mic button ──
            SizedBox(
              width: 180,
              height: 180,
              child: Stack(alignment: Alignment.center, children: [
                if (_isRecording) ...[
                  AnimatedBuilder(
                    animation: _ringAnim,
                    builder: (_, __) => Transform.scale(
                      scale: 1.0 + _ringAnim.value * 0.55,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: accent
                                  .withOpacity(0.4 * (1 - _ringAnim.value)),
                              width: 2),
                        ),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, __) => Transform.scale(
                      scale: _pulseAnim.value,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent.withOpacity(0.15),
                        ),
                      ),
                    ),
                  ),
                ],
                GestureDetector(
                  onTap: _toggleRecording,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isDone
                          ? const Color(0xFF22C55E)
                          : _isRecording
                          ? accent
                          : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: (_isDone
                              ? const Color(0xFF22C55E)
                              : accent)
                              .withOpacity(0.35),
                          blurRadius: 28,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Icon(
                      _isDone
                          ? Icons.check_rounded
                          : _isRecording
                          ? Icons.stop_rounded
                          : Icons.mic_rounded,
                      color: _isRecording || _isDone
                          ? Colors.white
                          : accent,
                      size: 48,
                    ),
                  ),
                ),
              ]),
            ),

            const SizedBox(height: 24),

            // ── State label ──
            Text(
              _isDone
                  ? 'Recording saved!'
                  : _isRecording
                  ? 'Tap to stop recording'
                  : 'Tap the mic to start',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _isDone
                      ? const Color(0xFF22C55E)
                      : const Color(0xFF6B7280),
                  fontFamily: AppConstants.fontRegular),
            ),

            const Spacer(),

            // ── Save button ──
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isDone ? 1.0 : 0.0,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isDone ? () => Navigator.pop(context) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Save Log',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppConstants.fontRegular)),
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
      'Say the exercise name, sets, and reps',
      'Example: "10 push-ups, 3 sets"',
      'You can mention weight too: "60kg bench press"',
    ]
        : [
      'Name the food and the portion size',
      'Example: "2 eggs and a bowl of oats"',
      'Mention the meal time if you like',
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