import 'package:flutter/material.dart';
import 'package:novindus_test/features/auth/domain/entities/auth_entity.dart';
import 'package:novindus_test/features/auth/domain/usecases/login_usecase.dart';
import 'package:novindus_test/core/utils/token_storage.dart';

class AuthController extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  AuthController({required this.loginUseCase});

  bool _isLoading = false;
  String? _errorMessage;
  AuthEntity? _authData;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthEntity? get authData => _authData;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String phoneNumber, {String countryCode = '+91'}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final authEntity = await loginUseCase(
        LoginParams(countryCode: countryCode, phoneNumber: phoneNumber),
      );

      if (authEntity.status == true && authEntity.accessToken != null) {
        await TokenStorage.saveTokens(
          access: authEntity.accessToken!,
          refresh: authEntity.refreshToken ?? '',
        );

        _authData = authEntity;
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = authEntity.message ?? "Authentication failed";
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void resetError() {
    _errorMessage = null;
    notifyListeners();
  }
}
