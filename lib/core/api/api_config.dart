import 'package:flutter/foundation.dart';

class ApiConfig {
  ApiConfig._();

  /// Untuk HP asli: isi IP laptop di WiFi yang sama, contoh 'http://192.168.1.10:8000'.
  /// Kosongkan untuk Chrome / emulator.
  /// Laravel harus dijalankan: php artisan serve --host=0.0.0.0
  static const String ipPerangkatAsli = '';

  static String get baseUrl {
    if (ipPerangkatAsli.isNotEmpty) return '$ipPerangkatAsli/api';
    if (kIsWeb) return 'http://localhost:8000/api';
    if (defaultTargetPlatform == TargetPlatform.android)
      return 'http://10.0.2.2:8000/api';
    return 'http://localhost:8000/api'; // iOS simulator
  }

  static const Duration timeout = Duration(seconds: 15);

  static String? fotoUrl(int id, String? foto) {
    if (foto == null || foto.isEmpty) return null;
    return '$baseUrl/produk-foto/$id?f=${Uri.encodeQueryComponent(foto)}';
  }
}
