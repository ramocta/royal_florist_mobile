import 'package:flutter/foundation.dart';

import '../core/api/api_client.dart';
import 'auth_service.dart';
import 'auth_storage.dart';
import 'login_response_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();
  final AuthStorage _storage = AuthStorage();

  UserLogin? user;
  bool loading = false;
  String? error;

  static const String roleDiizinkan = 'karyawan';

  static bool _roleValid(String role) =>
      role.trim().toLowerCase() == roleDiizinkan;

  bool get sudahLogin => ApiClient.token != null && user != null;

  Future<void> muatSesi() async {
    final s = await _storage.baca();
    if (s != null && _roleValid(s.user.role)) {
      ApiClient.token = s.token;
      user = s.user;
    } else if (s != null) {
      await _storage.hapus();
    }
  }

  Future<bool> login(String email, String password) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final res = await _service.login(email.trim(), password);
      if (!_roleValid(res.user.role)) {
        error = 'Akun ini bukan akun karyawan.';
        loading = false;
        notifyListeners();
        return false;
      }
      ApiClient.token = res.token;
      user = res.user;
      await _storage.simpan(res);
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _service.logout();
    bersihkanSesi();
  }

  void bersihkanSesi() {
    ApiClient.token = null;
    user = null;
    _storage.hapus();
    notifyListeners();
  }
}
