import 'package:encrypt/encrypt.dart' as encrypt_pkg;

class EncryptionService {
  final encrypt_pkg.Key key;
  final encrypt_pkg.IV iv;
  late final encrypt_pkg.Encrypter _encrypter;

  EncryptionService({required String secretKey})
      : key = encrypt_pkg.Key.fromUtf8(
            secretKey.padRight(32, '0').substring(0, 32)),
        iv = encrypt_pkg.IV.fromLength(16) {
    _encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key));
  }

  String encrypt(String plainText) {
    return _encrypter.encrypt(plainText, iv: iv).base64;
  }

  String decrypt(String encryptedBase64) {
    return _encrypter.decrypt64(encryptedBase64, iv: iv);
  }
}
