import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/models/plan/nutrition_plan_generation_request.dart';
import '../../../data/models/plan/workout_plan_generation_request.dart';
import '../../../domain/use_cases/plan_use_cases.dart';

part 'plan_event.dart';

part 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final CreateNutritionPreferencesUseCase createNutritionPreferences;
  final CreateWorkoutPreferencesUseCase createWorkoutPreferences;

  PlanBloc(
    this.createNutritionPreferences,
    this.createWorkoutPreferences,
  ) : super(PlanInitial()) {
    on<SubmitNutritionPreferencesEvent>(_onSubmitNutritionPreferences);
    on<SubmitWorkoutPreferencesEvent>(_onSubmitWorkoutPreferences);
  }

  Future<void> _onSubmitNutritionPreferences(
    SubmitNutritionPreferencesEvent event,
    Emitter<PlanState> emit,
  ) async {
    emit(PlanLoading());

    try {
      await createNutritionPreferences(event.request);
      emit(NutritionPreferencesSuccess());
    } catch (e) {
      emit(PlanError(e.toString()));
    }
  }

  Future<void> _onSubmitWorkoutPreferences(
    SubmitWorkoutPreferencesEvent event,
    Emitter<PlanState> emit,
  ) async {
    emit(PlanLoading());

    try {
      await createWorkoutPreferences(event.request);
      emit(WorkoutPreferencesSuccess());
    } catch (e) {
      emit(PlanError(e.toString()));
    }
  }
}
