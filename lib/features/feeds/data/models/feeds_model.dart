import 'package:novindus_test/features/feeds/domain/entities/feeds_entity.dart';
import 'package:novindus_test/features/home/data/models/home_model.dart';

class MyFeedResponseModel extends MyFeedResponseEntity {
  MyFeedResponseModel({
    required super.count,
    super.next,
    super.previous,
    required super.results,
  });

  factory MyFeedResponseModel.fromJson(dynamic json) {
    if (json is! Map) {
      return MyFeedResponseModel(count: 0, results: []);
    }
    return MyFeedResponseModel(
      count: json['count'] ?? 0,
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
      results: (json['results'] as List? ?? [])
          .map((e) => FeedModel.fromJson(e))
          .toList(),
    );
  }
}
