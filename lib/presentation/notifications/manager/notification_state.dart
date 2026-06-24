part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationPreferencesLoaded extends NotificationState {
  final NotificationPreferencesModel prefs;
  const NotificationPreferencesLoaded(this.prefs);

  @override
  List<Object?> get props => [prefs];
}

class NotificationPreferencesSaved extends NotificationState {}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
class CoachingMessagesLoaded extends NotificationState {
  final List<CoachingMessageModel> messages;
  final int unreadCount;
  const CoachingMessagesLoaded(this.messages, this.unreadCount);

  @override
  List<Object?> get props => [messages, unreadCount];
}

class CoachingMessagesLoading extends NotificationState {
  const CoachingMessagesLoading();

  @override
  List<Object?> get props => [];
}

class CoachingMessageActionError extends NotificationState {
  final String message;
  const CoachingMessageActionError(this.message);

  @override
  List<Object?> get props => [message];
}