part of 'plan_bloc.dart';

@immutable
abstract class PlanState extends Equatable {
  const PlanState();

  @override
  List<Object> get props => [];
}

class PlanInitial extends PlanState {}

class PlanLoading extends PlanState {}

class NutritionPreferencesSuccess extends PlanState {}

class WorkoutPreferencesSuccess extends PlanState {}

class PlanError extends PlanState {
  final String message;

  const PlanError(this.message);

  @override
  List<Object> get props => [message];
}
