import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/meal_log/excersise_search_result.dart';
import '../../../data/models/meal_log/meal_text_result.dart';


// ── Search Bar ────────────────────────────────────────────────────────────────

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color accent;
  final String hint;
  final ValueChanged<String> onSearch;

  const SearchBar({
    required this.controller,
    required this.focusNode,
    required this.accent,
    required this.hint,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.search,
        onSubmitted: onSearch,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
          const TextStyle(fontSize: 14, color: Color(0xFFB0B7C3)),
          prefixIcon:
          Icon(Icons.search_rounded, color: accent, size: 20),
          suffixIcon: IconButton(
            icon: Icon(Icons.arrow_forward_rounded, color: accent, size: 20),
            onPressed: () => onSearch(controller.text),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// ── Quick Chips ───────────────────────────────────────────────────────────────

class QuickChips extends StatelessWidget {
  final List<String> items;
  final Color accent;
  final ValueChanged<String> onTap;

  const QuickChips({
    required this.items,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => onTap(items[i]),
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withOpacity(0.25)),
            ),
            child: Text(
              items[i],
              style: TextStyle(
                  fontSize: 12,
                  color: accent,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppConstants.fontRegular),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Idle Hint ─────────────────────────────────────────────────────────────────

class IdleHint extends StatelessWidget {
  final String message;
  final IconData icon;

  const IdleHint({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: const Color(0xFFE5E7EB)),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}

// ── Empty Results ─────────────────────────────────────────────────────────────

class EmptyResults extends StatelessWidget {
  final String message;
  const EmptyResults({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message,
          style: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF))),
    );
  }
}

// ── Save Button ───────────────────────────────────────────────────────────────

class SaveButton extends StatelessWidget {
  final bool enabled;
  final bool isSaving;
  final Color accent;
  final String label;
  final VoidCallback onTap;

  const SaveButton({
    required this.enabled,
    required this.isSaving,
    required this.accent,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: (enabled && !isSaving) ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          disabledBackgroundColor: const Color(0xFFEAEAEA),
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isSaving
            ? SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white.withOpacity(0.8)),
        )
            : Text(
          label,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: enabled ? Colors.white : const Color(0xFF9CA3AF),
              fontFamily: AppConstants.fontRegular),
        ),
      ),
    );
  }
}

// ── Meal Type Selector ────────────────────────────────────────────────────────

class MealTypeSelector extends StatelessWidget {
  final String selected;
  final Color accent;
  final ValueChanged<String> onSelect;
  static const _types = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  const MealTypeSelector({
    required this.selected,
    required this.accent,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _types
          .map((type) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(
              right: type == _types.last ? 0 : 8),
          child: GestureDetector(
            onTap: () => onSelect(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 38,
              decoration: BoxDecoration(
                color: selected == type
                    ? accent
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected == type
                      ? accent
                      : const Color(0xFFEAEAEA),
                ),
              ),
              child: Center(
                child: Text(
                  type,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected == type
                          ? Colors.white
                          : const Color(0xFF6B7280),
                      fontFamily: AppConstants.fontRegular),
                ),
              ),
            ),
          ),
        ),
      ))
          .toList(),
    );
  }
}

// ── Food Result Card ──────────────────────────────────────────────────────────

class FoodResultCard extends StatelessWidget {
  final FoodSearchResult food;
  final Color accent;
  final VoidCallback onTap;

  const FoodResultCard({
    required this.food,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEAEAEA)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.foodName,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 3),
                  Text(food.foodCategory,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF9CA3AF))),
                  const SizedBox(height: 3),
                  Text(
                    '${food.servingDescription} · '
                        '${food.caloriesForServings(1).toStringAsFixed(0)} kcal/serving',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _matchColor(food.similarityScore)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${(food.similarityScore * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _matchColor(food.similarityScore)),
                  ),
                ),
                const SizedBox(height: 6),
                Icon(Icons.add_circle_outline_rounded,
                    color: accent, size: 22),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _matchColor(double score) {
    if (score >= 0.75) return const Color(0xFF10B981);
    if (score >= 0.5) return const Color(0xFFF59E0B);
    return const Color(0xFF9CA3AF);
  }
}

// ── Selected Food Panel ───────────────────────────────────────────────────────

class SelectedFoodPanel extends StatelessWidget {
  final FoodSearchResult food;
  final double servings;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final Color accent;
  final ValueChanged<double> onServingsChanged;
  final VoidCallback onClear;

  const SelectedFoodPanel({
    required this.food,
    required this.servings,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.accent,
    required this.onServingsChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Selected food header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accent.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(food.foodName,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: accent)),
                      const SizedBox(height: 2),
                      Text(food.foodCategory,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF9CA3AF))),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onClear,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                    ),
                    child: const Icon(Icons.close_rounded,
                        size: 16, color: Color(0xFF6B7280)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Servings
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEAEAEA)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Servings',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A2E))),
                    Text(
                      '${servings.toStringAsFixed(1)}x ${food.servingDescription}',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: accent),
                    ),
                  ],
                ),
                Slider(
                  value: servings,
                  min: 0.5,
                  max: 5.0,
                  divisions: 18,
                  activeColor: accent,
                  inactiveColor: accent.withOpacity(0.15),
                  onChanged: onServingsChanged,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (servings > 0.5)
                          onServingsChanged(servings - 0.5);
                      },
                      child: StepButton(icon: Icons.remove_rounded),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (servings < 5.0)
                          onServingsChanged(servings + 0.5);
                      },
                      child: StepButton(icon: Icons.add_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Macro summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEAEAEA)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${calories.toStringAsFixed(0)} kcal',
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E)),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MacroChip('Protein', '${protein.toStringAsFixed(1)}g',
                        const Color(0xFFEF4444)),
                    MacroChip('Carbs', '${carbs.toStringAsFixed(1)}g',
                        const Color(0xFFF59E0B)),
                    MacroChip('Fats', '${fats.toStringAsFixed(1)}g',
                        const Color(0xFF10B981)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Exercise Result Card ──────────────────────────────────────────────────────

class ExerciseResultCard extends StatelessWidget {
  final ExerciseSearchResult exercise;
  final Color accent;
  final VoidCallback onTap;

  const ExerciseResultCard({
    required this.exercise,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEAEAEA)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 3),
                  Text(
                    '${exercise.primaryMuscleGroup} · ${exercise.exerciseType}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                  if (exercise.equipmentRequired != null) ...[
                    const SizedBox(height: 2),
                    Text(exercise.equipmentRequired!,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _matchColor(exercise.similarityScore)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${(exercise.similarityScore * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _matchColor(exercise.similarityScore)),
                  ),
                ),
                const SizedBox(height: 6),
                Icon(Icons.add_circle_outline_rounded,
                    color: accent, size: 22),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _matchColor(double score) {
    if (score >= 0.75) return const Color(0xFF10B981);
    if (score >= 0.5) return const Color(0xFFF59E0B);
    return const Color(0xFF9CA3AF);
  }
}

// ── Selected Exercise Panel ───────────────────────────────────────────────────

class SelectedExercisePanel extends StatelessWidget {
  final ExerciseSearchResult exercise;
  final int sets;
  final int reps;
  final TextEditingController weightController;
  final TextEditingController notesController;
  final Color accent;
  final ValueChanged<int> onSetsChanged;
  final ValueChanged<int> onRepsChanged;
  final VoidCallback onClear;

  const SelectedExercisePanel({
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.weightController,
    required this.notesController,
    required this.accent,
    required this.onSetsChanged,
    required this.onRepsChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Selected exercise header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: accent.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exercise.name,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: accent)),
                    const SizedBox(height: 2),
                    Text(
                      '${exercise.primaryMuscleGroup} · ${exercise.exerciseType}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onClear,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFEAEAEA)),
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 16, color: Color(0xFF6B7280)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Sets & Reps
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEAEAEA)),
          ),
          child: Row(
            children: [
              Expanded(
                child: IntStepper(
                  label: 'Sets',
                  value: sets,
                  min: 1,
                  max: 20,
                  accent: accent,
                  onChanged: onSetsChanged,
                ),
              ),
              Container(
                  width: 1,
                  height: 60,
                  color: const Color(0xFFEAEAEA),
                  margin: const EdgeInsets.symmetric(horizontal: 16)),
              Expanded(
                child: IntStepper(
                  label: 'Reps',
                  value: reps,
                  min: 1,
                  max: 100,
                  accent: accent,
                  onChanged: onRepsChanged,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Weight (optional)
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEAEAEA)),
          ),
          child: Row(
            children: [
              Icon(Icons.fitness_center_rounded,
                  color: accent, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,1}'))
                  ],
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF1A1A2E)),
                  decoration: const InputDecoration(
                    hintText: 'Weight (kg) — optional',
                    hintStyle: TextStyle(
                        fontSize: 14, color: Color(0xFFB0B7C3)),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              const Text('kg',
                  style: TextStyle(
                      fontSize: 13, color: Color(0xFF9CA3AF))),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Notes (optional)
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEAEAEA)),
          ),
          child: Row(
            children: [
              Icon(Icons.notes_rounded, color: accent, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: notesController,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF1A1A2E)),
                  decoration: const InputDecoration(
                    hintText: 'Notes — optional',
                    hintStyle: TextStyle(
                        fontSize: 14, color: Color(0xFFB0B7C3)),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Int Stepper ───────────────────────────────────────────────────────────────

class IntStepper extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final Color accent;
  final ValueChanged<int> onChanged;

  const IntStepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.accent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StepButton(
              icon: Icons.remove_rounded,
              onTap: value > min ? () => onChanged(value - 1) : null,
            ),
            const SizedBox(width: 16),
            Text('$value',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: accent)),
            const SizedBox(width: 16),
            StepButton(
              icon: Icons.add_rounded,
              onTap: value < max ? () => onChanged(value + 1) : null,
            ),
          ],
        ),
      ],
    );
  }
}

// ── Step Button ───────────────────────────────────────────────────────────────

class StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const StepButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onTap != null
              ? const Color(0xFFF3F4F6)
              : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFFEAEAEA)),
        ),
        child: Icon(icon,
            size: 16,
            color: onTap != null
                ? const Color(0xFF6B7280)
                : const Color(0xFFD1D5DB)),
      ),
    );
  }
}

// ── Macro Chip ────────────────────────────────────────────────────────────────

class MacroChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const MacroChip(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: Color(0xFF9CA3AF))),
        ],
      ),
    );
  }
}