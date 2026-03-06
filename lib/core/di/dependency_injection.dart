import 'package:dio/dio.dart';
import 'package:novindus_test/api_config/api_endpoints.dart';
import 'package:novindus_test/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:novindus_test/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:novindus_test/features/auth/domain/repositories/auth_repository.dart';
import 'package:novindus_test/features/auth/domain/usecases/login_usecase.dart';

class DependencyInjection {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // Auth
  static late final AuthRemoteDataSource authRemoteDataSource;
  static late final AuthRepository authRepository;
  static late final LoginUseCase loginUseCase;

  static void init() {
    // Auth
    authRemoteDataSource = AuthRemoteDataSourceImpl(dio);
    authRepository = AuthRepositoryImpl(authRemoteDataSource);
    loginUseCase = LoginUseCase(authRepository);
  }
}
