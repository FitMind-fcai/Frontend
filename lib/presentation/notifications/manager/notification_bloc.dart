import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/notifications_prefernces_model.dart';
import '../../../domain/use_cases/notifications_use_cases.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationPreferencesUseCase getPreferences;
  final UpdateNotificationPreferencesUseCase updatePreferences;
  final TriggerReminderUseCase triggerReminder;

  NotificationBloc({
    required this.getPreferences,
    required this.updatePreferences,
    required this.triggerReminder,
  }) : super(NotificationInitial()) {
    on<LoadNotificationPreferencesEvent>(_onLoadPreferences);
    on<UpdateNotificationPreferencesEvent>(_onUpdatePreferences);
    on<TriggerReminderEvent>(_onTriggerReminder);
  }

  Future<void> _onLoadPreferences(
      LoadNotificationPreferencesEvent event,
      Emitter<NotificationState> emit,
      ) async {
    emit(NotificationLoading());
    try {
      final prefs = await getPreferences();
      emit(NotificationPreferencesLoaded(prefs));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onUpdatePreferences(
      UpdateNotificationPreferencesEvent event,
      Emitter<NotificationState> emit,
      ) async {
    emit(NotificationLoading());
    try {
      await updatePreferences(event.prefs);
      emit(NotificationPreferencesSaved());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onTriggerReminder(
      TriggerReminderEvent event,
      Emitter<NotificationState> emit,
      ) async {
    try {
      await triggerReminder(event.reminderType);
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}