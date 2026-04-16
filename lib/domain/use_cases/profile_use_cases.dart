import '../../data/models/profile_body.dart';
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