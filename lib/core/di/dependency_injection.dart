import 'package:dio/dio.dart';
import 'package:novindus_test/api_config/api_endpoints.dart';
import 'package:novindus_test/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:novindus_test/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:novindus_test/features/auth/domain/repositories/auth_repository.dart';
import 'package:novindus_test/features/auth/domain/usecases/login_usecase.dart';
import 'package:novindus_test/features/home/data/datasources/home_remote_data_source.dart';
import 'package:novindus_test/features/home/data/repositories/home_repository_impl.dart';
import 'package:novindus_test/features/home/domain/repositories/home_repository.dart';
import 'package:novindus_test/features/home/domain/usecases/home_usecases.dart';

class DependencyInjection {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  static late final AuthRemoteDataSource authRemoteDataSource;
  static late final AuthRepository authRepository;
  static late final LoginUseCase loginUseCase;

  static late final HomeRemoteDataSource homeRemoteDataSource;
  static late final HomeRepository homeRepository;
  static late final GetHomeDataUseCase getHomeDataUseCase;
  static late final GetCategoriesUseCase getCategoriesUseCase;

  static void init() {
    authRemoteDataSource = AuthRemoteDataSourceImpl(dio);
    authRepository = AuthRepositoryImpl(authRemoteDataSource);
    loginUseCase = LoginUseCase(authRepository);

    homeRemoteDataSource = HomeRemoteDataSourceImpl(dio);
    homeRepository = HomeRepositoryImpl(homeRemoteDataSource);
    getHomeDataUseCase = GetHomeDataUseCase(homeRepository);
    getCategoriesUseCase = GetCategoriesUseCase(homeRepository);
  }
}
