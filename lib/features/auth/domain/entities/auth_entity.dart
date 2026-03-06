class AuthEntity {
  final String? accessToken;
  final String? refreshToken;
  final String? message;
  final bool status;

  AuthEntity({
    this.accessToken,
    this.refreshToken,
    this.message,
    required this.status,
  });
}
