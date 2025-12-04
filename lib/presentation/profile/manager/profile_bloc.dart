import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/models/profile_body.dart';
import '../../../domain/use_cases/profile_use_cases.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final CreateProfileUseCase createProfile;

  ProfileBloc(this.createProfile) : super(ProfileInitial()) {
    on<SubmitProfileEvent>(_onSubmitProfile);
  }

  Future<void> _onSubmitProfile(
      SubmitProfileEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());

    try {
      await createProfile(event.profile); // ✅ use case
      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
