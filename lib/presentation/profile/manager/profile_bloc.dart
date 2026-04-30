import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/profile_body.dart';
import '../../../domain/use_cases/profile_use_cases.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final CreateProfileUseCase createProfile;
  final GetMyProfileUseCase getProfile;
  final UpdateProfileUseCase updateProfile;

  ProfileBloc({
    required this.createProfile,
    required this.getProfile,
    required this.updateProfile,
  }) : super(ProfileInitial()) {
    on<SubmitProfileEvent>(_onSubmitProfile);
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onSubmitProfile(
      SubmitProfileEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      await createProfile(event.profile);
      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLoadProfile(
      LoadProfileEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final profile = await getProfile();
      if (profile != null) {
        emit(ProfileLoaded(profile));
      } else {
        emit(ProfileError("No profile found."));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      await updateProfile(event.profile);
      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}