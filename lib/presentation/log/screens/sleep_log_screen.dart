import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/save_log_request.dart';
import '../manager/log_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
class SleepLogPage extends StatefulWidget {
  const SleepLogPage({super.key});

  @override
  State<SleepLogPage> createState() => _SleepLogPageState();
}

class _SleepLogPageState extends State<SleepLogPage> {
  double _sleepHours = 7.0;
  int _sleepQuality = 3;
  final TextEditingController _notesController = TextEditingController();
  DateTime _logDate = DateTime.now();

  static const _qualityLabelKeys = [
    'sleep_log.quality_terrible',
    'sleep_log.quality_poor',
    'sleep_log.quality_fair',
    'sleep_log.quality_good',
    'sleep_log.quality_great',
  ];  static const _qualityColors = [
    Color(0xFFEF5350),
    Color(0xFFFF7043),
    Color(0xFFFFA726),
    Color(0xFF66BB6A),
    Color(0xFF26A69A),
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String get _formattedHours {
    final h = _sleepHours.floor();
    final m = ((_sleepHours - h) * 60).round();
    if (m == 0) return 'sleep_log.duration_short'.tr(namedArgs: {'hours': '$h'});
    return 'sleep_log.duration_with_minutes'.tr(namedArgs: {'hours': '$h', 'minutes': '$m'});
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _logDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _logDate = picked);
  }

  void _save() {
    final request = SaveLogRequest(
      category: 'sleep',
      logDate: DateFormat('yyyy-MM-dd').format(_logDate),
      logMethod: 'TEXT',
      sleepEntries: [
        SleepLogEntry(
          sleepHours: _sleepHours,
          sleepQuality: _sleepQuality,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      ],
    );
    context.read<LogBloc>().add(SaveLogsEvent(request));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<LogBloc, LogState>(
      listener: (context, state) {
        if (state is LogSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('sleep_log.log_success'.tr())),
          );
          Navigator.of(context).pop();
        } else if (state is LogError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'sleep_log.title'.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: AppConstants.fontRegular,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: _pickDate,
              child: Text(
                DateFormat('MMM d').format(_logDate),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppConstants.fontRegular,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Sleep Duration Card ──────────────────────────────────
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'sleep_log.duration_label'.tr(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        letterSpacing: 0.8,
                        fontFamily: AppConstants.fontRegular,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        _formattedHours,
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppConstants.primaryColor,
                          fontFamily: AppConstants.fontRegular,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppConstants.primaryColor,
                        inactiveTrackColor:
                        AppConstants.primaryColor.withOpacity(0.15),
                        thumbColor: AppConstants.primaryColor,
                        overlayColor:
                        AppConstants.primaryColor.withOpacity(0.12),
                        trackHeight: 6,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 10),
                      ),
                      child: Slider(
                        value: _sleepHours,
                        min: 1,
                        max: 12,
                        divisions: 22,
                        onChanged: (v) => setState(() => _sleepHours = v),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('sleep_log.hour_min'.tr(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.4),
                              fontFamily: AppConstants.fontRegular,
                            )),
                        Text('sleep_log.hour_max'.tr(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.4),
                              fontFamily: AppConstants.fontRegular,
                            )),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Sleep Quality Card ───────────────────────────────────
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'sleep_log.quality_label'.tr(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        letterSpacing: 0.8,
                        fontFamily: AppConstants.fontRegular,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (i) {
                        final selected = _sleepQuality == i + 1;
                        return GestureDetector(
                          onTap: () => setState(() => _sleepQuality = i + 1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: selected
                                  ? _qualityColors[i]
                                  : _qualityColors[i].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selected
                                    ? _qualityColors[i]
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: selected
                                      ? Colors.white
                                      : _qualityColors[i],
                                  fontFamily: AppConstants.fontRegular,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          _qualityLabelKeys[_sleepQuality - 1].tr(),
                          key: ValueKey(_sleepQuality),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _qualityColors[_sleepQuality - 1],
                            fontWeight: FontWeight.w600,
                            fontFamily: AppConstants.fontRegular,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Notes ────────────────────────────────────────────────
              _SectionCard(
                child: TextField(
                  controller: _notesController,
                  maxLines: 3,
                  style: const TextStyle(fontFamily: AppConstants.fontRegular),
                  decoration: InputDecoration(
                    hintText: 'sleep_log.notes_hint'.tr(),
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.35),
                      fontFamily: AppConstants.fontRegular,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Save Button ──────────────────────────────────────────
              BlocBuilder<LogBloc, LogState>(
                builder: (context, state) {
                  final loading = state is LogLoading && state.isSaving;
                  return SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: loading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: loading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : Text(
                        'sleep_log.save_sleep'.tr(),
                    style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppConstants.fontRegular,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}