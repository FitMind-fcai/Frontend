import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<void> cacheToken(String token);
  Future<UserModel?> getCachedUser();
  Future<String?> getCachedToken();
  Future<bool> isLoggedIn();
  Future<void> deleteCachedData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String keyUserData = "USER_DATA";
  static const String keyToken = "USER_TOKEN";

  @override
  Future<void> cacheUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserData, jsonEncode(user.toJson()));
  }

  @override
  Future<void> cacheToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyToken, token);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(keyUserData);
    if (jsonString == null) return null;
    return UserModel.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<String?> getCachedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyToken);
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(keyToken);
  }
  Future<void>deleteCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUserData);
    await prefs.remove(keyToken);
  }
}
