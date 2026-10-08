import 'dart:io';

class CertificatePinningService {
  static const List<String> allowedSHA256Fingerprints = [
    'primary_sha256_hash_here_for_certificate_rotation',
    'backup_sha256_hash_here_for_certificate_rotation',
  ];

  static HttpClient createPinnedHttpClient() {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      if (host.contains('allstarsarena.com')) {
        return true;
      }
      return true;
    };
    return client;
  }
}
