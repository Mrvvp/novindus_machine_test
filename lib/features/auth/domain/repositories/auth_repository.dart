import 'package:novindus_test/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login({
    required String countryCode,
    required String phoneNumber,
  });
}
