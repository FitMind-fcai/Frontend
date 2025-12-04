import '../../data/models/profile_body.dart';

abstract class ProfileRepository {
  Future<void> createProfile(ProfileBody profile);
}