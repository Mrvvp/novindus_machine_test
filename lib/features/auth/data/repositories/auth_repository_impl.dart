import 'package:novindus_test/features/auth/domain/entities/auth_entity.dart';
import 'package:novindus_test/features/auth/domain/repositories/auth_repository.dart';
import 'package:novindus_test/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:novindus_test/core/error/failures.dart';
import 'package:novindus_test/core/utils/error_handler.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AuthEntity> login({
    required String countryCode,
    required String phoneNumber,
  }) async {
    try {
      return await remoteDataSource.login(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
      );
    } catch (e) {
      final error = ErrorHandler.handle(e);
      throw ServerFailure(error.message);
    }
  }
}
