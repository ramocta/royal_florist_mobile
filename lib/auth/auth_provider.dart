// State login: isLoading, errorMessage, isLoggedIn

import 'package:flutter/foundation.dart';

import 'auth_service.dart';
import 'auth_storage.dart';
import 'login_response_model.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? service, AuthStorage? storage})
      : _service = service ?? AuthService(),
        _storage = storage ?? AuthStorage();

  /// Hanya role ini yang boleh masuk ke aplikasi.
  static const String roleDiizinkan = 'karyawan';

  final AuthService _service;
  final AuthStorage _storage;

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  /// Mengembalikan true bila login berhasil.
  Future<bool> login(String identifier, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _service.login(identifier, password);

      if (res.user.role != roleDiizinkan) {
        _errorMessage = 'Akun ini bukan akun karyawan';
        return false;
      }

      await _storage.saveSession(res.token, res.user);
      _user = res.user;
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan, coba lagi';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _storage.clear();
    _user = null;
    notifyListeners();
  }
}// State login: isLoading, errorMessage, isLoggedIn. Fungsi login(), logout(), cekSesi()

