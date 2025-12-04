import '../../data/models/profile_body.dart';
import '../repositories/profile_repository.dart';

class CreateProfileUseCase {
  final ProfileRepository repository;

  CreateProfileUseCase(this.repository);

  Future<void> call(ProfileBody profile) {
    return repository.createProfile(profile);
  }
}