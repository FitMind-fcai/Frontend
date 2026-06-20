import 'package:fitmind/presentation/plan/screens/my_plans/week_days_screen.dart';
import 'package:fitmind/presentation/plan/screens/my_plans/workout_week_days_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/plan/nutrition_plan_result.dart';
import '../../../../data/models/plan/workout_plan_result.dart';
import '../../manager/plan_bloc.dart';
import '../../widgets/macro_pill.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../widgets/nutrition_plan_body.dart';
import '../../widgets/plan_type.dart';
import '../../widgets/week_card.dart';
import '../../widgets/workout_plan_body.dart';

enum _PlanType { nutrition, workout }

class MyPlansScreen extends StatefulWidget {
  const MyPlansScreen({super.key});


  @override
  State<MyPlansScreen> createState() => _MyPlansScreenState();
}

class _MyPlansScreenState extends State<MyPlansScreen> {
  _PlanType? _selectedType;

  void _selectType(_PlanType type) {
    setState(() => _selectedType = type);
    if (type == _PlanType.nutrition) {
      context.read<PlanBloc>().add(LoadActivePlanEvent());
    } else {
      context.read<PlanBloc>().add(const LoadActiveWorkoutPlanEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    // CHANGED: computed once here and reused below — every other color in
    // this file stays exactly as it was for light mode; isDark only
    // branches where a literal color would actually break (white-on-dark,
    // navy text invisible on a dark background, etc).
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<PlanBloc, PlanState>(
      listener: (context, state) {
        if (state is PlanDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.message), backgroundColor: Colors.green),
          );
          // Reset selection type back to selection dashboard screen view after deletion
          setState(() => _selectedType = null);
        }
      },
      child: Scaffold(
        // CHANGED: was always const Color(0xFFF5F5F5). Light mode keeps
        // that exact value; dark mode uses the app's established dark
        // surface instead of a hardcoded equivalent.
        backgroundColor: isDark ? colorScheme.surface : const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Expanded(
                child: _selectedType == null
                    ? _buildTypeSelection()
                    : BlocBuilder<PlanBloc, PlanState>(
                  builder: (context, state) {
                    if (state is MyPlansLoading ||
                        state is PlanInitial ||
                        state is PlanDeleting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                    if (state is PlanError) {
                      return _buildError(context, state.message);
                    }
                    if (state is ActivePlanLoaded) {
                      return PlanBody(plan: state.plan);
                    }
                    if (state is ActiveWorkoutPlanLoaded) {
                      return WorkoutPlanBody(plan: state.plan);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    // Watch or look into the state to see if a delete target ID is present
    final blocState = context.watch<PlanBloc>().state;
    int? activePlanId;

    if (blocState is ActivePlanLoaded) {
      activePlanId = blocState
          .plan.id; // Ensure property name matches model (e.g. plan.id)
    } else if (blocState is ActiveWorkoutPlanLoaded) {
      activePlanId = blocState.plan.id; // Ensure property name matches model
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (_selectedType != null) {
                    setState(() => _selectedType = null);
                  } else {
                    Navigator.maybePop(context);
                  }
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    // CHANGED: was Colors.white — dark mode now uses the
                    // elevated surface tone so this chip still reads as a
                    // distinct card against a dark page background.
                    color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      // CHANGED: was const Color(0xFFEAEAEA) — that border
                      // is nearly invisible against a dark card, so dark
                      // mode uses outlineVariant instead.
                      color: isDark ? colorScheme.outlineVariant : const Color(0xFFEAEAEA),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    // CHANGED: was const Color(0xFF1A1A2E) — that navy is
                    // basically invisible on a dark card, same problem as
                    // every other "near-black on dark" case fixed so far.
                    color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                _selectedType == null
                    ? 'my_plans.title'.tr()
                    : _selectedType == _PlanType.nutrition
                    ? 'my_plans.nutrition_plan_title'.tr()
                    : 'my_plans.workout_plan_title'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  // CHANGED: was const Color(0xFF1A1A2E) — same navy
                  // contrast issue as above.
                  color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                  fontFamily: AppConstants.fontRegular,
                ),
              ),
            ],
          ),
          // Deletion top right conditionally rendered button layout
          if (_selectedType != null && activePlanId != null)
            GestureDetector(
              onTap: () => _showDeleteConfirmation(context, activePlanId!),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  // CHANGED: was Colors.white — same elevated-card fix as
                  // the back button above.
                  color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    // CHANGED: was const Color(0xFFFFEAEA) — same
                    // invisible-border issue as the back button above.
                    color: isDark ? colorScheme.outlineVariant : const Color(0xFFFFEAEA),
                  ),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    size: 20, color: Color(0xFFEF4444)),
                // NOTE: the red icon itself is untouched — it's a vivid
                // accent that reads fine against either card color.
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int planId) {
    // NOTE: no changes needed inside this dialog. AlertDialog has no
    // explicit backgroundColor set, so it already pulls from the active
    // theme automatically, and the title/content Text widgets have no
    // explicit color either, so they inherit the theme's text color too.
    // The grey "Cancel" and red "Delete" labels are both legible against
    // light or dark dialog backgrounds, so they're left as-is.
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('my_plans.delete_plan_title'.tr()),
        content: Text('my_plans.delete_plan_confirm'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('my_plans.cancel'.tr(), style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (_selectedType == _PlanType.nutrition) {
                context.read<PlanBloc>().add(DeleteNutritionPlanEvent(planId));
              } else if (_selectedType == _PlanType.workout) {
                context.read<PlanBloc>().add(DeleteWorkoutPlanEvent(planId));
              }
            },
            child: Text('my_plans.delete'.tr(),
                style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
  }

  // ── Type selection cards ─────────────────────────────────────────────────
  Widget _buildTypeSelection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'my_plans.view_question'.tr(),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              // CHANGED: was const Color(0xFF1A1A2E) — same navy contrast
              // issue fixed throughout this file.
              color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
              fontFamily: AppConstants.fontRegular,
            ),
          ),
          const SizedBox(height: 16),
          PlanTypeCard(
            label: 'my_plans.nutrition_label'.tr(),
            subtitle: 'my_plans.nutrition_subtitle'.tr(),
            imagePath: 'assets/images/meal_image.png',
            accentColor: const Color(0xFF3B82F6),
            onTap: () => _selectType(_PlanType.nutrition),
          ),
          const SizedBox(height: 14),
          PlanTypeCard(
            label: 'my_plans.workout_label'.tr(),
            subtitle: 'my_plans.workout_subtitle'.tr(),
            imagePath: 'assets/images/workout_card.png',
            accentColor: AppConstants.primaryColor,
            onTap: () => _selectType(_PlanType.workout),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // CHANGED: was Colors.white — dark mode uses the elevated
                // surface tone, same fix as the header chips.
                color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.error_outline_rounded,
                  size: 48, color: Color(0xFFEF4444)),
              // NOTE: red icon untouched — vivid accent, fine in both themes.
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                // CHANGED: was const Color(0xFF6B7280) — kept exactly for
                // light mode, swapped to onSurfaceVariant for dark so this
                // secondary text stays legible against a dark background.
                color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF6B7280),
                fontFamily: AppConstants.fontRegular,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedType == _PlanType.nutrition) {
                    context.read<PlanBloc>().add(LoadActivePlanEvent());
                  } else if (_selectedType == _PlanType.workout) {
                    context
                        .read<PlanBloc>()
                        .add(const LoadActiveWorkoutPlanEvent());
                  }
                },
                style: ElevatedButton.styleFrom(
                  // NOTE: backgroundColor/foregroundColor untouched — the
                  // button is always orange with white text/icon on top
                  // of it, regardless of theme.
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'my_plans.try_again'.tr(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppConstants.fontRegular,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}