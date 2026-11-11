import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'login_response_model.dart';

class AuthStorage {
  static const _kToken = 'auth_token';
  static const _kUser = 'auth_user';

  Future<void> simpan(LoginResponseModel data) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kToken, data.token);
    await sp.setString(_kUser, jsonEncode(data.user.toJson()));
  }

  Future<LoginResponseModel?> baca() async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString(_kToken);
    final user = sp.getString(_kUser);
    if (token == null || user == null) return null;
    try {
      return LoginResponseModel(
        token: token,
        user: UserLogin.fromJson(
          Map<String, dynamic>.from(jsonDecode(user) as Map),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> hapus() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kToken);
    await sp.remove(_kUser);
  }
}
