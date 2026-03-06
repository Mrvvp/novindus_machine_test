import 'package:novindus_test/features/feeds/domain/entities/feeds_entity.dart';
import 'package:novindus_test/features/feeds/domain/repositories/feeds_repository.dart';
import 'package:novindus_test/features/feeds/data/datasources/feeds_remote_data_source.dart';
import 'package:novindus_test/core/error/failures.dart';
import 'package:novindus_test/core/utils/error_handler.dart';

class FeedsRepositoryImpl implements FeedsRepository {
  final FeedsRemoteDataSource remoteDataSource;

  FeedsRepositoryImpl(this.remoteDataSource);

  @override
  Future<MyFeedResponseEntity?> getMyFeeds({
    required String accessToken,
    int page = 1,
  }) async {
    try {
      return await remoteDataSource.getMyFeeds(accessToken: accessToken, page: page);
    } catch (e) {
       final error = ErrorHandler.handle(e);
      throw ServerFailure(error.message);
    }
  }

  @override
  Future<bool> uploadFeed({
    required String accessToken,
    required String videoPath,
    required String imagePath,
    required String description,
    required List<dynamic> categoryIds,
    void Function(double)? onProgress,
  }) async {
    try {
      return await remoteDataSource.uploadFeed(
        accessToken: accessToken,
        videoPath: videoPath,
        imagePath: imagePath,
        description: description,
        categoryIds: categoryIds,
        onProgress: onProgress,
      );
    } catch (e) {
       final error = ErrorHandler.handle(e);
      throw ServerFailure(error.message);
    }
  }
}
