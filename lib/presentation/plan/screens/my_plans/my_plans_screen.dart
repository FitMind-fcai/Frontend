import 'package:fitmind/presentation/plan/screens/my_plans/week_days_screen.dart';
import 'package:fitmind/presentation/plan/screens/my_plans/workout_week_days_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/plan/nutrition_plan_result.dart';
import '../../../../data/models/plan/workout_plan_result.dart';
import '../../manager/plan_bloc.dart';
import '../../widgets/macro_pill.dart';
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
        backgroundColor: const Color(0xFFF5F5F5),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: const Color(0xFFEAEAEA)),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 16, color: Color(0xFF1A1A2E)),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                _selectedType == null
                    ? 'My Plans'
                    : _selectedType == _PlanType.nutrition
                        ? 'Nutrition Plan'
                        : 'Workout Plan',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: const Color(0xFFFFEAEA)),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    size: 20, color: Color(0xFFEF4444)),
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int planId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Plan'),
        content: const Text(
            'Are you sure you want to delete this active plan permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
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
            child: const Text('Delete',
                style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
  }

  // ── Type selection cards ─────────────────────────────────────────────────
  Widget _buildTypeSelection() => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What would you like to view?',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
                fontFamily: AppConstants.fontRegular,
              ),
            ),
            const SizedBox(height: 16),
            PlanTypeCard(
              label: 'Nutrition',
              subtitle: 'View your meal & calorie plans',
              imagePath: 'assets/images/meal_image.png',
              accentColor: const Color(0xFF3B82F6),
              onTap: () => _selectType(_PlanType.nutrition),
            ),
            const SizedBox(height: 14),
            PlanTypeCard(
              label: 'Workout',
              subtitle: 'View your exercise & training plans',
              imagePath: 'assets/images/workout_card.png',
              accentColor: AppConstants.primaryColor,
              onTap: () => _selectType(_PlanType.workout),
            ),
          ],
        ),
      );

  Widget _buildError(BuildContext context, String message) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.error_outline_rounded,
                    size: 48, color: Color(0xFFEF4444)),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
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
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
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
