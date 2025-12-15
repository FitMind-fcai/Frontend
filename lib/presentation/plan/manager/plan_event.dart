part of 'plan_bloc.dart';

@immutable
abstract class PlanEvent extends Equatable {
  const PlanEvent();

  @override
  List<Object> get props => [];
}

class SubmitNutritionPreferencesEvent extends PlanEvent {
  final NutritionPlanGenerationRequest request;

  const SubmitNutritionPreferencesEvent(this.request);

  @override
  List<Object> get props => [request];
}

class SubmitWorkoutPreferencesEvent extends PlanEvent {
  final WorkoutPlanGenerationRequest request;

  const SubmitWorkoutPreferencesEvent(this.request);

  @override
  List<Object> get props => [request];
}
