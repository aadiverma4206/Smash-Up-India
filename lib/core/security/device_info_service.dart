import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Future<Map<String, dynamic>> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      return {
        'platform': 'ANDROID',
        'model': androidInfo.model,
        'brand': androidInfo.brand,
        'osVersion': androidInfo.version.release,
        'isPhysicalDevice': androidInfo.isPhysicalDevice,
      };
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      return {
        'platform': 'IOS',
        'model': iosInfo.utsname.machine,
        'brand': 'Apple',
        'osVersion': iosInfo.systemVersion,
        'isPhysicalDevice': iosInfo.isPhysicalDevice,
      };
    }

    return {
      'platform': 'UNKNOWN',
      'model': 'Desktop/Web',
      'osVersion': Platform.operatingSystem,
    };
  }
}
