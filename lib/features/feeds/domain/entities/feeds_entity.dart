import 'package:novindus_test/features/home/domain/entities/home_entity.dart';

class MyFeedResponseEntity {
  final int count;
  final String? next;
  final String? previous;
  final List<FeedEntity> results;

  MyFeedResponseEntity({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });
}
