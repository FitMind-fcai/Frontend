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