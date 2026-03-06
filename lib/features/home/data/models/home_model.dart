import 'package:novindus_test/api_config/api_endpoints.dart';
import 'package:novindus_test/features/home/domain/entities/home_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({required super.id, required super.name, required super.image});

  factory CategoryModel.fromJson(dynamic json) {
    if (json is! Map) return CategoryModel(id: 0, name: '', image: '');
    String imageUrl = json['image']?.toString() ?? '';
    if (imageUrl.startsWith('/')) {
      imageUrl = ApiEndpoints.mediaBaseUrl + imageUrl;
    }
    return CategoryModel(
      id: json['id'],
      name: (json['title'] ?? json['name'])?.toString() ?? '',
      image: imageUrl,
    );
  }
}

class UserModel extends UserEntity {
  UserModel({required super.id, required super.name, super.profilePicture});

  factory UserModel.fromJson(dynamic json) {
    if (json is! Map) return UserModel(id: 0, name: 'User');
    String? imageUrl = json['image']?.toString();
    if (imageUrl != null && imageUrl.startsWith('/')) {
      imageUrl = ApiEndpoints.mediaBaseUrl + imageUrl;
    }
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? 'User',
      profilePicture: imageUrl,
    );
  }
}

class FeedModel extends FeedEntity {
  FeedModel({
    required super.id,
    required super.description,
    required super.videoUrl,
    required super.thumbnailUrl,
    required super.user,
    required super.createdAt,
  });

  factory FeedModel.fromJson(dynamic json) {
    if (json is! Map) {
      return FeedModel(
        id: 0,
        description: '',
        videoUrl: '',
        thumbnailUrl: '',
        user: UserModel(id: 0, name: ''),
        createdAt: '',
      );
    }
    String imageUrl = json['image']?.toString() ?? '';
    if (imageUrl.startsWith('/')) {
      imageUrl = ApiEndpoints.mediaBaseUrl + imageUrl;
    }
    return FeedModel(
      id: json['id'] ?? 0,
      description: (json['description'] ?? json['desc'])?.toString() ?? '',
      videoUrl: json['video']?.toString() ?? '',
      thumbnailUrl: imageUrl,
      user: UserModel.fromJson(json['user']),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

class HomeModel extends HomeEntity {
  HomeModel({super.currentUser, required super.categoryDict, required super.feeds});

  factory HomeModel.fromJson(dynamic json) {
    if (json is! Map) {
      return HomeModel(categoryDict: [], feeds: []);
    }
    return HomeModel(
      currentUser: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      categoryDict: (json['category_dict'] as List? ?? json['categories'] as List? ?? [])
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
      feeds: (json['results'] as List? ?? json['feeds'] as List? ?? [])
          .map((e) => FeedModel.fromJson(e))
          .toList(),
    );
  }
}
