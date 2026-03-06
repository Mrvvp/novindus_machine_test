import 'package:dio/dio.dart';

class AppError implements Exception {
  final String message;
  final int? statusCode;

  AppError(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ErrorHandler {
  static AppError handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return AppError('Connection timeout. Please check your internet.');
        case DioExceptionType.sendTimeout:
          return AppError('Send timeout. Try again later.');
        case DioExceptionType.receiveTimeout:
          return AppError('Receive timeout. The server is taking too long.');
        case DioExceptionType.badResponse:
          final status = error.response?.statusCode;
          final data = error.response?.data;
          String msg = 'Unexpected error occurred ($status)';
          if (data is Map && data.containsKey('message')) {
            msg = data['message'];
          }
          return AppError(msg, statusCode: status);
        case DioExceptionType.cancel:
          return AppError('Request was cancelled.');
        case DioExceptionType.connectionError:
          return AppError('No internet connection.');
        default:
          return AppError('Something went wrong. Please try again.');
      }
    } else if (error is AppError) {
      return error;
    } else {
      return AppError('An unexpected error occurred: ${error.toString()}');
    }
  }
}
