import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  @override
  Future<void> cacheUser(UserModel user) async {
    await _storage.write(key: keyUserData, value: jsonEncode(user.toJson()));
  }

  @override
  Future<void> cacheToken(String token) async {
    await _storage.write(key: keyToken, value: token);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = await _storage.read(key: keyUserData);
    if (jsonString == null) return null;
    return UserModel.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<String?> getCachedToken() async {
    return await _storage.read(key: keyToken);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: keyToken);
    return token != null;
  }

  @override
  Future<void> deleteCachedData() async {
    await _storage.delete(key: keyUserData);
    await _storage.delete(key: keyToken);
  }
}