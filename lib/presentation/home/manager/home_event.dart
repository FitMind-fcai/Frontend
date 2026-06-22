part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class GetNextMealEvent extends HomeEvent {
  final String? time;
  const GetNextMealEvent({this.time});

  @override
  List<Object?> get props => [time];
}

class GetTodayWorkoutEvent extends HomeEvent {
  const GetTodayWorkoutEvent();
}

class GetScoreEvent extends HomeEvent {
  const GetScoreEvent();
}

class LoadHomeEvent extends HomeEvent {
  final String? mealTime;
  const LoadHomeEvent({this.mealTime});

  @override
  List<Object?> get props => [mealTime];
}
class RefreshLiveMetricsEvent extends HomeEvent {
  const RefreshLiveMetricsEvent();
}