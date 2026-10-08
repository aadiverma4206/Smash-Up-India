import 'dart:io';
import 'package:dio/dio.dart';
import 'app_exception.dart';

class ErrorMapper {
  static AppException mapDioError(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return NetworkException(
        'Connection timed out. Please check your internet connection and try again.',
        code: 'TIMEOUT',
      );
    }

    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.badCertificate) {
      return NetworkException(
        'No internet connection. Please check your Wi-Fi or mobile data.',
        code: 'NO_INTERNET',
      );
    }

    if (err.type == DioExceptionType.cancel) {
      return NetworkException(
        'Request was cancelled.',
        code: 'CANCELLED',
      );
    }

    // Check inner SocketException or network drops
    if (err.error is SocketException ||
        err.error.toString().contains('SocketException')) {
      return NetworkException(
        'No internet connection. Please connect to Wi-Fi or mobile data.',
        code: 'NO_INTERNET',
      );
    }

    final response = err.response;
    if (response != null) {
      final statusCode = response.statusCode;
      final data = response.data;

      String message = 'An unexpected server error occurred';
      String code = 'UNKNOWN_ERROR';
      dynamic details;

      if (data is Map<String, dynamic>) {
        if (data['message'] != null &&
            data['message'].toString().trim().isNotEmpty) {
          message = data['message'].toString();
        }

        if (data['error'] is Map<String, dynamic>) {
          final errObj = data['error'] as Map<String, dynamic>;
          code = errObj['code']?.toString() ?? code;
          details = errObj['details'];

          // Extract detailed validation messages if available
          if (details is List && details.isNotEmpty) {
            final fieldMessages = <String>[];
            for (final item in details) {
              if (item is Map<String, dynamic> && item['message'] != null) {
                fieldMessages.add(item['message'].toString());
              } else if (item is String) {
                fieldMessages.add(item);
              }
            }
            if (fieldMessages.isNotEmpty) {
              message = fieldMessages.join(', ');
            }
          } else if (errObj['message'] != null &&
              errObj['message'].toString().trim().isNotEmpty) {
            message = errObj['message'].toString();
          }
        } else if (data['error'] is String &&
            data['error'].toString().trim().isNotEmpty) {
          message = data['error'].toString();
        }
      } else if (data is String && data.isNotEmpty) {
        if (data.contains('500') ||
            data.contains('Internal Server Error') ||
            data.contains('Bad Gateway') ||
            data.contains('502') ||
            data.contains('503') ||
            data.contains('<html>')) {
          message =
              'Internal server error. Our servers are experiencing issues. Please try again later.';
        }
      }

      // Backend Specific Error Codes Override
      if (code == 'ACCOUNT_SUSPENDED') {
        return AuthException(
          'Your account has been suspended by administration. Please contact support.',
          code: 'ACCOUNT_SUSPENDED',
          details: details,
        );
      }

      if (code == 'RATE_LIMIT_EXCEEDED' || statusCode == 429) {
        return NetworkException(
          'Too many requests. Please slow down and try again after a moment.',
          code: 'RATE_LIMIT',
          details: details,
        );
      }

      if (code == 'DUPLICATE_ENTRY') {
        return ValidationException(
          message,
          code: 'DUPLICATE_ENTRY',
          details: details,
        );
      }

      if (code == 'FILE_TOO_LARGE' ||
          code == 'PAYLOAD_TOO_LARGE' ||
          statusCode == 413) {
        return ValidationException(
          'File size exceeds the maximum permitted upload limit.',
          code: 'PAYLOAD_TOO_LARGE',
          details: details,
        );
      }

      switch (statusCode) {
        case 400:
          return ValidationException(
            message != 'An unexpected server error occurred'
                ? message
                : 'Bad request. Please check your input and try again.',
            code: code,
            details: details,
          );
        case 401:
          return AuthException(
            message != 'An unexpected server error occurred'
                ? message
                : 'Session expired. Please log in again.',
            code: 'UNAUTHORIZED',
            details: details,
          );
        case 403:
          return AuthException(
            message != 'An unexpected server error occurred'
                ? message
                : 'Access denied. You do not have permission to perform this action.',
            code: 'FORBIDDEN',
            details: details,
          );
        case 404:
          return AppException(
            message != 'An unexpected server error occurred'
                ? message
                : 'Requested resource not found.',
            code: 'NOT_FOUND',
            details: details,
          );
        case 409:
          return AppException(
            message != 'An unexpected server error occurred'
                ? message
                : 'Conflict occurred. Please try again.',
            code: 'CONFLICT',
            details: details,
          );
        case 422:
          return ValidationException(
            message != 'An unexpected server error occurred'
                ? message
                : 'Validation failed. Please verify your details.',
            code: 'UNPROCESSABLE_ENTITY',
            details: details,
          );
        case 500:
        case 502:
        case 503:
        case 504:
          return ServerException(
            'Internal server error. Our servers are experiencing issues. Please try again later.',
            code: 'SERVER_ERROR',
            details: details,
          );
        default:
          if (statusCode != null && statusCode >= 500) {
            return ServerException(
              'Internal server error. Our servers are experiencing issues. Please try again later.',
              code: 'SERVER_ERROR',
              details: details,
            );
          }
          return AppException(message, code: code, details: details);
      }
    }

    if (err.error is AppException) {
      return err.error as AppException;
    }

    return NetworkException(
      'No internet connection. Please check your network connection and try again.',
      code: 'NO_INTERNET',
    );
  }
}
