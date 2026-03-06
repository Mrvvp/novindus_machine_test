import 'package:novindus_test/core/usecase/usecases.dart';
import 'package:novindus_test/features/home/domain/entities/home_entity.dart';
import 'package:novindus_test/features/home/domain/repositories/home_repository.dart';

class GetHomeDataUseCase implements UseCase<HomeEntity, String?> {
  final HomeRepository repository;

  GetHomeDataUseCase(this.repository);

  @override
  Future<HomeEntity> call(String? accessToken) async {
    return await repository.getHomeData(accessToken: accessToken);
  }
}

class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, String?> {
  final HomeRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<List<CategoryEntity>> call(String? accessToken) async {
    return await repository.getCategories(accessToken: accessToken);
  }
}
