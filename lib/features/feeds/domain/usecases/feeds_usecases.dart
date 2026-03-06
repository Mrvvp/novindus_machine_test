import 'package:novindus_test/core/usecase/usecases.dart';
import 'package:novindus_test/features/feeds/domain/entities/feeds_entity.dart';
import 'package:novindus_test/features/feeds/domain/repositories/feeds_repository.dart';

class GetMyFeedsUseCase implements UseCase<MyFeedResponseEntity?, GetMyFeedsParams> {
  final FeedsRepository repository;

  GetMyFeedsUseCase(this.repository);

  @override
  Future<MyFeedResponseEntity?> call(GetMyFeedsParams params) async {
    return await repository.getMyFeeds(accessToken: params.accessToken, page: params.page);
  }
}

class GetMyFeedsParams {
  final String accessToken;
  final int page;
  GetMyFeedsParams({required this.accessToken, this.page = 1});
}

class UploadFeedUseCase implements UseCase<bool, UploadFeedParams> {
  final FeedsRepository repository;

  UploadFeedUseCase(this.repository);

  @override
  Future<bool> call(UploadFeedParams params) async {
    return await repository.uploadFeed(
      accessToken: params.accessToken,
      videoPath: params.videoPath,
      imagePath: params.imagePath,
      description: params.description,
      categoryIds: params.categoryIds,
      onProgress: params.onProgress,
    );
  }
}

class UploadFeedParams {
  final String accessToken;
  final String videoPath;
  final String imagePath;
  final String description;
  final List<dynamic> categoryIds;
  final void Function(double)? onProgress;

  UploadFeedParams({
    required this.accessToken,
    required this.videoPath,
    required this.imagePath,
    required this.description,
    required this.categoryIds,
    this.onProgress,
  });
}
