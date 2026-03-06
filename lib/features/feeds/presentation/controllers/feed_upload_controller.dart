import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:novindus_test/features/feeds/domain/usecases/feeds_usecases.dart';
import 'package:novindus_test/core/utils/token_storage.dart';
import 'package:video_player/video_player.dart';

class FeedUploadController extends ChangeNotifier {
  final UploadFeedUseCase uploadUseCase;
  final ImagePicker _picker = ImagePicker();

  FeedUploadController({required this.uploadUseCase});

  bool _isUploading = false;
  double _uploadProgress = 0;
  String? _videoPath;
  String? _imagePath;
  List<dynamic> _selectedCategoryIds = [];
  String? _errorMessage;
  bool _success = false;

  bool get isUploading => _isUploading;
  double get uploadProgress => _uploadProgress;
  String? get videoPath => _videoPath;
  String? get imagePath => _imagePath;
  List<dynamic> get selectedCategoryIds => _selectedCategoryIds;
  String? get errorMessage => _errorMessage;
  bool get success => _success;

  Future<void> pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      if (!video.path.toLowerCase().endsWith('.mp4')) {
        _errorMessage = "Please select an MP4 video.";
        notifyListeners();
        return;
      }

      final controller = VideoPlayerController.file(File(video.path));
      await controller.initialize();
      if (controller.value.duration.inMinutes > 5) {
        _errorMessage = "Video must be under 5 minutes.";
        controller.dispose();
        notifyListeners();
        return;
      }
      controller.dispose();

      _videoPath = video.path;
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<void> pickThumbnail() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imagePath = image.path;
      _errorMessage = null;
      notifyListeners();
    }
  }

  void toggleCategory(dynamic categoryId) {
    if (_selectedCategoryIds.contains(categoryId)) {
      _selectedCategoryIds.remove(categoryId);
    } else {
      _selectedCategoryIds.add(categoryId);
    }
    notifyListeners();
  }

  Future<void> upload(String description) async {
    if (_videoPath == null) {
      _errorMessage = "Please select a video.";
      notifyListeners();
      return;
    }
    if (_imagePath == null) {
      _errorMessage = "Please add a thumbnail.";
      notifyListeners();
      return;
    }
    if (description.isEmpty) {
      _errorMessage = "Description is mandatory.";
      notifyListeners();
      return;
    }
    if (_selectedCategoryIds.isEmpty) {
      _errorMessage = "Select at least one category.";
      notifyListeners();
      return;
    }

    _isUploading = true;
    _uploadProgress = 0;
    _errorMessage = null;
    _success = false;
    notifyListeners();

    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) throw Exception("User not logged in.");

      final ok = await uploadUseCase(
        UploadFeedParams(
          accessToken: token,
          videoPath: _videoPath!,
          imagePath: _imagePath!,
          description: description,
          categoryIds: _selectedCategoryIds,
          onProgress: (p) {
            _uploadProgress = p;
            notifyListeners();
          },
        ),
      );

      if (ok) {
        _isUploading = false;
        _success = true;
        notifyListeners();
      } else {
        _isUploading = false;
        _errorMessage = "Upload failed.";
        notifyListeners();
      }
    } catch (e) {
      _isUploading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void reset() {
    _isUploading = false;
    _uploadProgress = 0;
    _videoPath = null;
    _imagePath = null;
    _selectedCategoryIds = [];
    _errorMessage = null;
    _success = false;
    notifyListeners();
  }

  void resetError() {
    _errorMessage = null;
    notifyListeners();
  }
}
