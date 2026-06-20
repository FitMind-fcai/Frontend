// lib/presentation/log/screens/log_voice_result_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/meal_log/meal_scan_result.dart';
import '../../../data/models/meal_log/voice_meal_scan_result.dart' hide MatchedFood;
import '../../../data/models/meal_log/voice_workout_scan_result.dart';
import '../../../data/models/save_log_request.dart';
import '../manager/log_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MEAL RESULT PAGE
// ─────────────────────────────────────────────────────────────────────────────

class VoiceMealResultPage extends StatefulWidget {
  final VoiceMealScanResult result;
  const VoiceMealResultPage({super.key, required this.result});

  @override
  State<VoiceMealResultPage> createState() => _VoiceMealResultPageState();
}

class _VoiceMealResultPageState extends State<VoiceMealResultPage> {
  static const _blue = Color(0xFF3B82F6);

  int? _selectedFoodId;
  double _servings = 1.0;
  late String _mealType;
  late String _logDate;

  @override
  void initState() {
    super.initState();
    _mealType = widget.result.mealType.isNotEmpty ? widget.result.mealType : 'lunch';
    _logDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (widget.result.matchedFoods.isNotEmpty) {
      _selectedFoodId = widget.result.matchedFoods.first.id;
    }
  }

  void _onSave() {
    final request = SaveLogRequest(
      category: 'meal',
      logDate: _logDate,
      logMethod: 'VOICE',
      mealEntries: [
        MealLogEntry(
          centralFoodId: _selectedFoodId,
          mealType: _mealType.toUpperCase(),
          mealName: widget.result.mealName,
          servings: _servings,
        ),
      ],
    );
    context.read<LogBloc>().add(SaveLogsEvent(request));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = isDark ? colorScheme.surface : const Color(0xFFF8F9FB);
    final cardColor = isDark ? colorScheme.surface : Colors.white;
    final borderColor = isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFEAEAEA);
    final textDark = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final textMid = isDark ? Colors.white60 : const Color(0xFF6B7280);

    return BlocListener<LogBloc, LogState>(
      listener: (context, state) {
        if (state is LogSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('voice_meal_result.save_success'.tr()),
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
            'voice_meal_result.title'.tr(),
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
              _SectionCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.mic_none_rounded, color: _blue, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('voice_meal_result.you_said'.tr(),
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: textMid,
                                  letterSpacing: 0.5,
                                  fontFamily: AppConstants.fontRegular)),
                          const SizedBox(height: 4),
                          Text(
                            widget.result.rawText,
                            style: TextStyle(
                                fontSize: 14,
                                color: textDark,
                                height: 1.5,
                                fontFamily: AppConstants.fontRegular),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 14),

            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.result.mealName.isNotEmpty ? widget.result.mealName : 'voice_meal_result.unnamed_meal'.tr(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                        fontFamily: AppConstants.fontRegular),
                  ),
                  const SizedBox(height: 12),
                  _MealTypeSelector(
                    selected: _mealType,
                    onChanged: (v) => setState(() => _mealType = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            _MacroRow(
              calories: widget.result.estimatedCalories,
              protein: widget.result.estimatedProteinG,
              carbs: widget.result.estimatedCarbsG,
              fats: widget.result.estimatedFatsG,
              accent: _blue,
            ),

            const SizedBox(height: 14),

            if (widget.result.foodItems.isNotEmpty)
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label('voice_meal_result.items_detected'.tr()),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.result.foodItems
                          .asMap()
                          .entries
                          .map((e) => _FoodChip(
                        label: e.value,
                        portion: e.key < widget.result.portions.length
                            ? widget.result.portions[e.key]
                            : null,
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),

            if (widget.result.foodItems.isNotEmpty) const SizedBox(height: 14),

            if (widget.result.matchedFoods.isNotEmpty) ...[
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _Label('voice_meal_result.best_matches'.tr()),
                        const Spacer(),
                        Text('voice_meal_result.tap_to_select'.tr(),
                            style: TextStyle(
                                fontSize: 11,
                                color: textMid,
                                fontFamily: AppConstants.fontRegular)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'voice_meal_result.macro_calc_note'.tr(),
                      style: TextStyle(
                          fontSize: 12,
                          color: textMid,
                          fontFamily: AppConstants.fontRegular),
                    ),
                    const SizedBox(height: 14),
                    ...widget.result.matchedFoods.map((food) => _MatchedFoodTile(
                      food: food,
                      isSelected: _selectedFoodId == food.id,
                      accent: _blue,
                      onTap: () => setState(() => _selectedFoodId = food.id),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            _SectionCard(
              child: Row(
                children: [
                  Icon(Icons.restaurant_rounded, size: 18, color: textMid),
                  const SizedBox(width: 10),
                  Text('voice_meal_result.servings_label'.tr(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textDark,
                          fontFamily: AppConstants.fontRegular)),
                  const Spacer(),
                  _ServingsStepper(
                    value: _servings,
                    accent: _blue,
                    onChanged: (v) => setState(() => _servings = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            if (widget.result.notes.isNotEmpty)
              _SectionCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 18, color: textMid),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.result.notes,
                        style: TextStyle(
                            fontSize: 13,
                            color: textMid,
                            height: 1.5,
                            fontFamily: AppConstants.fontRegular),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        bottomSheet: _SaveBar(
          label: 'voice_meal_result.save_button'.tr(),
          accent: _blue,
          onSave: _onSave,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WORKOUT RESULT PAGE
// ─────────────────────────────────────────────────────────────────────────────

// Inside log_voice_result_screen.dart — replace the VoiceWorkoutResultPage class

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
    _logDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
              _SectionCard(
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

            _WorkoutStatsRow(
              exerciseCount: widget.result.exercises.length,
              duration: widget.result.durationMentioned,
              accent: _green,
            ),

            const SizedBox(height: 14),

            ...widget.result.exercises.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ExerciseCard(
                  index: entry.key,
                  exercise: entry.value,
                  selectedId: _selectedIds[entry.key],
                  accent: _green,
                  onSelectMatch: (id) => setState(() => _selectedIds[entry.key] = id),
                ),
              );
            }),

            if (widget.result.tags.isNotEmpty)
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label('voice_workout_result.tags_label'.tr()),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.result.tags
                          .map((t) => _TagChip(label: t, accent: _green))
                          .toList(),
                    ),
                  ],
                ),
              ),

            if (widget.result.tags.isNotEmpty) const SizedBox(height: 14),

            if (widget.result.notes.isNotEmpty)
              _SectionCard(
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
        bottomSheet: _SaveBar(
          label: 'voice_workout_result.save_button'.tr(),
          accent: _green,
          onSave: _onSave,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

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

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

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

class _MacroRow extends StatelessWidget {
  final double calories, protein, carbs, fats;
  final Color accent;
  const _MacroRow({
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
          _MacroTile(label: 'voice_log_shared.label_calories'.tr(), value: calories.toStringAsFixed(0), unit: 'voice_log_shared.unit_kcal'.tr(), color: accent),
          _divider(borderColor),
          _MacroTile(label: 'voice_log_shared.macro_protein'.tr(), value: protein.toStringAsFixed(1), unit: 'g', color: const Color(0xFFEF4444)),
          _divider(borderColor),
          _MacroTile(label: 'voice_log_shared.macro_carbs'.tr(), value: carbs.toStringAsFixed(1), unit: 'g', color: const Color(0xFFF59E0B)),
          _divider(borderColor),
          _MacroTile(label: 'voice_log_shared.macro_fats'.tr(), value: fats.toStringAsFixed(1), unit: 'g', color: const Color(0xFF8B5CF6)),
        ],
      ),
    );
  }

  Widget _divider(Color color) => Container(width: 1, height: 36, color: color);
}

class _MacroTile extends StatelessWidget {
  final String label, value, unit;
  final Color color;
  const _MacroTile({required this.label, required this.value, required this.unit, required this.color});

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
class _MealTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _MealTypeSelector({required this.selected, required this.onChanged});

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

class _FoodChip extends StatelessWidget {
  final String label;
  final String? portion;
  const _FoodChip({required this.label, this.portion});

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

class _MatchedFoodTile extends StatelessWidget {
  final MatchedFood food;
  final bool isSelected;
  final Color accent;
  final VoidCallback onTap;

  const _MatchedFoodTile({
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

class _ServingsStepper extends StatelessWidget {
  final double value;
  final Color accent;
  final ValueChanged<double> onChanged;
  const _ServingsStepper({required this.value, required this.accent, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        _StepBtn(icon: Icons.remove, accent: accent, onTap: value > 0.5 ? () => onChanged(value - 0.5) : null),
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
        _StepBtn(icon: Icons.add, accent: accent, onTap: () => onChanged(value + 0.5)),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;
  const _StepBtn({required this.icon, required this.accent, required this.onTap});

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

class _WorkoutStatsRow extends StatelessWidget {
  final int exerciseCount;
  final String duration;
  final Color accent;
  const _WorkoutStatsRow({required this.exerciseCount, required this.duration, required this.accent});

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
          _StatTile(value: '$exerciseCount', label: 'voice_log_shared.stat_exercises'.tr(), icon: Icons.fitness_center_rounded, color: accent),
          Container(width: 1, height: 36, color: borderColor),
          _StatTile(
              value: duration.isNotEmpty ? duration : '—',
              label: 'voice_log_shared.stat_duration'.tr(),
              icon: Icons.timer_outlined,
              color: const Color(0xFF8B5CF6)),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatTile({required this.value, required this.label, required this.icon, required this.color});

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

class _ExerciseCard extends StatefulWidget {
  final int index;
  final ParsedExercise exercise;
  final int? selectedId;
  final Color accent;
  final ValueChanged<int> onSelectMatch;

  const _ExerciseCard({
    required this.index,
    required this.exercise,
    required this.selectedId,
    required this.accent,
    required this.onSelectMatch,
  });

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFEAEAEA);
    final textDark = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final textMid = isDark ? Colors.white54 : const Color(0xFF6B7280);
    final toggleBg = isDark ? colorScheme.surface : const Color(0xFFF3F4F6);

    final ex = widget.exercise;
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
                    color: widget.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text('${widget.index + 1}',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: widget.accent,
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
                      _ExerciseMetaRow(exercise: ex),
                    ],
                  ),
                ),
                if (hasMatches)
                  GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: toggleBg, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Text('voice_log_shared.match_label'.tr(),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: textMid,
                                  fontFamily: AppConstants.fontRegular)),
                          const SizedBox(width: 4),
                          Icon(
                            _expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: textMid,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_expanded && hasMatches) ...[
            Container(height: 1, color: borderColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('voice_log_shared.select_best_match'.tr(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textMid,
                          fontFamily: AppConstants.fontRegular)),
                  const SizedBox(height: 10),
                  ...ex.matchedExercises.map((m) => _MatchedExerciseTile(
                    match: m,
                    isSelected: widget.selectedId == m.id,
                    accent: widget.accent,
                    onTap: () {
                      widget.onSelectMatch(m.id);
                      setState(() => _expanded = false);
                    },
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

class _ExerciseMetaRow extends StatelessWidget {
  final ParsedExercise exercise;
  const _ExerciseMetaRow({required this.exercise});

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

class _MatchedExerciseTile extends StatelessWidget {
  final MatchedExercise match;
  final bool isSelected;
  final Color accent;
  final VoidCallback onTap;

  const _MatchedExerciseTile({
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

class _TagChip extends StatelessWidget {
  final String label;
  final Color accent;
  const _TagChip({required this.label, required this.accent});

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

class _SaveBar extends StatelessWidget {
  final String label;
  final Color accent;
  final VoidCallback onSave;
  const _SaveBar({required this.label, required this.accent, required this.onSave});

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
