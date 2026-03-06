import 'package:flutter/material.dart';
import 'package:novindus_test/features/feeds/domain/usecases/feeds_usecases.dart';
import 'package:novindus_test/features/home/domain/entities/home_entity.dart';
import 'package:novindus_test/core/utils/token_storage.dart';

class MyFeedsController extends ChangeNotifier {
  final GetMyFeedsUseCase getMyFeedsUseCase;

  MyFeedsController({required this.getMyFeedsUseCase});

  List<FeedEntity> _feeds = [];
  bool _isLoading = false;
  bool _isPaginationLoading = false;
  String? _errorMessage;
  bool _hasMore = true;
  int _currentPage = 1;
  int? _playingFeedId;

  List<FeedEntity> get feeds => _feeds;
  bool get isLoading => _isLoading;
  bool get isPaginationLoading => _isPaginationLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  int? get playingFeedId => _playingFeedId;

  Future<void> fetchMyFeeds({bool isRefresh = false}) async {
    if (isRefresh) {
      _isLoading = true;
      _currentPage = 1;
      _feeds = [];
      _hasMore = true;
      _errorMessage = null;
      notifyListeners();
    } else {
      if (!_hasMore || _isLoading || _isPaginationLoading) return;
      
      _errorMessage = null;
      if (_currentPage == 1) {
        _isLoading = true;
      } else {
        _isPaginationLoading = true;
      }
      notifyListeners();
    }

    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        _isLoading = false;
        _isPaginationLoading = false;
        _errorMessage = "Not authenticated";
        notifyListeners();
        return;
      }

      final response = await getMyFeedsUseCase(
        GetMyFeedsParams(accessToken: token, page: _currentPage),
      );

      if (response != null) {
        if (isRefresh) {
          _feeds = response.results;
        } else {
          _feeds = [..._feeds, ...response.results];
        }
        _isLoading = false;
        _isPaginationLoading = false;
        _hasMore = response.next != null;
        _currentPage++;
        notifyListeners();
      } else {
        _isLoading = false;
        _isPaginationLoading = false;
        _hasMore = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _isPaginationLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void setPlayingFeed(int? id) {
    _playingFeedId = id;
    notifyListeners();
  }

  void resetError() {
    _errorMessage = null;
    notifyListeners();
  }
}
