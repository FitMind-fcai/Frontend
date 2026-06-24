// lib/presentation/log/screens/voice_meal_result_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/meal_log/voice_meal_scan_result.dart' ;
import '../../../../data/models/save_log_request.dart';
import '../../manager/log_bloc.dart';
import '../../widgets/voice_log_shared_widgets.dart';

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
    _logDate = DateFormat('yyyy-MM-dd',"en").format(DateTime.now());
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
              SectionCard(
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

            SectionCard(
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
                  MealTypeSelector(
                    selected: _mealType,
                    onChanged: (v) => setState(() => _mealType = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            MacroRow(
              calories: widget.result.estimatedCalories,
              protein: widget.result.estimatedProteinG,
              carbs: widget.result.estimatedCarbsG,
              fats: widget.result.estimatedFatsG,
              accent: _blue,
            ),

            const SizedBox(height: 14),

            if (widget.result.foodItems.isNotEmpty)
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label('voice_meal_result.items_detected'.tr()),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.result.foodItems
                          .asMap()
                          .entries
                          .map((e) => FoodChip(
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
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Label('voice_meal_result.best_matches'.tr()),
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
                    ...widget.result.matchedFoods.map((food) => MatchedFoodTile(
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

            SectionCard(
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
                  ServingsStepper(
                    value: _servings,
                    accent: _blue,
                    onChanged: (v) => setState(() => _servings = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            if (widget.result.notes.isNotEmpty)
              SectionCard(
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
        bottomSheet: SaveBar(
          label: 'voice_meal_result.save_button'.tr(),
          accent: _blue,
          onSave: _onSave,
        ),
      ),
    );
  }
}





