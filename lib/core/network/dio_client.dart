import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';

class DioClient {
  final SecureStorageService secureStorageService;
  late final Dio dio;

  DioClient({required this.secureStorageService}) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:5000/api/v1',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
  }
}
