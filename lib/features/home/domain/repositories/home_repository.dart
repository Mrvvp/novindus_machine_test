import 'package:novindus_test/features/home/domain/entities/home_entity.dart';

abstract class HomeRepository {
  Future<List<CategoryEntity>> getCategories({String? accessToken});
  Future<HomeEntity> getHomeData({String? accessToken});
}
