part of 'plan_bloc.dart';

@immutable
abstract class PlanState extends Equatable {
  const PlanState();

  @override
  List<Object?> get props => [];
}

class PlanInitial extends PlanState {}

class PlanLoading extends PlanState {
  final bool isSaving;
  const PlanLoading({this.isSaving = false});

  @override
  List<Object?> get props => [isSaving];
}
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
class NutritionPlanSaveSuccess extends PlanState {}
class WorkoutPlanSaveSuccess extends PlanState {}
class ActivePlanLoaded extends PlanState {
  final NutritionPlanResult plan;
  const ActivePlanLoaded(this.plan);

  @override
  List<Object?> get props => [plan];
}

class PlanByIdLoaded extends PlanState {
  final NutritionPlanResult plan;
  const PlanByIdLoaded(this.plan);

  @override
  List<Object?> get props => [plan];
}
class MyPlansLoading extends PlanState {}
class ActiveWorkoutPlanLoaded extends PlanState {
final WorkoutPlanResult plan;
const ActiveWorkoutPlanLoaded(this.plan);

@override
List<Object?> get props => [plan];
}

class WorkoutPlanByIdLoaded extends PlanState {
final WorkoutPlanResult plan;
const WorkoutPlanByIdLoaded(this.plan);

@override
List<Object?> get props => [plan];
}
class PlanDeleting extends PlanState {}

class PlanDeleteSuccess extends PlanState {
  final String message;
  const PlanDeleteSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
class WorkoutDayExercisesLoaded extends PlanState {
  final List<Exercise> exercises;
  const WorkoutDayExercisesLoaded(this.exercises);
  @override
  List<Object?> get props => [exercises];
}
// If PlanLoading doesn't carry isSaving yet, add a flag:

