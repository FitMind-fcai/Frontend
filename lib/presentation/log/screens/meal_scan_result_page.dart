import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/meal_log/meal_scan_result.dart';
import '../../../data/models/save_log_request.dart';
import '../manager/log_bloc.dart';

// ── Data class: a user's selection of one matched food + servings ─────────────

class _SelectedFood {
  final MatchedFood food;
  double servings;

  _SelectedFood({required this.food, this.servings = 1.0});

  double get calories =>
      food.caloriesPer100g * (food.servingSizeG / 100) * servings;
  double get protein =>
      food.proteinPer100g * (food.servingSizeG / 100) * servings;
  double get carbs =>
      food.carbsPer100g * (food.servingSizeG / 100) * servings;
  double get fats =>
      food.fatsPer100g * (food.servingSizeG / 100) * servings;
}

// ── Page ──────────────────────────────────────────────────────────────────────

class MealScanResultPage extends StatefulWidget {
  final MealScanResult scanResult;
  final String filePath;
  final String imageFormat;

  const MealScanResultPage({
    super.key,
    required this.scanResult,
    required this.filePath,
    required this.imageFormat,
  });

  @override
  State<MealScanResultPage> createState() => _MealScanResultPageState();
}

class _MealScanResultPageState extends State<MealScanResultPage> {
  static const Color _accent = Color(0xFF3B82F6);
  static const Color _surface = Colors.white;
  static const Color _bg = Color(0xFFF8F9FA);
  static const Color _border = Color(0xFFEAEAEA);
  static const Color _textPrimary = Color(0xFF1A1A2E);
  static const Color _textMuted = Color(0xFF9CA3AF);

  // food.id → _SelectedFood (preserves insertion order via LinkedHashMap)
  final Map<int, _SelectedFood> _selections = {};

  // ── Computed totals ────────────────────────────────────────────────────────

  double get _totalCalories =>
      _selections.values.fold(0, (s, f) => s + f.calories);
  double get _totalProtein =>
      _selections.values.fold(0, (s, f) => s + f.protein);
  double get _totalCarbs =>
      _selections.values.fold(0, (s, f) => s + f.carbs);
  double get _totalFats =>
      _selections.values.fold(0, (s, f) => s + f.fats);

  // ── Toggle / servings ──────────────────────────────────────────────────────

  void _toggle(MatchedFood food) {
    setState(() {
      if (_selections.containsKey(food.id)) {
        _selections.remove(food.id);
      } else {
        _selections[food.id] = _SelectedFood(food: food);
      }
    });
  }

  void _setServings(int foodId, double servings) {
    setState(() {
      _selections[foodId]?.servings = servings;
    });
  }

  // ── Save ───────────────────────────────────────────────────────────────────

  void _onSave() {
    final logDate = DateFormat('yyyy-MM-dd',"en").format(DateTime.now());
    final mealType = widget.scanResult.mealType.isNotEmpty
        ? widget.scanResult.mealType
        : 'LUNCH';

    List<MealLogEntry> mealEntries;

    if (_selections.isEmpty) {
      // No catalog match chosen → save AI aggregate as one raw entry
      mealEntries = [
        MealLogEntry(
          mealType: mealType,
          mealName: widget.scanResult.mealName.isNotEmpty
              ? widget.scanResult.mealName
              : 'Scanned Meal',
          calories: widget.scanResult.totalCalories,
          proteinG: widget.scanResult.totalProteinG,
          carbsG: widget.scanResult.totalCarbsG,
          fatsG: widget.scanResult.totalFatsG,
        ),
      ];
    } else {
      // Save each selected food as its own entry
      mealEntries = _selections.values.map((sel) {
        return MealLogEntry(
          centralFoodId: sel.food.id,
          mealType: mealType,
          servings: sel.servings,
          servingSizeGSnapshot: sel.food.servingSizeG,
          servingDescriptionSnapshot: sel.food.servingDescription,
        );
      }).toList();
    }

    final request = SaveLogRequest(
      category: 'meal',
      logDate: logDate,
      logMethod: 'CAMERA',
      mealEntries: mealEntries,
    );

    context.read<LogBloc>().add(SaveLogsEvent(request));
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: _textPrimary,
      ),
    ),
  );

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogBloc, LogState>(
      listener: (context, state) {
        if (state is LogSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _selections.isEmpty
                    ? 'meal_scan_result.meal_logged_singular'.tr()
                    : 'meal_scan_result.meal_logged_plural'.tr(namedArgs: {'count': '${_selections.length}'}),
              ),
              backgroundColor: _accent,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context)
            ..pop()
            ..pop();
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
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: _textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'meal_scan_result.title'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AI summary card
                    _AiResultCard(result: widget.scanResult),

                    const SizedBox(height: 24),

                    // Detected items
                    if (widget.scanResult.foodItems.isNotEmpty) ...[
                      _sectionTitle('meal_scan_result.section_detected_items'.tr()),
                      ...widget.scanResult.foodItems
                          .map((item) => _FoodItemCard(item: item)),
                      const SizedBox(height: 24),
                    ],

                    // Matched foods — multi-select
                    if (widget.scanResult.matchedFoods.isNotEmpty) ...[
                      _sectionTitle('meal_scan_result.section_catalog_matches'.tr()),
                      Text(
                        'meal_scan_result.catalog_matches_hint'.tr(),
                        style:
                        TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                      ),
                      const SizedBox(height: 12),
                      ...widget.scanResult.matchedFoods.map(
                            (food) => _MatchedFoodCard(
                          food: food,
                          isSelected: _selections.containsKey(food.id),
                          selection: _selections[food.id],
                          onTap: () => _toggle(food),
                          onServingsChanged: (v) =>
                              _setServings(food.id, v),
                        ),
                      ),
                    ],

                    // Live totals strip (only when ≥1 selected)
                    if (_selections.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _TotalsCard(
                        calories: _totalCalories,
                        protein: _totalProtein,
                        carbs: _totalCarbs,
                        fats: _totalFats,
                        count: _selections.length,
                      ),
                    ],

                    // Health notes
                    if (widget.scanResult.healthNotes.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _sectionTitle('meal_scan_result.section_health_notes'.tr()),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _border),
                        ),
                        child: Text(
                          widget.scanResult.healthNotes,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Save bar
            _SaveBar(
              selections: _selections,
              onSave: _onSave,
            ),
          ],
        ),
      ),
    );
  }
}

// ── AI Result Summary Card ────────────────────────────────────────────────────

class _AiResultCard extends StatelessWidget {
  final MealScanResult result;
  const _AiResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.mealName.isNotEmpty
                          ? result.mealName
                          : 'meal_scan_result.scanned_meal_fallback'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.mealType,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _confidenceColor(result.confidenceScore)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'meal_scan_result.confidence_badge'.tr(namedArgs: {'percent': (result.confidenceScore * 100).toStringAsFixed(0)}),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _confidenceColor(result.confidenceScore),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'meal_scan_result.calories_kcal'.tr(namedArgs: {'count': result.totalCalories.toStringAsFixed(0)}),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'meal_scan_result.ai_estimate_note'.tr(),
            style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _macroChip('meal_scan_result.macro_protein'.tr(),
                  '${result.totalProteinG.toStringAsFixed(1)}g',
                  const Color(0xFFEF4444)),
              _macroChip('meal_scan_result.macro_carbs'.tr(),
                  '${result.totalCarbsG.toStringAsFixed(1)}g',
                  const Color(0xFFF59E0B)),
              _macroChip('meal_scan_result.macro_fats'.tr(),
                  '${result.totalFatsG.toStringAsFixed(1)}g',
                  const Color(0xFF10B981)),
            ],
          ),
          if (result.tags.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: result.tags
                  .map((tag) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(tag,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF6B7280))),
              ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _macroChip(String label, String value, Color color) {
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
                  fontSize: 15, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style:
              const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
        ],
      ),
    );
  }

  Color _confidenceColor(double score) {
    if (score >= 0.75) return const Color(0xFF10B981);
    if (score >= 0.5) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }
}

// ── Detected Food Item Card ───────────────────────────────────────────────────

class _FoodItemCard extends StatelessWidget {
  final dynamic item;
  const _FoodItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
                Text(item.name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E))),
                const SizedBox(height: 2),
                Text(item.portionSize,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('meal_scan_result.calories_kcal'.tr(namedArgs: {'count': item.calories.toStringAsFixed(0)}),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E))),
              const SizedBox(height: 2),
              Text(
                'meal_scan_result.macro_summary_line'.tr(namedArgs: {
                  'protein': item.proteinG.toStringAsFixed(0),
                  'carbs': item.carbsG.toStringAsFixed(0),
                  'fats': item.fatsG.toStringAsFixed(0),
                }),
                style:
                const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Matched Food Card (expandable with inline servings) ───────────────────────

class _MatchedFoodCard extends StatelessWidget {
  final MatchedFood food;
  final bool isSelected;
  final _SelectedFood? selection;
  final VoidCallback onTap;
  final ValueChanged<double> onServingsChanged;

  const _MatchedFoodCard({
    required this.food,
    required this.isSelected,
    required this.selection,
    required this.onTap,
    required this.onServingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF3B82F6);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected ? accent.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? accent : const Color(0xFFEAEAEA),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // ── Header row ──
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Checkbox circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? accent : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? accent
                            : const Color(0xFFD1D5DB),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 14)
                        : null,
                  ),

                  const SizedBox(width: 12),

                  // Name + category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.foodName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? accent
                                : const Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(food.foodCategory,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF))),
                      ],
                    ),
                  ),

                  // Calories + match
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'meal_scan_result.calories_per_100g'.tr(namedArgs: {'count': food.caloriesPer100g.toStringAsFixed(0)}),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'meal_scan_result.match_percent'.tr(namedArgs: {'percent': (food.similarityScore * 100).toStringAsFixed(0)}),
                        style: TextStyle(
                            fontSize: 11,
                            color: _matchColor(food.similarityScore)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Inline servings (only when selected) ──
          if (isSelected && selection != null)
            _ServingsRow(
              food: food,
              servings: selection!.servings,
              onChanged: onServingsChanged,
            ),
        ],
      ),
    );
  }

  Color _matchColor(double score) {
    if (score >= 0.75) return const Color(0xFF10B981);
    if (score >= 0.5) return const Color(0xFFF59E0B);
    return const Color(0xFF9CA3AF);
  }
}

// ── Inline Servings Row ───────────────────────────────────────────────────────

class _ServingsRow extends StatelessWidget {
  final MatchedFood food;
  final double servings;
  final ValueChanged<double> onChanged;

  const _ServingsRow({
    required this.food,
    required this.servings,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF3B82F6);
    final calories =
        food.caloriesPer100g * (food.servingSizeG / 100) * servings;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        children: [
          Container(height: 1, color: const Color(0xFFEAEAEA)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'meal_scan_result.servings_value'.tr(namedArgs: {
                  'count': servings.toStringAsFixed(1),
                  'description': food.servingDescription,
                }),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Text(
                'meal_scan_result.calories_kcal'.tr(namedArgs: {'count': calories.toStringAsFixed(0)}),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _StepButton(
                icon: Icons.remove_rounded,
                onTap: () {
                  if (servings > 0.5) onChanged(servings - 0.5);
                },
              ),
              Expanded(
                child: Slider(
                  value: servings.clamp(0.5, 5.0),
                  min: 0.5,
                  max: 5.0,
                  divisions: 18,
                  activeColor: accent,
                  inactiveColor: accent.withOpacity(0.15),
                  onChanged: onChanged,
                ),
              ),
              _StepButton(
                icon: Icons.add_rounded,
                onTap: () {
                  if (servings < 5.0) onChanged(servings + 0.5);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF6B7280)),
      ),
    );
  }
}

// ── Live Totals Card ──────────────────────────────────────────────────────────

class _TotalsCard extends StatelessWidget {
  final double calories, protein, carbs, fats;
  final int count;

  const _TotalsCard({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                count == 1
                    ? 'meal_scan_result.items_selected'.tr(namedArgs: {'count': '$count'})
                    : 'meal_scan_result.items_selected_plural'.tr(namedArgs: {'count': '$count'}),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3B82F6),
                ),
              ),
              Text(
                'meal_scan_result.calories_total'.tr(namedArgs: {'count': calories.toStringAsFixed(0)}),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _totalPill('meal_scan_result.macro_protein'.tr(), '${protein.toStringAsFixed(1)}g',
                  const Color(0xFFEF4444)),
              _totalPill('meal_scan_result.macro_carbs'.tr(), '${carbs.toStringAsFixed(1)}g',
                  const Color(0xFFF59E0B)),
              _totalPill('meal_scan_result.macro_fats'.tr(), '${fats.toStringAsFixed(1)}g',
                  const Color(0xFF10B981)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _totalPill(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 2),
        Text(label,
            style:
            const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
      ],
    );
  }
}

// ── Save Bar ──────────────────────────────────────────────────────────────────

class _SaveBar extends StatelessWidget {
  final Map<int, _SelectedFood> selections;
  final VoidCallback onSave;

  const _SaveBar({required this.selections, required this.onSave});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF3B82F6);
    return BlocBuilder<LogBloc, LogState>(
      builder: (context, state) {
        final isLoading = state is LogLoading && state.isSaving;
        final hasSelections = selections.isNotEmpty;

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            border:
            Border(top: BorderSide(color: Color(0xFFEAEAEA))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!hasSelections)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'meal_scan_result.no_match_note'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    disabledBackgroundColor:
                    const Color(0xFFEAEAEA),
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
                      color: Colors.white.withOpacity(0.8),
                    ),
                  )
                      : Text(
                    hasSelections
                        ? (selections.length == 1
                        ? 'meal_scan_result.save_food_singular'.tr(namedArgs: {'count': '${selections.length}'})
                        : 'meal_scan_result.save_food_plural'.tr(namedArgs: {'count': '${selections.length}'}))
                        : 'meal_scan_result.save_ai_result'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}