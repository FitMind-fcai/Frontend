import '../../data/models/profile_body.dart';
import '../../network/profile_api_service.dart';
import '../repositories/profile_repository.dart';

class CreateProfileUseCase {
  final ProfileRepository repository;

  CreateProfileUseCase(this.repository);

  Future<void> call(ProfileBody profile) {
    return repository.createProfile(profile);
  }
}
class GetMyProfileUseCase {
  final ProfileRepository repository;
  GetMyProfileUseCase(this.repository);

  Future<ProfileBody?> call() => repository.getMyProfile(); // no token needed
}

class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);

  Future<ProfileBody> call(ProfileBody profile) =>
      repository.updateMyProfile(profile);
}