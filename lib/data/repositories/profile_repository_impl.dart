import '../../domain/repositories/profile_repository.dart';
import '../data_sources/remote/profile_remote_data_source.dart';
import '../models/profile_body.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<void> createProfile(ProfileBody profile) {
    return remote.createProfile(profile);
  }
  @override
  Future<ProfileBody?> getMyProfile() {
    return remote.getMyProfile();
  }

  @override
  Future<ProfileBody> updateMyProfile(ProfileBody profile) => // NEW
  remote.updateMyProfile(profile);
}