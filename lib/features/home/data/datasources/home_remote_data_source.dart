import 'package:dio/dio.dart';
import 'package:novindus_test/api_config/api_endpoints.dart';
import 'package:novindus_test/features/home/data/models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories({String? accessToken});
  Future<HomeModel> getHomeData({String? accessToken});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;

  HomeRemoteDataSourceImpl(this._dio);

  @override
  Future<List<CategoryModel>> getCategories({String? accessToken}) async {
    final response = await _dio.get(
      ApiEndpoints.categoryList,
      options: accessToken != null
          ? Options(headers: {'Authorization': 'Bearer $accessToken'})
          : null,
    );
    if (response.data != null) {
      if (response.data is List) {
        return (response.data as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      } else if (response.data is Map) {
        final List? categoryData =
            response.data['categories'] ?? response.data['category_dict'];
        if (categoryData != null) {
          return categoryData
              .map((json) => CategoryModel.fromJson(json))
              .toList();
        }
      }
    }
    return [];
  }

  @override
  Future<HomeModel> getHomeData({String? accessToken}) async {
    final response = await _dio.get(
      ApiEndpoints.home,
      options: accessToken != null
          ? Options(headers: {'Authorization': 'Bearer $accessToken'})
          : null,
    );
    if (response.data != null) {
      if (response.data is List) {
        return HomeModel(
          categoryDict: [],
          feeds: (response.data as List)
              .map((e) => FeedModel.fromJson(e))
              .toList(),
        );
      } else if (response.data is Map) {
        return HomeModel.fromJson(response.data);
      }
    }
    throw Exception('Empty response from server');
  }
}
