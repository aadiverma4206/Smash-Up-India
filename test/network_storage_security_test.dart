import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:all_stars_arena/core/errors/error_mapper.dart';
import 'package:all_stars_arena/core/errors/app_exception.dart';
import 'package:all_stars_arena/core/security/encryption_service.dart';

void main() {
  group('Network & Error Mapping Tests', () {
    test('ErrorMapper maps Dio 401 response to AuthException', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/v1/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/v1/test'),
          statusCode: 401,
          data: {
            'success': false,
            'message': 'Invalid token',
            'error': {'code': 'UNAUTHORIZED'}
          },
        ),
      );

      final exception = ErrorMapper.mapDioError(dioException);
      expect(exception, isA<AuthException>());
      expect(exception.message, 'Invalid token');
      expect(exception.code, 'UNAUTHORIZED');
    });

    test('ErrorMapper maps Dio connection error to NetworkException (Offline)',
        () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/v1/test'),
        type: DioExceptionType.connectionError,
      );

      final exception = ErrorMapper.mapDioError(dioException);
      expect(exception, isA<NetworkException>());
      expect(exception.code, 'NO_INTERNET');
    });

    test(
        'ErrorMapper extracts field error details from Zod/Joi validation response',
        () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/v1/auth/login'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/v1/auth/login'),
          statusCode: 400,
          data: {
            'success': false,
            'message': 'Validation Error',
            'error': {
              'code': 'VALIDATION_ERROR',
              'details': [
                {'field': 'body.email', 'message': 'Invalid email format'},
                {'field': 'body.password', 'message': 'Password required'}
              ]
            }
          },
        ),
      );

      final exception = ErrorMapper.mapDioError(dioException);
      expect(exception, isA<ValidationException>());
      expect(exception.message, 'Invalid email format, Password required');
    });

    test('ErrorMapper maps ACCOUNT_SUSPENDED code correctly', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/v1/auth/login'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/v1/auth/login'),
          statusCode: 403,
          data: {
            'success': false,
            'message': 'Account is suspended',
            'error': {'code': 'ACCOUNT_SUSPENDED'}
          },
        ),
      );

      final exception = ErrorMapper.mapDioError(dioException);
      expect(exception, isA<AuthException>());
      expect(exception.code, 'ACCOUNT_SUSPENDED');
      expect(exception.message, contains('suspended'));
    });

    test('ErrorMapper maps 500 Internal Server Error cleanly', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/v1/games'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/v1/games'),
          statusCode: 500,
          data: '<html><body>500 Internal Server Error</body></html>',
        ),
      );

      final exception = ErrorMapper.mapDioError(dioException);
      expect(exception, isA<ServerException>());
      expect(exception.message, contains('Internal server error'));
    });
  });

  group('Encryption & Security Layer Tests', () {
    test('EncryptionService encrypts and decrypts string correctly', () {
      final encryptionService =
          EncryptionService(secretKey: 'all_stars_arena_secure_aes_key');
      const plainText = 'rtsp://admin:secret123@192.168.1.100:554/stream1';

      final encrypted = encryptionService.encrypt(plainText);
      expect(encrypted, isNot(equals(plainText)));

      final decrypted = encryptionService.decrypt(encrypted);
      expect(decrypted, equals(plainText));
    });
  });
}
