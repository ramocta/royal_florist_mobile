import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  static const String login = '/login_karyawan';

  static const String logout = '/logout';
}
