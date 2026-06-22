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
class SaveNutritionPlanEvent extends PlanEvent {
  final NutritionPlanResult draft;
  const SaveNutritionPlanEvent(this.draft);
}
class SaveWorkoutPlanEvent extends PlanEvent {
final WorkoutPlanResult draft;
const SaveWorkoutPlanEvent(this.draft);

}
class LoadActivePlanEvent extends PlanEvent {
  const LoadActivePlanEvent();
}

class LoadPlanByIdEvent extends PlanEvent {
  final int planId;
  const LoadPlanByIdEvent(this.planId);

  @override
  List<Object> get props => [planId];
}
class LoadActiveWorkoutPlanEvent extends PlanEvent {
  const LoadActiveWorkoutPlanEvent();
}

class LoadWorkoutPlanByIdEvent extends PlanEvent {
  final int planId;
  const LoadWorkoutPlanByIdEvent(this.planId);

  @override
  List<Object> get props => [planId];
}
class DeleteNutritionPlanEvent extends PlanEvent {
  final int planId;
  const DeleteNutritionPlanEvent(this.planId);

  @override
  List<Object> get props => [planId];
}

class DeleteWorkoutPlanEvent extends PlanEvent {
  final int planId;
  const DeleteWorkoutPlanEvent(this.planId);

  @override
  List<Object> get props => [planId];
}
class LoadWorkoutDayExercisesEvent extends PlanEvent {
  final int planId;
  final int dayId;
  const LoadWorkoutDayExercisesEvent(this.planId, this.dayId);
  @override
  List<Object> get props => [planId, dayId];
}



