import 'package:flutter/material.dart';
import 'package:novindus_test/features/home/domain/entities/home_entity.dart';
import 'package:novindus_test/features/home/domain/usecases/home_usecases.dart';
import 'package:novindus_test/core/utils/token_storage.dart';

class HomeController extends ChangeNotifier {
  final GetHomeDataUseCase getHomeDataUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  HomeController({
    required this.getHomeDataUseCase,
    required this.getCategoriesUseCase,
  });

  bool _isLoading = true;
  String? _errorMessage;
  List<CategoryEntity> _categories = [];
  List<CategoryEntity> _categoryDict = [];
  List<FeedEntity> _feeds = [];
  dynamic _playingFeedId;
  dynamic _selectedCategoryId;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CategoryEntity> get categories => _categories;
  List<CategoryEntity> get categoryDict => _categoryDict;
  List<FeedEntity> get feeds => _feeds;
  dynamic get playingFeedId => _playingFeedId;
  dynamic get selectedCategoryId => _selectedCategoryId;

  Future<void> fetchInitialData() async {
    _isLoading = true;
    _errorMessage = null;
    _playingFeedId = null;
    notifyListeners();

    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        throw Exception("Authentication token not found. Please log in again.");
      }

      final mainCategoriesList = await getCategoriesUseCase(token);
      final homeData = await getHomeDataUseCase(token);

      _isLoading = false;
      _categories = mainCategoriesList;
      _categoryDict = homeData.categoryDict;
      _feeds = homeData.feeds;

      if (_categoryDict.isNotEmpty) {
        _selectedCategoryId = _categoryDict.first.id;
      } else {
        _selectedCategoryId = null;
      }
      notifyListeners();
    } catch (e, stack) {
      debugPrint("Error in HomeController: $e");
      debugPrint(stack.toString());
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void selectCategory(dynamic categoryId) {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    _playingFeedId = null;
    notifyListeners();
  }

  void setPlayingFeed(dynamic feedId) {
    if (_playingFeedId == feedId) {
      _playingFeedId = null;
    } else {
      _playingFeedId = feedId;
    }
    notifyListeners();
  }

  void resetError() {
    _errorMessage = null;
    notifyListeners();
  }
}
