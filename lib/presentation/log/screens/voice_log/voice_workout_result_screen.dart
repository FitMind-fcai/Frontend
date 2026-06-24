import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/meal_log/voice_workout_scan_result.dart';
import '../../../../data/models/save_log_request.dart';
import '../../manager/log_bloc.dart';
import '../../widgets/voice_log_shared_widgets.dart';

class VoiceWorkoutResultPage extends StatefulWidget {
  final VoiceWorkoutScanResult result;
  const VoiceWorkoutResultPage({super.key, required this.result});

  @override
  State<VoiceWorkoutResultPage> createState() => _VoiceWorkoutResultPageState();
}

class _VoiceWorkoutResultPageState extends State<VoiceWorkoutResultPage> {
  static const _green = AppConstants.primaryColor;

  late List<int?> _selectedIds;
  late String _logDate;

  @override
  void initState() {
    super.initState();
    _logDate = DateFormat('yyyy-MM-dd',"en").format(DateTime.now());
    _selectedIds = widget.result.exercises.map((e) {
      return e.matchedExercises.isNotEmpty ? e.matchedExercises.first.id : null;
    }).toList();
  }

  void _onSave() {
    final entries = widget.result.exercises.asMap().entries.map((entry) {
      final ex = entry.value;
      return WorkoutLogEntry(
        centralExerciseId: _selectedIds[entry.key],
        setsCompleted: ex.sets > 0 ? ex.sets : 1,
        repsCompleted: ex.reps > 0 ? ex.reps : 1,
        weightUsed: ex.weightKg > 0 ? ex.weightKg : null,
        durationSeconds: ex.durationSeconds > 0 ? ex.durationSeconds : null,
      );
    }).toList();

    context.read<LogBloc>().add(SaveLogsEvent(SaveLogRequest(
      category: 'workout',
      logDate: _logDate,
      logMethod: 'VOICE',
      workoutEntries: entries,
    )));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = isDark ? colorScheme.surface : const Color(0xFFF8F9FB);
    final cardColor = isDark ? colorScheme.surfaceContainerHigh : Colors.white;
    final borderColor = isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFEAEAEA);
    final textDark = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final textMid = isDark ? Colors.white60 : const Color(0xFF6B7280);

    return BlocListener<LogBloc, LogState>(
      listener: (context, state) {
        if (state is LogSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('voice_workout_result.save_success'.tr()),
              backgroundColor: Color(0xFF22C55E),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).popUntil((r) => r.isFirst);
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
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: cardColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: textDark),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'voice_workout_result.title'.tr(),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: textDark,
              fontFamily: AppConstants.fontRegular,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: borderColor),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          children: [
            if (widget.result.rawText.isNotEmpty)
              SectionCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.mic_none_rounded, color: _green, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('voice_workout_result.you_said'.tr(),
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: textMid,
                                  letterSpacing: 0.5,
                                  fontFamily: AppConstants.fontRegular)),
                          const SizedBox(height: 4),
                          Text(widget.result.rawText,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: textDark,
                                  height: 1.5,
                                  fontFamily: AppConstants.fontRegular)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 14),

            WorkoutStatsRow(
              exerciseCount: widget.result.exercises.length,
              duration: widget.result.durationMentioned,
              accent: _green,
            ),

            const SizedBox(height: 14),

            ...widget.result.exercises.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: ExerciseCard(
                  index: entry.key,
                  exercise: entry.value,
                  selectedId: _selectedIds[entry.key],
                  accent: _green,
                  onSelectMatch: (id) => setState(() => _selectedIds[entry.key] = id),
                ),
              );
            }),

            if (widget.result.tags.isNotEmpty)
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label('voice_workout_result.tags_label'.tr()),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.result.tags
                          .map((t) => TagChip(label: t, accent: _green))
                          .toList(),
                    ),
                  ],
                ),
              ),

            if (widget.result.tags.isNotEmpty) const SizedBox(height: 14),

            if (widget.result.notes.isNotEmpty)
              SectionCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 18, color: textMid),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(widget.result.notes,
                          style: TextStyle(
                              fontSize: 13,
                              color: textMid,
                              height: 1.5,
                              fontFamily: AppConstants.fontRegular)),
                    ),
                  ],
                ),
              ),
          ],
        ),
        bottomSheet: SaveBar(
          label: 'voice_workout_result.save_button'.tr(),
          accent: _green,
          onSave: _onSave,
        ),
      ),
    );
  }
}