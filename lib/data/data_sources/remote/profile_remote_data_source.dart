import 'package:dio/dio.dart';

import '../../../network/profile_api_service.dart';
import '../../models/profile_body.dart';

abstract class ProfileRemoteDataSource {
  Future<void> createProfile(ProfileBody body);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApiService apiService;

  ProfileRemoteDataSourceImpl(this.apiService);

  String _extractError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;

      try {
        if (data is String) {
          return data;
        }

        if (data is Map<String, dynamic>) {
          if (data.containsKey('detail')) {
            return data['detail'].toString();
          }
          if (data.containsKey('message')) {
            return data['message'].toString();
          }

          // fallback: collect all values
          return data.values.join(', ');
        }
      } catch (_) {}

      return e.response!.statusMessage ?? "Unknown server error";
    }

    return e.message ?? "Network error occurred";
  }

  @override
  Future<void> createProfile(ProfileBody body) async {
    try {
      await apiService.createProfile(body);
    } on DioException catch (e) {
      throw Exception(_extractError(e)); // ✅ clean error message
    } catch (e) {
      throw Exception("Unexpected error occurred");
    }
  }
}
