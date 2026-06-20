import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/save_log_request.dart';
import '../manager/log_bloc.dart';

class HydrationLogPage extends StatefulWidget {
  const HydrationLogPage({super.key});

  @override
  State<HydrationLogPage> createState() => _HydrationLogPageState();
}

class _HydrationLogPageState extends State<HydrationLogPage> {
  int _waterMl = 0;
  final TextEditingController _notesController = TextEditingController();
  DateTime _logDate = DateTime.now();

  static const int _goalMl = 2500;

  static const _quickAmounts = [
    _QuickAmount(labelKey: 'hydration_log.quick_sip', ml: 100, icon: Icons.water_drop_outlined),
    _QuickAmount(labelKey: 'hydration_log.quick_glass', ml: 250, icon: Icons.local_drink_outlined),
    _QuickAmount(labelKey: 'hydration_log.quick_bottle', ml: 500, icon: Icons.sports_bar_outlined),
    _QuickAmount(labelKey: 'hydration_log.quick_large', ml: 750, icon: Icons.water_outlined),
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
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

  void _add(int ml) {
    setState(() => _waterMl = (_waterMl + ml).clamp(0, 9999));
  }

  void _remove(int ml) {
    setState(() => _waterMl = (_waterMl - ml).clamp(0, 9999));
  }

  void _save() {
    if (_waterMl <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('hydration_log.add_water_first'.tr())),
      );
      return;
    }
    final request = SaveLogRequest(
      category: 'hydration',
      logDate: DateFormat('yyyy-MM-dd').format(_logDate),
      logMethod: 'TEXT',
      hydrationEntries: [
        HydrationLogEntry(
          waterMl: _waterMl,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      ],
    );
    context.read<LogBloc>().add(SaveLogsEvent(request));
  }

  String _formatMl(int ml) {
    if (ml >= 1000) {
      return 'hydration_log.liters_short'.tr(namedArgs: {
        'count': (ml / 1000).toStringAsFixed(ml % 1000 == 0 ? 0 : 1),
      });
    }
    return 'hydration_log.ml_short'.tr(namedArgs: {'count': '$ml'});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (_waterMl / _goalMl).clamp(0.0, 1.0);
    final progressColor = progress >= 1.0
        ? const Color(0xFF26A69A)
        : AppConstants.primaryColor;

    return BlocListener<LogBloc, LogState>(
      listener: (context, state) {
        if (state is LogSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('hydration_log.log_success'.tr())),
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
            'hydration_log.title'.tr(),
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
              // ── Progress Card ────────────────────────────────────────
              _SectionCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatMl(_waterMl),
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: progressColor,
                            fontFamily: AppConstants.fontRegular,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 6),
                          child: Text(
                            '/ ${_formatMl(_goalMl)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.4),
                              fontWeight: FontWeight.w500,
                              fontFamily: AppConstants.fontRegular,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor:
                        theme.colorScheme.onSurface.withOpacity(0.08),
                        valueColor:
                        AlwaysStoppedAnimation<Color>(progressColor),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'hydration_log.goal_progress'.tr(namedArgs: {'percent': '${(progress * 100).round()}'}),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontFamily: AppConstants.fontRegular,
                          ),
                        ),
                        if (_waterMl > 0)
                          GestureDetector(
                            onTap: () => setState(() => _waterMl = 0),
                            child: Text(
                              'hydration_log.reset'.tr(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppConstants.fontRegular,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Quick Add ────────────────────────────────────────────
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'hydration_log.quick_add_label'.tr(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        letterSpacing: 0.8,
                        fontFamily: AppConstants.fontRegular,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: _quickAmounts
                          .map(
                            (q) => Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 4),
                            child: _QuickAddTile(
                              amount: q,
                              onAdd: () => _add(q.ml),
                              onRemove: () => _remove(q.ml),
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Manual Input ─────────────────────────────────────────
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'hydration_log.custom_amount_label'.tr(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        letterSpacing: 0.8,
                        fontFamily: AppConstants.fontRegular,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StepperButton(
                            icon: Icons.remove_rounded,
                            onTap: () => _remove(50),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: AppConstants.primaryColor.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'hydration_log.ml_value'.tr(namedArgs: {'count': '$_waterMl'}),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppConstants.primaryColor,
                                  fontFamily: AppConstants.fontRegular,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StepperButton(
                            icon: Icons.add_rounded,
                            onTap: () => _add(50),
                          ),
                        ),
                      ],
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
                    hintText: 'hydration_log.notes_hint'.tr(),
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
                        'hydration_log.save_hydration'.tr(),
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

// ── Supporting widgets ─────────────────────────────────────────────────────────

class _QuickAmount {
  final String labelKey;
  final int ml;
  final IconData icon;
  const _QuickAmount(
      {required this.labelKey, required this.ml, required this.icon});
}

class _QuickAddTile extends StatelessWidget {
  final _QuickAmount amount;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  const _QuickAddTile(
      {required this.amount, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        GestureDetector(
          onTap: onAdd,
          onLongPress: onRemove,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Icon(amount.icon, color: AppConstants.primaryColor, size: 22),
                const SizedBox(height: 6),
                Text(
                  'hydration_log.ml_short'.tr(namedArgs: {'count': '${amount.ml}'}),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppConstants.primaryColor,
                    fontFamily: AppConstants.fontRegular,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount.labelKey.tr(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontFamily: AppConstants.fontRegular,
          ),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon,
            color: theme.colorScheme.onSurface.withOpacity(0.7), size: 22),
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