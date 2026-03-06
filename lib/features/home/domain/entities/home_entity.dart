class CategoryEntity {
  final dynamic id;
  final String name;
  final String image;

  CategoryEntity({required this.id, required this.name, required this.image});
}

class UserEntity {
  final int id;
  final String name;
  final String? profilePicture;

  UserEntity({required this.id, required this.name, this.profilePicture});
}

class FeedEntity {
  final int id;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final UserEntity user;
  final String createdAt;

  FeedEntity({
    required this.id,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.user,
    required this.createdAt,
  });
}

class HomeEntity {
  final UserEntity? currentUser;
  final List<CategoryEntity> categoryDict;
  final List<FeedEntity> feeds;

  HomeEntity({this.currentUser, required this.categoryDict, required this.feeds});
}
