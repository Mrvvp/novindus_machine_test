import 'package:dio/dio.dart';
import 'package:novindus_test/api_config/api_endpoints.dart';
import 'package:novindus_test/features/auth/data/models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({
    required String countryCode,
    required String phoneNumber,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthModel> login({
    required String countryCode,
    required String phoneNumber,
  }) async {
    final formData = FormData.fromMap({
      'country_code': countryCode,
      'phone': phoneNumber,
    });

    final response = await _dio.post(ApiEndpoints.login, data: formData);

    if (response.data != null) {
      return AuthModel.fromJson(response.data);
    }
    throw Exception('Empty response from server');
  }
}
