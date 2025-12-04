part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitProfileEvent extends ProfileEvent {
  final ProfileBody profile;

  SubmitProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}
