// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/meal_log/meal_scan_result.dart';
import '../../../data/models/meal_log/voice_workout_scan_result.dart';
import '../manager/log_bloc.dart';

class SectionCard extends StatelessWidget {
  final Widget child;
  const SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFEAEAEA),
        ),
      ),
      child: child,
    );
  }
}

// ── Label ─────────────────────────────────────────────────────────────────────

class Label extends StatelessWidget {
  final String text;
  const Label(this.text);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      text,
      style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white54 : const Color(0xFF6B7280),
          letterSpacing: 0.6,
          fontFamily: AppConstants.fontRegular),
    );
  }
}

// ── Macro row ─────────────────────────────────────────────────────────────────

class MacroRow extends StatelessWidget {
  final double calories, protein, carbs, fats;
  final Color accent;
  const MacroRow({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFEAEAEA);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          MacroTile(label: 'voice_log_shared.label_calories'.tr(), value: calories.toStringAsFixed(0), unit: 'voice_log_shared.unit_kcal'.tr(), color: accent),
          _divider(borderColor),
          MacroTile(label: 'voice_log_shared.macro_protein'.tr(), value: protein.toStringAsFixed(1), unit: 'g', color: const Color(0xFFEF4444)),
          _divider(borderColor),
          MacroTile(label: 'voice_log_shared.macro_carbs'.tr(), value: carbs.toStringAsFixed(1), unit: 'g', color: const Color(0xFFF59E0B)),
          _divider(borderColor),
          MacroTile(label: 'voice_log_shared.macro_fats'.tr(), value: fats.toStringAsFixed(1), unit: 'g', color: const Color(0xFF8B5CF6)),
        ],
      ),
    );
  }

  Widget _divider(Color color) => Container(width: 1, height: 36, color: color);
}

class MacroTile extends StatelessWidget {
  final String label, value, unit;
  final Color color;
  const MacroTile({required this.label, required this.value, required this.unit, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, color: color, fontFamily: AppConstants.fontRegular)),
          const SizedBox(height: 2),
          Text(unit,
              style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                  fontFamily: AppConstants.fontRegular)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  fontFamily: AppConstants.fontRegular)),
        ],
      ),
    );
  }
}

// ── Meal type selector ────────────────────────────────────────────────────────

const _mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];
const _mealTypeLabelKeys = [
  'voice_log_shared.meal_type_breakfast',
  'voice_log_shared.meal_type_lunch',
  'voice_log_shared.meal_type_dinner',
  'voice_log_shared.meal_type_snack',
];
class MealTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const MealTypeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
        children: List.generate(_mealTypes.length, (i) {
          final type = _mealTypes[i];
          final label = _mealTypeLabelKeys[i].tr();
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: selected == type
                      ? const Color(0xFF3B82F6)
                      : isDark
                      ? colorScheme.surfaceContainerHighest
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _capitalize(type),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected == type
                          ? Colors.white
                          : isDark
                          ? Colors.white60
                          : const Color(0xFF6B7280),
                      fontFamily: AppConstants.fontRegular),
                ),
              ),
            ),
          );},
        ));
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ── Food chip ─────────────────────────────────────────────────────────────────

class FoodChip extends StatelessWidget {
  final String label;
  final String? portion;
  const FoodChip({required this.label, this.portion});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D4ED8).withOpacity(0.15) : const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF3B82F6).withOpacity(0.4) : const Color(0xFFBFDBFE),
        ),
      ),
      child: Text(
        portion != null ? '$label · $portion' : label,
        style: TextStyle(
            fontSize: 13,
            color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
            fontFamily: AppConstants.fontRegular),
      ),
    );
  }
}

// ── Matched food tile ─────────────────────────────────────────────────────────

class MatchedFoodTile extends StatelessWidget {
  final MatchedFood food;
  final bool isSelected;
  final Color accent;
  final VoidCallback onTap;

  const MatchedFoodTile({
    required this.food,
    required this.isSelected,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final unselectedBg = isDark ? colorScheme.surface : const Color(0xFFF8F9FB);
    final unselectedBorder = isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFEAEAEA);
    final textDark = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final textMid = isDark ? Colors.white54 : const Color(0xFF6B7280);
    final radioUnselected = isDark ? Colors.white30 : const Color(0xFFD1D5DB);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? accent.withOpacity(0.06) : unselectedBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accent : unselectedBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? accent : Colors.transparent,
                border: Border.all(color: isSelected ? accent : radioUnselected, width: 2),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.foodName,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textDark,
                          fontFamily: AppConstants.fontRegular)),
                  const SizedBox(height: 2),
                  Text(food.foodCategory,
                      style: TextStyle(
                          fontSize: 12, color: textMid, fontFamily: AppConstants.fontRegular)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${food.caloriesPer100g.toStringAsFixed(0)} ${'voice_log_shared.unit_kcal'.tr()}',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: accent,
                        fontFamily: AppConstants.fontRegular)),
                Text('voice_log_shared.per_100g'.tr(),
                    style: TextStyle(
                        fontSize: 11, color: textMid, fontFamily: AppConstants.fontRegular)),
              ],
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: _matchColor(food.similarityScore).withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${(food.similarityScore * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _matchColor(food.similarityScore),
                    fontFamily: AppConstants.fontRegular),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _matchColor(double score) {
    if (score >= 0.85) return const Color(0xFF22C55E);
    if (score >= 0.65) return const Color(0xFFF59E0B);
    return const Color(0xFF6B7280);
  }
}

// ── Servings stepper ──────────────────────────────────────────────────────────

class ServingsStepper extends StatelessWidget {
  final double value;
  final Color accent;
  final ValueChanged<double> onChanged;
  const ServingsStepper({required this.value, required this.accent, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        StepBtn(icon: Icons.remove, accent: accent, onTap: value > 0.5 ? () => onChanged(value - 0.5) : null),
        const SizedBox(width: 12),
        Text(
          value == value.truncateToDouble() ? value.toStringAsFixed(0) : value.toStringAsFixed(1),
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              fontFamily: AppConstants.fontRegular),
        ),
        const SizedBox(width: 12),
        StepBtn(icon: Icons.add, accent: accent, onTap: () => onChanged(value + 0.5)),
      ],
    );
  }
}

class StepBtn extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;
  const StepBtn({required this.icon, required this.accent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap != null
              ? accent.withOpacity(0.1)
              : isDark
              ? Colors.white12
              : const Color(0xFFF3F4F6),
        ),
        child: Icon(icon,
            size: 16,
            color: onTap != null ? accent : isDark ? Colors.white24 : const Color(0xFFD1D5DB)),
      ),
    );
  }
}

// ── Workout stats row ─────────────────────────────────────────────────────────

class WorkoutStatsRow extends StatelessWidget {
  final int exerciseCount;
  final String duration;
  final Color accent;
  const WorkoutStatsRow({required this.exerciseCount, required this.duration, required this.accent});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFEAEAEA);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          StatTile(value: '$exerciseCount', label: 'voice_log_shared.stat_exercises'.tr(), icon: Icons.fitness_center_rounded, color: accent),
          Container(width: 1, height: 36, color: borderColor),
          StatTile(
              value: duration.isNotEmpty ? duration : '—',
              label: 'voice_log_shared.stat_duration'.tr(),
              icon: Icons.timer_outlined,
              color: const Color(0xFF8B5CF6)),
        ],
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const StatTile({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, color: color, fontFamily: AppConstants.fontRegular)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                  fontFamily: AppConstants.fontRegular)),
        ],
      ),
    );
  }
}

// ── Exercise card ─────────────────────────────────────────────────────────────

class ExerciseCard extends StatelessWidget {
  final int index;
  final ParsedExercise exercise;
  final int? selectedId;
  final Color accent;
  final ValueChanged<int> onSelectMatch;

  const ExerciseCard({
    required this.index,
    required this.exercise,
    required this.selectedId,
    required this.accent,
    required this.onSelectMatch,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFEAEAEA);
    final textDark = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final textMid = isDark ? Colors.white54 : const Color(0xFF6B7280);

    final ex = exercise;
    final hasMatches = ex.matchedExercises.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text('${index + 1}',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: accent,
                            fontFamily: AppConstants.fontRegular)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ex.name.isNotEmpty ? ex.name : 'voice_log_shared.unnamed_exercise'.tr(),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                              fontFamily: AppConstants.fontRegular)),
                      const SizedBox(height: 4),
                      ExerciseMetaRow(exercise: ex),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (hasMatches) ...[
            Container(height: 1, color: borderColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('voice_log_shared.select_best_match'.tr(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: textMid,
                              fontFamily: AppConstants.fontRegular)),
                      const Spacer(),
                      Text('voice_meal_result.tap_to_select'.tr(),
                          style: TextStyle(
                              fontSize: 11,
                              color: textMid,
                              fontFamily: AppConstants.fontRegular)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...ex.matchedExercises.map((m) => MatchedExerciseTile(
                    match: m,
                    isSelected: selectedId == m.id,
                    accent: accent,
                    onTap: () => onSelectMatch(m.id),
                  )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ExerciseMetaRow extends StatelessWidget {
  final ParsedExercise exercise;
  const ExerciseMetaRow({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final parts = <String>[];
    if (exercise.sets > 0) parts.add('voice_log_shared.sets_short'.tr(namedArgs: {'count': '${exercise.sets}'}));
    if (exercise.reps > 0) parts.add('voice_log_shared.reps_short'.tr(namedArgs: {'count': '${exercise.reps}'}));
    if (exercise.weightStr.isNotEmpty) parts.add(exercise.weightStr);
    if (exercise.durationSeconds > 0) {
      final mins = exercise.durationSeconds ~/ 60;
      final secs = exercise.durationSeconds % 60;
      parts.add(mins > 0
          ? 'voice_log_shared.duration_min_sec'.tr(namedArgs: {'min': '$mins', 'sec': '$secs'})
          : 'voice_log_shared.duration_sec'.tr(namedArgs: {'sec': '$secs'}));
    }
    if (parts.isEmpty) return const SizedBox.shrink();
    return Text(parts.join(' · '),
        style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white54 : const Color(0xFF6B7280),
            fontFamily: AppConstants.fontRegular));
  }
}

class MatchedExerciseTile extends StatelessWidget {
  final MatchedExercise match;
  final bool isSelected;
  final Color accent;
  final VoidCallback onTap;

  const MatchedExerciseTile({
    required this.match,
    required this.isSelected,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final unselectedBg = isDark ? colorScheme.surfaceContainerHighest : const Color(0xFFF8F9FB);
    final unselectedBorder = isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFEAEAEA);
    final textDark = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final textMid = isDark ? Colors.white54 : const Color(0xFF6B7280);
    final radioUnselected = isDark ? Colors.white30 : const Color(0xFFD1D5DB);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? accent.withOpacity(0.06) : unselectedBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? accent : unselectedBorder, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? accent : Colors.transparent,
                border: Border.all(color: isSelected ? accent : radioUnselected, width: 2),
              ),
              child: isSelected ? const Icon(Icons.check_rounded, size: 10, color: Colors.white) : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(match.name,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textDark,
                          fontFamily: AppConstants.fontRegular)),
                  const SizedBox(height: 2),
                  Text(
                    [match.primaryMuscleGroup, match.equipmentRequired, match.difficultyLevel]
                        .where((s) => s.isNotEmpty)
                        .join(' · '),
                    style: TextStyle(
                        fontSize: 11, color: textMid, fontFamily: AppConstants.fontRegular),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: _matchColor(match.similarityScore).withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('${(match.similarityScore * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _matchColor(match.similarityScore),
                      fontFamily: AppConstants.fontRegular)),
            ),
          ],
        ),
      ),
    );
  }

  Color _matchColor(double score) {
    if (score >= 0.85) return const Color(0xFF22C55E);
    if (score >= 0.65) return const Color(0xFFF59E0B);
    return const Color(0xFF6B7280);
  }
}

// ── Tag chip ──────────────────────────────────────────────────────────────────

class TagChip extends StatelessWidget {
  final String label;
  final Color accent;
  const TagChip({required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: accent,
              fontFamily: AppConstants.fontRegular)),
    );
  }
}

// ── Save bar ──────────────────────────────────────────────────────────────────

class SaveBar extends StatelessWidget {
  final String label;
  final Color accent;
  final VoidCallback onSave;
  const SaveBar({required this.label, required this.accent, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFEAEAEA);

    return BlocBuilder<LogBloc, LogState>(
      builder: (context, state) {
        final isSaving = state is LogLoading && state.isSaving;
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          decoration: BoxDecoration(
            color: isDark ? colorScheme.surface : Colors.white,
            border: Border(top: BorderSide(color: borderColor)),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: isSaving ? null : onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: isSaving
                  ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white.withOpacity(0.8)),
              )
                  : Text(label,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppConstants.fontRegular)),
            ),
          ),
        );
      },
    );
  }
}