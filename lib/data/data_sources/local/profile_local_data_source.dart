import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/profile_body.dart';

abstract class ProfileLocalDataSource {
  Future<void> cacheProfile(ProfileBody profile);
  Future<ProfileBody?> getCachedProfile();
  Future<void> deleteProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const String keyProfile = "USER_PROFILE";

  @override
  Future<void> cacheProfile(ProfileBody profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyProfile, jsonEncode(profile.toJson()));
  }

  @override
  Future<ProfileBody?> getCachedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(keyProfile);
    if (jsonString == null) return null;
    return ProfileBody.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<void> deleteProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyProfile);
  }
}