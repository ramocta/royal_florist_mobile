import '../../core/api/api_client.dart';
import '../../models/ringkasan_model.dart'; // sesuaikan path dengan struktur project

class RingkasanService {
  /// GET /karyawan/ringkasan
  Future<RingkasanModel> ambilRingkasan({String? tanggal, int limit = 5}) async {
    final res = await ApiClient.get(
      '/karyawan/ringkasan',
      query: {
        if (tanggal != null) 'tanggal': tanggal, // format: 2026-10-04
        'limit': limit,
      },
    );

    final body = Map<String, dynamic>.from(res as Map);
    return RingkasanModel.fromJson(
      Map<String, dynamic>.from((body['data'] as Map?) ?? {}),
    );
  }

  /// GET /karyawan/pesanan  ("Lihat Semua")
  /// status: semua | dikonfirmasi | diproses | dikirim | selesai | dibatalkan
  Future<PesananListModel> ambilPesanan({
    String? search,
    String? status,
    int page = 1,
    int perPage = 10,
  }) async {
    final res = await ApiClient.get(
      '/karyawan/pesanan',
      query: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status != 'semua') 'status': status,
        'page': page,
        'per_page': perPage,
      },
    );

    return PesananListModel.fromJson(Map<String, dynamic>.from(res as Map));
  }
}