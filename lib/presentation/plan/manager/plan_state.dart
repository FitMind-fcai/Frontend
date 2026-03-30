part of 'plan_bloc.dart';

@immutable
abstract class PlanState extends Equatable {
  const PlanState();

  @override
  List<Object?> get props => [];
}

class PlanInitial extends PlanState {}

class PlanLoading extends PlanState {}

class NutritionPreferencesSuccess extends PlanState {
  final NutritionPlanResult plan;

  const NutritionPreferencesSuccess(this.plan);

  @override
  List<Object?> get props => [plan];
}

class WorkoutPreferencesSuccess extends PlanState {
  final WorkoutPlanResult plan;
  const WorkoutPreferencesSuccess(this.plan);

  @override
  List<Object?> get props => [plan];
}

class PlanError extends PlanState {
  final String message;

  const PlanError(this.message);

  @override
  List<Object?> get props => [message];
}
