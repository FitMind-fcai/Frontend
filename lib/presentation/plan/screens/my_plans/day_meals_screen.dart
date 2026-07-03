import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/plan/nutrition_plan_result.dart';
import 'package:easy_localization/easy_localization.dart';
class DayMealsScreen extends StatelessWidget {
  final DayPlan day;
  final DateTime? date;
final String Location;
  const DayMealsScreen({super.key, required this.day, this.date,required this.Location});

  String _formatDate(DateTime d) {
    final months = [
      '',
      'week_days.month_january'.tr(),
      'week_days.month_february'.tr(),
      'week_days.month_march'.tr(),
      'week_days.month_april'.tr(),
      'week_days.month_may'.tr(),
      'week_days.month_june'.tr(),
      'week_days.month_july'.tr(),
      'week_days.month_august'.tr(),
      'week_days.month_september'.tr(),
      'week_days.month_october'.tr(),
      'week_days.month_november'.tr(),
      'week_days.month_december'.tr(),
    ];
    final weekdays = [
      '',
      'week_days.weekday_monday'.tr(),
      'week_days.weekday_tuesday'.tr(),
      'week_days.weekday_wednesday'.tr(),
      'week_days.weekday_thursday'.tr(),
      'week_days.weekday_friday'.tr(),
      'week_days.weekday_saturday'.tr(),
      'week_days.weekday_sunday'.tr(),
    ];
    return 'day_meals.date_label'.tr(namedArgs: {
      'weekday': weekdays[d.weekday],
      'day': '${d.day}',
      'month': months[d.month],
      'year': '${d.year}',
    });
  }

  int get _totalCalories => day.meals.fold(0, (sum, m) => sum + m.calories);

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Location == "Home"
                      ? const SizedBox.shrink()
                      : GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: isDark ? colorScheme.outlineVariant : const Color(0xFFEAEAEA),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day.dayName.isNotEmpty
                              ? day.dayName
                              : 'day_meals.day_label'.tr(namedArgs: {'number': '${day.dayNumber}'}),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            // CHANGED: was const Color(0xFF1A1A2E).
                            color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                            letterSpacing: -0.5,
                            fontFamily: AppConstants.fontRegular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryItem(
                      label: 'day_meals.summary_calories'.tr(),
                      value: '$_totalCalories',
                      color: const Color(0xFFF97316),
                    ),
                    _divider(),
                    _SummaryItem(
                      label: 'day_meals.summary_meals'.tr(),
                      value: '${day.meals.length}',
                      color: const Color(0xFF3B82F6),
                    ),
                    _divider(),
                    _SummaryItem(
                      label: 'day_meals.summary_protein'.tr(),
                      value: '${day.meals.fold(0, (s, m) => s + m.proteinG)}g',
                      color: const Color(0xFF10B981),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ── Meals list ────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: day.meals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _MealCard(meal: day.meals[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 30,
    color: Colors.white.withOpacity(0.1),
  );
}

class _SummaryItem extends StatelessWidget {
  final String label, value;
  final Color color;

  const _SummaryItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
            fontFamily: AppConstants.fontRegular,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white54,
            fontFamily: AppConstants.fontRegular,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Meal Card  (expandable)
// ─────────────────────────────────────────────────────────────────────────────

class _MealCard extends StatefulWidget {
  final Meal meal;

  const _MealCard({required this.meal});

  @override
  State<_MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<_MealCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  Color get _mealColor {
    switch (widget.meal.mealType.toLowerCase()) {
      case 'breakfast':
        return const Color(0xFFF59E0B);
      case 'lunch':
        return const Color(0xFF3B82F6);
      case 'dinner':
        return const Color(0xFF8B5CF6);
      case 'snack':
        return const Color(0xFF10B981);
      default:
        return AppConstants.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final meal = widget.meal;

    return GestureDetector(
      onTap: _toggle,
      child: Container(
        decoration: BoxDecoration(
          // CHANGED: was Colors.white.
          color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // CHANGED: dropped entirely in dark mode — same smudge issue
              // as every other card shadow fixed so far.
              color: isDark ? Colors.transparent : Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Collapsed row ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // NOTE: this badge and its text use _mealColor, a brand
                  // accent per meal type — untouched in both themes.
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: _mealColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${meal.calories}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: _mealColor,
                              fontFamily: AppConstants.fontRegular,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'day_meals.unit_kcal_short'.tr(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: _mealColor.withOpacity(0.6),
                              fontFamily: AppConstants.fontRegular,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.mealName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            // CHANGED: was const Color(0xFF1A1A2E).
                            color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                            fontFamily: AppConstants.fontRegular,
                          ),
                        ),
                        const SizedBox(height: 3),
                        // NOTE: _mealColor accent tint — untouched.
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: _mealColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            meal.mealType,
                            style: TextStyle(
                              fontSize: 11,
                              color: _mealColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppConstants.fontRegular,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // NOTE: light gray chevron — already reads fine on a
                  // dark card too, same reasoning as the workout day card.
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: _expanded ? 0.5 : 0,
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFFD1D5DB), size: 24),
                  ),
                ],
              ),
            ),
            // ── Macro pills row ───────────────────────────────────────
            // NOTE: all _MacroTag colors are brand/accent tints — untouched.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  _MacroTag(
                      label: '${meal.proteinG}g',
                      sub: 'day_meals.macro_protein'.tr(),
                      color: const Color(0xFF3B82F6)),
                  const SizedBox(width: 6),
                  _MacroTag(
                      label: '${meal.carbsG}g',
                      sub: 'day_meals.macro_carbs'.tr(),
                      color: const Color(0xFF10B981)),
                  const SizedBox(width: 6),
                  _MacroTag(
                      label: '${meal.fatsG}g',
                      sub: 'day_meals.macro_fats'.tr(),
                      color: const Color(0xFFF97316)),
                  if (meal.prepTimeMinutes != null) ...[
                    const SizedBox(width: 6),
                    _MacroTag(
                        label: 'day_meals.prep_time_short'.tr(namedArgs: {'count': '${meal.prepTimeMinutes}'}),
                        sub: 'Prep',
                        color: const Color(0xFF8B5CF6)),
                  ],
                ],
              ),
            ),
            // ── Expanded details ──────────────────────────────────────
            FadeTransition(
              opacity: _fade,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: _expanded
                    ? _ExpandedDetails(meal: meal)
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroTag extends StatelessWidget {
  final String label, sub;
  final Color color;

  const _MacroTag(
      {required this.label, required this.sub, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: AppConstants.fontRegular,
            ),
          ),
          Text(
            sub,
            style: TextStyle(
              fontSize: 10,
              color: color.withOpacity(0.7),
              fontFamily: AppConstants.fontRegular,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandedDetails extends StatelessWidget {
  final Meal meal;

  const _ExpandedDetails({required this.meal});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CHANGED: was const Divider(color: Color(0xFFF3F4F6)) — that's
          // a deliberately near-invisible hairline against a white card,
          // but would turn into a glaring bright line against a dark one.
          // outlineVariant gives the same "barely there" effect on dark.
          Divider(
            color: isDark ? colorScheme.outlineVariant : const Color(0xFFF3F4F6),
            thickness: 1,
          ),
          const SizedBox(height: 10),
          if (meal.description != null && meal.description!.isNotEmpty) ...[
            _sectionTitle('day_meals.section_description'.tr(), isDark, colorScheme),
            const SizedBox(height: 6),
            Text(
              meal.description!,
              style: TextStyle(
                fontSize: 13,
                // CHANGED: was const Color(0xFF6B7280) — too low-contrast
                // against a dark card, swapped to onSurfaceVariant.
                color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF6B7280),
                height: 1.5,
                fontFamily: AppConstants.fontRegular,
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (meal.ingredients.isNotEmpty) ...[
            _sectionTitle('day_meals.section_ingredients'.tr(), isDark, colorScheme),
            const SizedBox(height: 10),
            ...meal.ingredients.map((ing) => _IngredientRow(ingredient: ing)),
          ],
          if (meal.instructions != null && meal.instructions!.isNotEmpty) ...[
            _sectionTitle('day_meals.section_instructions'.tr(), isDark, colorScheme),
            const SizedBox(height: 6),
            Text(
              meal.instructions!,
              style: TextStyle(
                fontSize: 13,
                // CHANGED: same as the description text above.
                color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF6B7280),
                height: 1.6,
                fontFamily: AppConstants.fontRegular,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // CHANGED: now takes isDark/colorScheme so the heading can swap away
  // from the navy-on-dark problem, same as every section title elsewhere.
  Widget _sectionTitle(String text, bool isDark, ColorScheme colorScheme) => Text(
    text,
    style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
      fontFamily: AppConstants.fontRegular,
    ),
  );
}
class _IngredientRow extends StatelessWidget {
  final Ingredient ingredient;
  const _IngredientRow({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // CHANGED: was const Color(0xFFF9FAFB) — a near-white tile that
        // would look like a stray pale patch on a dark card. A faint white
        // overlay keeps the same "one step lighter than the card" effect
        // without a hardcoded dark hex.
        color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          // CHANGED: was const Color(0xFFE5E7EB).
          color: isDark ? colorScheme.outlineVariant : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Food name + amount ──────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  ingredient.foodName?? 'Unknown ingredient',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    // CHANGED: was const Color(0xFF1A1A2E).
                    color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                    fontFamily: AppConstants.fontRegular,
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  // CHANGED: was Color(0xFF1A1A2E).withOpacity(0.06) — a
                  // near-black tint at 6% opacity is meant to read as a
                  // faint badge against a *white* card. Tinting with the
                  // same near-black color on an already-dark card would
                  // make the badge disappear completely rather than stay
                  // subtle, so dark mode needs a light tint instead.
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : const Color(0xFF1A1A2E).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  '${ingredient.amountG.toStringAsFixed(ingredient.amountG % 1 == 0 ? 0 : 1)}g',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    // CHANGED: was const Color(0xFF1A1A2E).
                    color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                    fontFamily: AppConstants.fontRegular,
                  ),
                ),
              ),
            ],
          ),
          // NOTE: mid-tone gray, already reads fine on both — untouched.
          if (ingredient.foodCategory != null) ...[
            const SizedBox(height: 3),
            Text(
              ingredient.foodCategory!,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
                fontFamily: AppConstants.fontRegular,
              ),
            ),
          ],
          const SizedBox(height: 8),
          // ── Macro row ───────────────────────────────────────────
          // NOTE: all _IngMacro colors are brand/accent tints — untouched.
          Row(
            children: [
              _IngMacro(
                label: 'day_meals.ing_macro_cal'.tr(),
                value: ingredient.calories!.toStringAsFixed(0),
                color: const Color(0xFFF97316),
              ),
              const SizedBox(width: 6),
              _IngMacro(
                label: 'day_meals.ing_macro_protein'.tr(),
                value: '${ingredient.proteinG?.toStringAsFixed(1)}g',
                color: const Color(0xFF3B82F6),
              ),
              const SizedBox(width: 6),
              _IngMacro(
                label: 'day_meals.ing_macro_carbs'.tr(),
                value: '${ingredient.carbsG?.toStringAsFixed(1)}g',
                color: const Color(0xFF10B981),
              ),
              const SizedBox(width: 6),
              _IngMacro(
                label: 'day_meals.ing_macro_fats'.tr(),
                value: '${ingredient.fatsG?.toStringAsFixed(1)}g',
                color: const Color(0xFFF59E0B),
              ),
              if (ingredient.fiberG != null) ...[
                const SizedBox(width: 6),
                _IngMacro(
                  label: 'day_meals.ing_macro_fiber'.tr(),
                  value: '${ingredient.fiberG!.toStringAsFixed(1)}g',
                  color: const Color(0xFF8B5CF6),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _IngMacro extends StatelessWidget {
  final String label, value;
  final Color color;

  const _IngMacro(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
                fontFamily: AppConstants.fontRegular,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: color.withOpacity(0.7),
                fontFamily: AppConstants.fontRegular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}