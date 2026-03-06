import 'package:novindus_test/features/home/domain/entities/home_entity.dart';
import 'package:novindus_test/features/home/domain/repositories/home_repository.dart';
import 'package:novindus_test/features/home/data/datasources/home_remote_data_source.dart';
import 'package:novindus_test/core/error/failures.dart';
import 'package:novindus_test/core/utils/error_handler.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CategoryEntity>> getCategories({String? accessToken}) async {
    try {
      return await remoteDataSource.getCategories(accessToken: accessToken);
    } catch (e) {
      final error = ErrorHandler.handle(e);
      throw ServerFailure(error.message);
    }
  }

  @override
  Future<HomeEntity> getHomeData({String? accessToken}) async {
    try {
      return await remoteDataSource.getHomeData(accessToken: accessToken);
    } catch (e) {
       final error = ErrorHandler.handle(e);
      throw ServerFailure(error.message);
    }
  }
}
