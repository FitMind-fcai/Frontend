part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationPreferencesEvent extends NotificationEvent {}

class UpdateNotificationPreferencesEvent extends NotificationEvent {
  final NotificationPreferencesModel prefs;
  const UpdateNotificationPreferencesEvent(this.prefs);

  @override
  List<Object?> get props => [prefs];
}

class TriggerReminderEvent extends NotificationEvent {
  final String reminderType;
  const TriggerReminderEvent(this.reminderType);

  @override
  List<Object?> get props => [reminderType];
}
class LoadCoachingMessagesEvent extends NotificationEvent {
  final String? category;
  final bool unreadOnly;
  final bool isRefresh; // true = pull-to-refresh / initial, false = load more
  const LoadCoachingMessagesEvent({
    this.category,
    this.unreadOnly = false,
    this.isRefresh = true,
  });

  @override
  List<Object?> get props => [category, unreadOnly, isRefresh];
}

class MarkCoachingMessageReadEvent extends NotificationEvent {
  final int messageId;
  const MarkCoachingMessageReadEvent(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class MarkAllCoachingMessagesReadEvent extends NotificationEvent {
  const MarkAllCoachingMessagesReadEvent();

  @override
  List<Object?> get props => [];
}

class DismissCoachingMessageEvent extends NotificationEvent {
  final int messageId;
  const DismissCoachingMessageEvent(this.messageId);

  @override
  List<Object?> get props => [messageId];
}