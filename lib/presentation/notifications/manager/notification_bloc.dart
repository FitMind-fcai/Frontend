import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/coaching_message_model.dart';
import '../../../data/models/notifications_prefernces_model.dart';
import '../../../domain/use_cases/notifications_use_cases.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationPreferencesUseCase getPreferences;
  final UpdateNotificationPreferencesUseCase updatePreferences;
  final TriggerReminderUseCase triggerReminder;
  final GetCoachingMessagesUseCase getCoachingMessagesUseCase;
  final MarkCoachingMessageReadUseCase markCoachingMessageReadUseCase;
  final MarkAllCoachingMessagesReadUseCase markAllCoachingMessagesReadUseCase;
  final DismissCoachingMessageUseCase dismissCoachingMessageUseCase;

  List<CoachingMessageModel> _cachedMessages = [];
  int _cachedUnreadCount = 0;
  NotificationBloc({
    required this.getPreferences,
    required this.updatePreferences,
    required this.triggerReminder,
    required this.getCoachingMessagesUseCase,
    required this.markCoachingMessageReadUseCase,
    required this.markAllCoachingMessagesReadUseCase,
    required this.dismissCoachingMessageUseCase,
  }) : super(NotificationInitial()) {
    on<LoadNotificationPreferencesEvent>(_onLoadPreferences);
    on<UpdateNotificationPreferencesEvent>(_onUpdatePreferences);
    on<TriggerReminderEvent>(_onTriggerReminder);
    on<LoadCoachingMessagesEvent>(_onLoadCoachingMessages);
    on<MarkCoachingMessageReadEvent>(_onMarkCoachingMessageRead);
    on<MarkAllCoachingMessagesReadEvent>(_onMarkAllCoachingMessagesRead);
    on<DismissCoachingMessageEvent>(_onDismissCoachingMessage);
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
  Future<void> _onLoadCoachingMessages(
      LoadCoachingMessagesEvent event,
      Emitter<NotificationState> emit,
      ) async {
    emit(const CoachingMessagesLoading());
    try {
      final result = await getCoachingMessagesUseCase(
        skip: 0,
        limit: 20,
        category: event.category,
        unreadOnly: event.unreadOnly,
      );
      _cachedMessages = result.messages;
      _cachedUnreadCount = result.unreadCount;
      emit(CoachingMessagesLoaded(_cachedMessages, _cachedUnreadCount));
    } catch (e) {
      emit(CoachingMessageActionError(e.toString()));
    }
  }

  Future<void> _onMarkCoachingMessageRead(
      MarkCoachingMessageReadEvent event,
      Emitter<NotificationState> emit,
      ) async {
    try {
      await markCoachingMessageReadUseCase(event.messageId);

      final index = _cachedMessages.indexWhere((m) => m.id == event.messageId);
      if (index != -1 && !_cachedMessages[index].isRead) {
        _cachedMessages[index] = _cachedMessages[index].copyWith(isRead: true);
        _cachedUnreadCount =
            (_cachedUnreadCount - 1).clamp(0, _cachedUnreadCount);
      }
      emit(CoachingMessagesLoaded(
        List<CoachingMessageModel>.from(_cachedMessages),
        _cachedUnreadCount,
      ));
    } catch (e) {
      emit(CoachingMessageActionError(e.toString()));
    }
  }

  Future<void> _onMarkAllCoachingMessagesRead(
      MarkAllCoachingMessagesReadEvent event,
      Emitter<NotificationState> emit,
      ) async {
    try {
      await markAllCoachingMessagesReadUseCase();
      _cachedMessages =
          _cachedMessages.map((m) => m.copyWith(isRead: true)).toList();
      _cachedUnreadCount = 0;
      emit(CoachingMessagesLoaded(
        List<CoachingMessageModel>.from(_cachedMessages),
        _cachedUnreadCount,
      ));
    } catch (e) {
      emit(CoachingMessageActionError(e.toString()));
    }
  }

  Future<void> _onDismissCoachingMessage(
      DismissCoachingMessageEvent event,
      Emitter<NotificationState> emit,
      ) async {
    try {
      await dismissCoachingMessageUseCase(event.messageId);

      final removed = _cachedMessages
          .firstWhere((m) => m.id == event.messageId, orElse: () => _cachedMessages.first);
      final wasUnread = _cachedMessages.any((m) => m.id == event.messageId && !m.isRead);

      _cachedMessages.removeWhere((m) => m.id == event.messageId);
      if (wasUnread) {
        _cachedUnreadCount = (_cachedUnreadCount - 1).clamp(0, _cachedUnreadCount);
      }
      emit(CoachingMessagesLoaded(
        List<CoachingMessageModel>.from(_cachedMessages),
        _cachedUnreadCount,
      ));
    } catch (e) {
      emit(CoachingMessageActionError(e.toString()));
    }
  }
}