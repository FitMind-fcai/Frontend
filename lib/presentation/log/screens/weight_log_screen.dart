import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/save_log_request.dart';
import '../manager/log_bloc.dart';

class WeightLogPage extends StatefulWidget {
  const WeightLogPage({super.key});

  @override
  State<WeightLogPage> createState() => _WeightLogPageState();
}

class _WeightLogPageState extends State<WeightLogPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final FocusNode _weightFocus = FocusNode();
  DateTime _logDate = DateTime.now();
  bool _isKg = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _weightFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    _weightFocus.dispose();
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

  double? get _weightInKg {
    final raw = double.tryParse(_weightController.text);
    if (raw == null) return null;
    return _isKg ? raw : raw * 0.453592;
  }

  void _save() {
    final kg = _weightInKg;
    if (kg == null || kg <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid weight')),
      );
      return;
    }

    final request = SaveLogRequest(
      category: 'weight',
      logDate: DateFormat('yyyy-MM-dd').format(_logDate),
      logMethod: 'TEXT',
      weightEntries: [
        WeightLogEntry(
          weight: double.parse(kg.toStringAsFixed(2)),
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
            const SnackBar(content: Text('Weight logged successfully')),
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
            'Log Weight',
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
              // ── Weight Input Card ────────────────────────────────────
              _SectionCard(
                child: Column(
                  children: [
                    // Unit Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _UnitToggleButton(
                            label: 'kg',
                            selected: _isKg,
                            onTap: () => setState(() => _isKg = true),
                          ),
                          _UnitToggleButton(
                            label: 'lbs',
                            selected: !_isKg,
                            onTap: () => setState(() => _isKg = false),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Weight value display + input
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IntrinsicWidth(
                          child: TextField(
                            controller: _weightController,
                            focusNode: _weightFocus,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d{0,3}\.?\d{0,1}')),
                            ],
                            onChanged: (_) => setState(() {}),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface,
                              fontFamily: AppConstants.fontRegular,
                            ),
                            decoration: InputDecoration(
                              hintText: '0.0',
                              hintStyle:
                              theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.2),
                                fontFamily: AppConstants.fontRegular,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              constraints:
                              const BoxConstraints(minWidth: 120),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            _isKg ? ' kg' : ' lbs',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppConstants.fontRegular,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Conversion hint
                    if (_weightController.text.isNotEmpty &&
                        _weightInKg != null)
                      Text(
                        _isKg
                            ? '≈ ${(_weightInKg! * 2.20462).toStringAsFixed(1)} lbs'
                            : '≈ ${_weightInKg!.toStringAsFixed(1)} kg',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                          fontFamily: AppConstants.fontRegular,
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Quick-add chips
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      children: [
                        for (final v in [60, 70, 75, 80, 90, 100])
                          _QuickChip(
                            label: '$v',
                            onTap: () {
                              _weightController.text = '$v';
                              setState(() {});
                            },
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
                    hintText: 'Notes (optional)…',
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
                          : const Text(
                        'Save Weight',
                        style: TextStyle(
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

class _UnitToggleButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _UnitToggleButton(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppConstants.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: AppConstants.fontRegular,
            color: selected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppConstants.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppConstants.primaryColor,
            fontFamily: AppConstants.fontRegular,
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