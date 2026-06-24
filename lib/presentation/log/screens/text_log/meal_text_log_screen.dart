import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../data/models/meal_log/meal_text_result.dart';
import '../../../../data/models/save_log_request.dart';
import '../../manager/log_bloc.dart';
import '../../widgets/text_log_shared_widgets.dart';
import '../log_choice_screen.dart';
import '../../widgets/log_page_shell.dart';

class TextLogMealPage extends StatefulWidget {
  const TextLogMealPage({super.key});

  @override
  State<TextLogMealPage> createState() => _TextLogMealPageState();
}

class _TextLogMealPageState extends State<TextLogMealPage> {
  static const Color accent = Color(0xFF3B82F6);

  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  FoodSearchResult? _selectedFood;
  String _selectedMealType = 'Lunch';
  double _servings = 1.0;

  static const _quickSearchKeys = [
    'text_log_meal.quick_search_grilled_chicken',
    'text_log_meal.quick_search_scrambled_eggs',
    'text_log_meal.quick_search_oats',
    'text_log_meal.quick_search_protein_shake',
    'text_log_meal.quick_search_salad_tuna',
  ];

  // ── Derived macros for selected food + servings ───────────────────────────

  double get _calories =>
      _selectedFood?.caloriesForServings(_servings) ?? 0;
  double get _protein =>
      _selectedFood?.proteinForServings(_servings) ?? 0;
  double get _carbs =>
      _selectedFood?.carbsForServings(_servings) ?? 0;
  double get _fats =>
      _selectedFood?.fatsForServings(_servings) ?? 0;

  // ── Actions ───────────────────────────────────────────────────────────────

  void _search(String query) {
    if (query.trim().length < 2) return;
    _searchFocus.unfocus();
    context.read<LogBloc>().add(SearchFoodsEvent(query.trim()));
  }

  void _onSave() {
    if (_selectedFood == null) return;
    final request = SaveLogRequest(
      category: 'meal',
      logDate: DateFormat('yyyy-MM-dd',"en").format(DateTime.now()),
      logMethod: 'TEXT',
      mealEntries: [
        MealLogEntry(
          centralFoodId: _selectedFood!.id,
          mealType: _selectedMealType.toUpperCase(),
          mealName: _selectedFood!.foodName,
          servings: _servings,
          servingSizeGSnapshot: _selectedFood!.servingSizeG,
          servingDescriptionSnapshot: _selectedFood!.servingDescription,
          calories: _calories,
          proteinG: _protein,
          carbsG: _carbs,
          fatsG: _fats,
        ),
      ],
    );
    context.read<LogBloc>().add(SaveLogsEvent(request));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogBloc, LogState>(
      listener: (context, state) {
        if (state is LogSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'text_log_meal.logged_snackbar'.tr(namedArgs: {
                  'name': _selectedFood!.foodName,
                  'calories': _calories.toStringAsFixed(0),
                }),
              ),
              backgroundColor: accent,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
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
      child: LogPageShell(
        type: LogType.meal,
        methodLabel: 'text_log_meal.method_label'.tr(),
        body: GestureDetector(
          onTap: () => _searchFocus.unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // ── Meal type selector ─────────────────────────────────────
                MealTypeSelector(
                  selected: _selectedMealType,
                  accent: accent,
                  onSelect: (type) =>
                      setState(() => _selectedMealType = type),
                ),

                const SizedBox(height: 20),

                // ── Search bar ─────────────────────────────────────────────
                SearchBar(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  accent: accent,
                  hint: 'text_log_meal.search_hint'.tr(),
                  onSearch: _search,
                ),

                const SizedBox(height: 12),

                // ── Quick search chips ─────────────────────────────────────
                if (_selectedFood == null)
                  QuickChips(
                    items: _quickSearchKeys.map((k) => k.tr()).toList(),
                    accent: accent,
                    onTap: (q) {
                      _searchController.text = q;
                      _search(q);
                    },
                  ),

                const SizedBox(height: 16),

                // ── Results / selected food ────────────────────────────────
                Expanded(
                  child: BlocBuilder<LogBloc, LogState>(
                    builder: (context, state) {
                      if (state is LogLoading && !state.isSaving) {
                        return const Center(
                          child: CircularProgressIndicator(color: accent),
                        );
                      }

                      if (state is FoodSearchSuccess && _selectedFood == null) {
                        if (state.results.isEmpty) {
                          return EmptyResults(
                              message: 'text_log_meal.no_results'.tr());
                        }
                        return ListView.separated(
                          itemCount: state.results.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                          itemBuilder: (_, i) => FoodResultCard(
                            food: state.results[i],
                            accent: accent,
                            onTap: () => setState(
                                    () => _selectedFood = state.results[i]),
                          ),
                        );
                      }

                      if (_selectedFood != null) {
                        return SelectedFoodPanel(
                          food: _selectedFood!,
                          servings: _servings,
                          calories: _calories,
                          protein: _protein,
                          carbs: _carbs,
                          fats: _fats,
                          accent: accent,
                          onServingsChanged: (v) =>
                              setState(() => _servings = v),
                          onClear: () => setState(() {
                            _selectedFood = null;
                            _servings = 1.0;
                          }),
                        );
                      }

                      // Initial / idle state
                      return IdleHint(
                        message: 'text_log_meal.idle_hint'.tr(),
                        icon: Icons.restaurant_outlined,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // ── Save button ────────────────────────────────────────────
                SaveButton(
                  enabled: _selectedFood != null,
                  isSaving: context.watch<LogBloc>().state is LogLoading &&
                      (context.watch<LogBloc>().state as LogLoading).isSaving,
                  accent: accent,
                  label: _selectedFood != null
                      ? 'text_log_meal.save_button_ready'.tr(namedArgs: {'calories': _calories.toStringAsFixed(0)})
                      : 'text_log_meal.save_button_empty'.tr(),
                  onTap: _onSave,
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}