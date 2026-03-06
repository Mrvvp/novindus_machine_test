import 'package:novindus_test/features/feeds/domain/entities/feeds_entity.dart';

abstract class FeedsRepository {
  Future<MyFeedResponseEntity?> getMyFeeds({
    required String accessToken,
    int page = 1,
  });

  Future<bool> uploadFeed({
    required String accessToken,
    required String videoPath,
    required String imagePath,
    required String description,
    required List<dynamic> categoryIds,
    void Function(double)? onProgress,
  });
}
