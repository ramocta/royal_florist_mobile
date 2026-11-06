// Mengirim username/email & password ke API

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'login_response_model.dart';

/// Error yang pesannya aman ditampilkan ke pengguna.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  /// true  = pakai akun contoh di bawah (tanpa server), supaya aplikasi bisa dicoba.
  /// false = kirim ke API sungguhan di [baseUrl].
  static const bool useMock = true;

  /// 10.0.2.2 = alamat "localhost" komputer dari emulator Android.
  /// Untuk HP asli, ganti dengan IP komputer, misalnya http://192.168.1.10:8080/api
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  Future<LoginResponse> login(String identifier, String password) async {
    if (useMock) return _mockLogin(identifier, password);

    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            // Tabel users memakai kolom `email` sebagai kunci login.
            body: jsonEncode({'email': identifier, 'password': password}),
          )
          .timeout(const Duration(seconds: 15));

      Map<String, dynamic> body = {};
      try {
        final decoded = jsonDecode(res.body);
        if (decoded is Map<String, dynamic>) body = decoded;
      } catch (_) {}

      if (res.statusCode == 200) return LoginResponse.fromJson(body);

      throw AuthException('${body['message'] ?? 'Username atau password salah'}');
    } on AuthException {
      rethrow;
    } on TimeoutException {
      throw const AuthException('Server tidak merespons, coba lagi');
    } catch (_) {
      throw const AuthException('Tidak dapat terhubung ke server');
    }
  }

  // ---- Akun contoh (hanya dipakai saat useMock = true) ----
  //   karyawan  / 123456  -> berhasil masuk
  //   pelanggan / 123456  -> ditolak (bukan akun karyawan)
  Future<LoginResponse> _mockLogin(String identifier, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final id = identifier.trim().toLowerCase();
    if (password != '123456' || (id != 'karyawan' && id != 'pelanggan')) {
      throw const AuthException('Username atau password salah');
    }

    return LoginResponse(
      token: 'mock-token-royal-florist',
      user: UserModel(
        id: id == 'karyawan' ? 2 : 3,
        nama: id == 'karyawan' ? 'Karyawan Royal Florist' : 'Pelanggan',
        email: '$id@royalflorist.com',
        role: id,
      ),
    );
  }
}// Request POST /api/auth/login

