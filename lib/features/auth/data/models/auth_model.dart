import 'package:novindus_test/features/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    super.accessToken,
    super.refreshToken,
    super.message,
    required super.status,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    var tokenData = json['token'] as Map<String, dynamic>?;
    return AuthModel(
      accessToken: tokenData != null ? tokenData['access'] : null,
      refreshToken: tokenData != null ? tokenData['refresh'] : null,
      message: json['message']?.toString(),
      status: json['status'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': {
        'access': accessToken,
        'refresh': refreshToken,
      },
      'message': message,
      'status': status,
    };
  }
}
