import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get appName => dotenv.env['APP_NAME'] ?? 'SMASH UP INDIA';
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:5000/api/v1';
  static String get razorpayKeyId => dotenv.env['RAZORPAY_KEY_ID'] ?? '';
  static int get connectTimeout =>
      int.parse(dotenv.env['CONNECT_TIMEOUT'] ?? '15000');
  static int get receiveTimeout =>
      int.parse(dotenv.env['RECEIVE_TIMEOUT'] ?? '15000');

  static Future<void> init({String envFile = '.env.dev'}) async {
    await dotenv.load(fileName: envFile);
  }
}
