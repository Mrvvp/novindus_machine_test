import 'package:novindus_test/core/usecase/usecases.dart';
import 'package:novindus_test/features/auth/domain/entities/auth_entity.dart';
import 'package:novindus_test/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<AuthEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<AuthEntity> call(LoginParams params) async {
    return await repository.login(
      countryCode: params.countryCode,
      phoneNumber: params.phoneNumber,
    );
  }
}

class LoginParams {
  final String countryCode;
  final String phoneNumber;

  LoginParams({required this.countryCode, required this.phoneNumber});
}
