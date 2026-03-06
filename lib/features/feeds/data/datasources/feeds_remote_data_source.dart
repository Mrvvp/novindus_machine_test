import 'package:dio/dio.dart';
import 'package:novindus_test/api_config/api_endpoints.dart';
import 'package:novindus_test/features/feeds/data/models/feeds_model.dart';
import 'package:novindus_test/features/home/data/models/home_model.dart';

abstract class FeedsRemoteDataSource {
  Future<MyFeedResponseModel?> getMyFeeds({
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

class FeedsRemoteDataSourceImpl implements FeedsRemoteDataSource {
  final Dio _dio;
  FeedsRemoteDataSourceImpl(this._dio);

  @override
  Future<MyFeedResponseModel?> getMyFeeds({
    required String accessToken,
    int page = 1,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.myFeed,
      queryParameters: {'page': page},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    if (response.data != null) {
      if (response.data is List) {
        return MyFeedResponseModel(
          count: (response.data as List).length,
          results: (response.data as List)
              .map((e) => FeedModel.fromJson(e))
              .toList(),
        );
      } else if (response.data is Map) {
        return MyFeedResponseModel.fromJson(response.data);
      }
    }
    return null;
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
    FormData formData = FormData.fromMap({
      "video": await MultipartFile.fromFile(videoPath),
      "image": await MultipartFile.fromFile(imagePath),
      "desc": description,
      "catogory": categoryIds.length == 1
          ? categoryIds.first
          : categoryIds.toString(),
    });

    final response = await _dio.post(
      ApiEndpoints.myFeed,
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      onSendProgress: (sent, total) {
        if (onProgress != null && total != -1) {
          onProgress(sent / total);
        }
      },
    );

    return response.data["status"] == true;
  }
}
