import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/models/plan/nutrition_plan_generation_request.dart';
import '../../../data/models/plan/nutrition_plan_result.dart';
import '../../../data/models/plan/workout_plan_generation_request.dart';
import '../../../data/models/plan/workout_plan_result.dart';
import '../../../domain/use_cases/plan_use_cases.dart';

part 'plan_event.dart';
part 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final CreateNutritionPreferencesUseCase createNutritionPreferences;
  final CreateWorkoutPreferencesUseCase createWorkoutPreferences;
  final SaveNutritionPlanUseCase saveNutritionPlanUseCase;
  final SaveWorkoutPlanUseCase saveWorkoutPlanUseCase;
  final GetActiveNutritionPlanUseCase getActiveNutritionPlanUseCase;
  final GetNutritionPlanByIdUseCase getNutritionPlanByIdUseCase;
  final GetActiveWorkoutPlanUseCase getActiveWorkoutPlanUseCase;
  final GetWorkoutPlanByIdUseCase getWorkoutPlanByIdUseCase;
  final DeleteNutritionPlanUseCase deleteNutritionPlanUseCase;
  final DeleteWorkoutPlanUseCase deleteWorkoutPlanUseCase;

  PlanBloc(
      this.createNutritionPreferences,
      this.createWorkoutPreferences,
      this.saveNutritionPlanUseCase,
      this.saveWorkoutPlanUseCase,
      this.getActiveNutritionPlanUseCase,
      this.getNutritionPlanByIdUseCase,
      this.getActiveWorkoutPlanUseCase,
      this.getWorkoutPlanByIdUseCase,
      this.deleteNutritionPlanUseCase,
      this.deleteWorkoutPlanUseCase,
      ) : super(PlanInitial()) {
    on<SubmitNutritionPreferencesEvent>(_onSubmitNutritionPreferences);
    on<SubmitWorkoutPreferencesEvent>(_onSubmitWorkoutPreferences);
    on<SaveNutritionPlanEvent>(_onSaveNutritionPlan);
    on<SaveWorkoutPlanEvent>(_onSaveWorkoutPlan);
    on<LoadActivePlanEvent>(_onLoadActivePlan);
    on<LoadPlanByIdEvent>(_onLoadPlanById);
    on<LoadActiveWorkoutPlanEvent>(_onLoadActiveWorkoutPlan);
    on<LoadWorkoutPlanByIdEvent>(_onLoadWorkoutPlanById);
  }

  Future<void> _onSubmitNutritionPreferences(
      SubmitNutritionPreferencesEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(PlanLoading());
    try {
      final result = await createNutritionPreferences(event.request);
      emit(NutritionPreferencesSuccess(result));
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
      final result = await createWorkoutPreferences(event.request);
      emit(WorkoutPreferencesSuccess(result));
    } catch (e) {
      emit(PlanError(e.toString()));
    }
  }

  Future<void> _onSaveNutritionPlan(
      SaveNutritionPlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(const PlanLoading(isSaving: true));
    try {
      await saveNutritionPlanUseCase(event.draft);
      emit(NutritionPlanSaveSuccess());
    } catch (e) {
      emit(PlanError(e.toString()));
    }
  }
  Future<void> _onSaveWorkoutPlan(
      SaveWorkoutPlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(const PlanLoading(isSaving: true));
    try {
      await saveWorkoutPlanUseCase(event.draft);
      emit(WorkoutPlanSaveSuccess());
    } catch (e) {
      emit(PlanError(e.toString()));
    }
  }
  Future<void> _onLoadActivePlan(
      LoadActivePlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(MyPlansLoading());
    try {
      final result = await getActiveNutritionPlanUseCase();
      emit(ActivePlanLoaded(result));
    } catch (e) {
      emit(PlanError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLoadPlanById(
      LoadPlanByIdEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(MyPlansLoading());
    try {
      final result = await getNutritionPlanByIdUseCase(event.planId);
      emit(PlanByIdLoaded(result));
    } catch (e) {
      emit(PlanError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLoadActiveWorkoutPlan(
      LoadActiveWorkoutPlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(MyPlansLoading());
    try {
      final result = await getActiveWorkoutPlanUseCase();
      emit(ActiveWorkoutPlanLoaded(result));
    } catch (e) {
      emit(PlanError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLoadWorkoutPlanById(
      LoadWorkoutPlanByIdEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(MyPlansLoading());
    try {
      final result = await getWorkoutPlanByIdUseCase(event.planId);
      emit(WorkoutPlanByIdLoaded(result));
    } catch (e) {
      emit(PlanError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
  Future<void> _onDeleteNutritionPlan(
      DeleteNutritionPlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(PlanDeleting());
    try {
      await deleteNutritionPlanUseCase(event.planId);
      emit(const PlanDeleteSuccess("Nutrition plan deleted successfully"));
    } catch (e) {
      emit(PlanError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onDeleteWorkoutPlan(
      DeleteWorkoutPlanEvent event,
      Emitter<PlanState> emit,
      ) async {
    emit(PlanDeleting());
    try {
      await deleteWorkoutPlanUseCase(event.planId);
      emit(const PlanDeleteSuccess("Workout plan deleted successfully"));
    } catch (e) {
      emit(PlanError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
