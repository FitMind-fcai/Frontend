import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../manager_log_history/log_history_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

String _formatLogTimestamp(DateTime dt) {
  return DateFormat('MMM d, yyyy • h:mm a').format(dt.toLocal());
}

class LogDetailScreen extends StatefulWidget {
  final String category;
  final String title;

  const LogDetailScreen({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  State<LogDetailScreen> createState() => _LogDetailScreenState();
}

class _LogDetailScreenState extends State<LogDetailScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final bloc = context.read<LogHistoryBloc>();
    switch (widget.category) {
      case 'meal':
        bloc.add(const LoadMealLogsEvent());
        break;
      case 'workout':
        bloc.add(const LoadWorkoutLogsEvent());
        break;
      case 'weight':
        bloc.add(const LoadWeightLogsEvent());
        break;
      case 'sleep':
        bloc.add(const LoadSleepLogsEvent());
        break;
      case 'hydration':
        bloc.add(const LoadHydrationLogsEvent());
        break;
    }
  }

  void _delete(int id) {
    context
        .read<LogHistoryBloc>()
        .add(DeleteLogEntryEvent(widget.category, id));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontFamily: AppConstants.fontRegular,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<LogHistoryBloc, LogHistoryState>(
        listener: (context, state) {
          if (state is LogDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('log_detail.entry_deleted'.tr())),
            );
            _load();
          }
          if (state is LogHistoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is LogHistoryLoading) {
            return Center(
                child:
                CircularProgressIndicator(color: colorScheme.primary));
          }

          if (state is LogHistoryError) {
            return _ErrorView(
                message: state.message, onRetry: _load);
          }

          final tiles = _buildTiles(context, state);

          if (tiles == null) {
            return Center(
                child:
                CircularProgressIndicator(color: colorScheme.primary));
          }

          if (tiles.isEmpty) {
            return _EmptyView(category: widget.category);
          }

          return ListView.separated(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            itemCount: tiles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => tiles[i],
          );
        },
      ),
    );
  }

  List<Widget>? _buildTiles(BuildContext context, LogHistoryState state) {
    if (state is MealLogsLoaded) {
      return state.logs
          .map((e) => _MealTile(entry: e, onDelete: () => _delete(e.id)))
          .toList();
    }
    if (state is WorkoutLogsLoaded) {
      return state.logs
          .map((e) =>
          _WorkoutTile(entry: e, onDelete: () => _delete(e.id)))
          .toList();
    }
    if (state is WeightLogsLoaded) {
      return state.logs
          .map((e) =>
          _WeightTile(entry: e, onDelete: () => _delete(e.id)))
          .toList();
    }
    if (state is SleepLogsLoaded) {
      return state.logs
          .map((e) => _SleepTile(entry: e, onDelete: () => _delete(e.id)))
          .toList();
    }
    if (state is HydrationLogsLoaded) {
      return state.logs
          .map((e) =>
          _HydrationTile(entry: e, onDelete: () => _delete(e.id)))
          .toList();
    }
    return null;
  }
}

// ── Shared tile shell ─────────────────────────────────────────────────────────

class _LogTile extends StatelessWidget {
  final String date;
  final Color accentColor;
  final IconData icon;
  final String title;
  final List<_Chip> chips;
  final String? note;
  final VoidCallback onDelete;

  const _LogTile({
    required this.date,
    required this.accentColor,
    required this.icon,
    required this.title,
    required this.chips,
    this.note,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border:
        Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.transparent
                : Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                        fontFamily: AppConstants.fontRegular,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                        fontFamily: AppConstants.fontRegular,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline,
                    color: colorScheme.error, size: 20),
                onPressed: () => _confirmDelete(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          if (chips.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: chips
                  .map((c) => _ChipWidget(chip: c, accent: accentColor))
                  .toList(),
            ),
          ],
          if (note != null && note!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              note!,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
                fontFamily: AppConstants.fontRegular,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('log_detail.delete_confirm_title'.tr()),
        content: Text('log_detail.delete_confirm_body'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('log_detail.cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Text(
              'log_detail.delete'.tr(),
              style:
              TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip {
  final String label;
  final String value;
  const _Chip(this.label, this.value);
}

class _ChipWidget extends StatelessWidget {
  final _Chip chip;
  final Color accent;

  const _ChipWidget({required this.chip, required this.accent});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${chip.label} ',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
                fontFamily: AppConstants.fontRegular,
              ),
            ),
            TextSpan(
              text: chip.value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: accent,
                fontFamily: AppConstants.fontRegular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Per-category tiles ────────────────────────────────────────────────────────

class _MealTile extends StatelessWidget {
  final dynamic entry; // MealLogHistory
  final VoidCallback onDelete;
  const _MealTile({required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) => _LogTile(
    date: _formatLogTimestamp(entry.createdAt),
    accentColor: const Color(0xFFFF6B00),
    icon: Icons.restaurant_outlined,
    title: entry.mealName,
    chips: [
      _Chip('log_detail.chip_meal'.tr(), entry.mealType),
      _Chip('log_detail.chip_cal'.tr(), '${entry.calories}'),
      _Chip('log_detail.chip_protein'.tr(), '${entry.proteinG.toStringAsFixed(1)}g'),
      _Chip('log_detail.chip_carbs'.tr(), '${entry.carbsG.toStringAsFixed(1)}g'),
      _Chip('log_detail.chip_fats'.tr(), '${entry.fatsG.toStringAsFixed(1)}g'),
    ],
    onDelete: onDelete,
  );
}

class _WorkoutTile extends StatelessWidget {
  final dynamic entry; // WorkoutLogHistory
  final VoidCallback onDelete;
  const _WorkoutTile({required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final chips = <_Chip>[
      _Chip('log_detail.chip_sets'.tr(), '${entry.setsCompleted}'),
      _Chip('log_detail.chip_reps'.tr(), '${entry.repsCompleted}'),
    ];
    if (entry.weightUsed != null && entry.weightUsed > 0) {
      chips.add(_Chip('log_detail.chip_weight'.tr(), 'log_detail.weight_chip_value'.tr(namedArgs: {'value': '${entry.weightUsed}'})));
    }
    if (entry.durationSeconds != null && entry.durationSeconds > 0) {
      final mins = (entry.durationSeconds ~/ 60);
      chips.add(_Chip('log_detail.chip_time'.tr(), 'log_detail.time_chip_value'.tr(namedArgs: {'value': '$mins'})));
    }
    final title = (entry.exerciseName != null && entry.exerciseName.isNotEmpty)
        ? entry.exerciseName as String
        : 'log_detail.title_workout'.tr();
    return _LogTile(
      date: _formatLogTimestamp(entry.createdAt),
      accentColor: const Color(0xFF3B82F6),
      icon: Icons.fitness_center_outlined,
      title: title,
      chips: chips,
      note: entry.notes,
      onDelete: onDelete,
    );
  }
}

class _WeightTile extends StatelessWidget {
  final dynamic entry; // WeightLogHistory
  final VoidCallback onDelete;
  const _WeightTile({required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) => _LogTile(
    date: _formatLogTimestamp(entry.createdAt),
    accentColor: const Color(0xFF26A69A),
    icon: Icons.monitor_weight_outlined,
    title: 'log_detail.weight_value'.tr(namedArgs: {'value': '${entry.weight}'}),
    chips: const [],
    note: entry.notes,
    onDelete: onDelete,
  );
}

class _SleepTile extends StatelessWidget {
  final dynamic entry; // SleepLogHistory
  final VoidCallback onDelete;
  const _SleepTile({required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final chips = <_Chip>[
      _Chip('log_detail.chip_hours'.tr(), entry.sleepHours.toStringAsFixed(1)),
    ];
    if (entry.sleepQuality != null) {
      chips.add(_Chip('log_detail.chip_quality'.tr(), 'log_detail.quality_chip_value'.tr(namedArgs: {'value': '${entry.sleepQuality}'})));
    }
    return _LogTile(
      date: _formatLogTimestamp(entry.createdAt),
      accentColor: const Color(0xFF7E57C2),
      icon: Icons.bedtime_outlined,
      title: 'log_detail.title_sleep'.tr(),
      chips: chips,
      note: entry.notes,
      onDelete: onDelete,
    );
  }
}

class _HydrationTile extends StatelessWidget {
  final dynamic entry; // HydrationLogHistory
  final VoidCallback onDelete;
  const _HydrationTile({required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) => _LogTile(
    date: _formatLogTimestamp(entry.createdAt),
    accentColor: const Color(0xFF29B6F6),
    icon: Icons.water_drop_outlined,
    title: 'log_detail.water_value'.tr(namedArgs: {'value': '${entry.waterMl}'}),
    chips: const [],
    note: entry.notes,
    onDelete: onDelete,
  );
}

// ── Empty / Error views ───────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  final String category;
  const _EmptyView({required this.category});

  String get _categoryLabel {
    switch (category) {
      case 'meal':
        return 'log_detail.category_meal'.tr();
      case 'workout':
        return 'log_detail.category_workout'.tr();
      case 'weight':
        return 'log_detail.category_weight'.tr();
      case 'sleep':
        return 'log_detail.category_sleep'.tr();
      case 'hydration':
        return 'log_detail.category_hydration'.tr();
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined,
              size: 56, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            'log_detail.no_logs_yet'.tr(namedArgs: {'category': _categoryLabel}),
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 16,
              fontFamily: AppConstants.fontRegular,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: 40),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style:
                TextStyle(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            TextButton(onPressed: onRetry, child: Text('log_detail.retry'.tr())),
          ],
        ),
      ),
    );
  }
}