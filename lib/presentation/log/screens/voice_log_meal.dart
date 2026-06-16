// lib/presentation/log/screens/voice_log_page.dart

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../core/constants/app_constants.dart';
import '../manager/log_bloc.dart';
import 'log_choice_screen.dart';
import 'log_page_shell.dart';
import 'log_voice_result_screen.dart';

class VoiceLogPage extends StatefulWidget {
  final LogType type;
  const VoiceLogPage({super.key, required this.type});

  @override
  State<VoiceLogPage> createState() => _VoiceLogPageState();
}

class _VoiceLogPageState extends State<VoiceLogPage>
    with TickerProviderStateMixin {
  final _recorder = AudioRecorder();
  bool _isRecording = false;
  final _player = AudioPlayer(); // <-- add here
  bool _isDone = false;
  int _seconds = 0;
  String? _recordedPath;

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
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.12).animate(_pulseCtrl);
    _ringAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_ringCtrl);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _ringCtrl.dispose();
    _recorder.dispose();
    _player.dispose(); // <-- add this

    super.dispose();
  }

  Color get accent => widget.type == LogType.workout
      ? AppConstants.primaryColor
      : const Color(0xFF3B82F6);

  Future<void> _toggleRecording() async {
    if (_isDone) {
      setState(() {
        _isDone = false;
        _isRecording = false;
        _seconds = 0;
        _recordedPath = null;
      });
      return;
    }

    if (_isRecording) {
      final path = await _recorder.stop();
      setState(() {
        _isRecording = false;
        _isDone = path != null;
        _recordedPath = path;
      });
      return;
    }

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) return;

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/voice_log_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
      path: path,
    );
    while (_isRecording) {
      final amp = await _recorder.getAmplitude();
      debugPrint('AMP: ${amp.current}');
      await Future.delayed(const Duration(milliseconds: 500));
    }
    setState(() {
      _isRecording = true;
      _seconds = 0;
    });
    _runTimer();
  }

  void _runTimer() async {
    while (_isRecording && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (_isRecording && mounted) setState(() => _seconds++);
    }
  }

  Future<void> _onAnalyse() async {
    if (_recordedPath == null) return;


    const audioFormat = 'm4a';

    if (widget.type == LogType.meal) {
      context.read<LogBloc>().add(ScanMealVoiceEvent(_recordedPath!, audioFormat));
    } else {
      context.read<LogBloc>().add(ScanWorkoutVoiceEvent(_recordedPath!, audioFormat));
    }
  }

  String get _timerText {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogBloc, LogState>(
      listener: (context, state) {
        if (state is VoiceMealScanSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<LogBloc>(),
                child: VoiceMealResultPage(result: state.result),
              ),
            ),
          );
        } else if (state is VoiceWorkoutScanSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<LogBloc>(),
                child: VoiceWorkoutResultPage(result: state.result),
              ),
            ),
          );
        } else if (state is LogError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      child: LogPageShell(
        type: widget.type,
        methodLabel: 'Voice',
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 32),
              _HintCard(accent: accent, type: widget.type),
              const Spacer(),

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
                                color: accent.withOpacity(
                                    0.4 * (1 - _ringAnim.value)),
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

              Text(
                _isDone
                    ? 'Recording ready!'
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
              if (_isDone)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () async {
                        if (_recordedPath != null) {
                          await _player.play(
                            DeviceFileSource(_recordedPath!),
                          );
                        }
                      },
                      child: const Text('Play Recording'),
                    ),
                  ),
                ),
              BlocBuilder<LogBloc, LogState>(
                builder: (context, state) {
                  final isLoading = state is LogLoading;
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isDone ? 1.0 : 0.0,
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: (_isDone && !isLoading) ? _onAnalyse : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent,
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
                            : const Text('Analyse',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppConstants.fontRegular)),
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

class _HintCard extends StatelessWidget {
  final Color accent;
  final LogType type;
  const _HintCard({required this.accent, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Text(
        type == LogType.workout
            ? "Speak naturally: Describe the exercises, repetitions, and performance weights achieved."
            : "Speak naturally: Detail your portion balances, dishes eaten, and ingredients mixed.",
        style: const TextStyle(
            fontSize: 13, color: Color(0xFF6B7280), height: 1.4),
      ),
    );
  }
}