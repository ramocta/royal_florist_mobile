import '../core/api/api_client.dart';
import '../models/beranda_model.dart';

class BerandaService {
  Future<BerandaModel> ambilBeranda({String? tanggal}) async {
    final res = await ApiClient.get(
      '/karyawan/beranda',
      query: tanggal == null ? null : {'tanggal': tanggal},
    );
    final data = (res is Map && res['data'] != null) ? res['data'] : res;
    return BerandaModel.fromJson(Map<String, dynamic>.from(data as Map));
  }
}
