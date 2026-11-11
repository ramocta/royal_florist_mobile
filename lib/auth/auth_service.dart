import '../core/api/api_client.dart';
import 'login_response_model.dart';

class AuthService {
  Future<LoginResponseModel> login(String email, String password) async {
    final res = await ApiClient.post(
      '/karyawan/login',
      body: {'email': email, 'password': password},
    );
    return LoginResponseModel.fromJson(Map<String, dynamic>.from(res as Map));
  }

  Future<void> logout() async {
    try {
      await ApiClient.post('/karyawan/logout');
    } catch (_) {}
  }
}
