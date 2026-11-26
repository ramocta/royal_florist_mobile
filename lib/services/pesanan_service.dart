import '../../core/api/api_client.dart';

class PesananService {
  Future<List<Map<String, dynamic>>> getPesanan() async {
    try {
      final response = await ApiClient.get('/orders');

      dynamic data = response;

      if (response is Map<String, dynamic>) {
        data = response['data'];
      }

      if (data is List) {
        return data
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Gagal mengambil data pesanan: $e');
    }
  }

  /// Ubah status pesanan.
  /// ASUMSI endpoint: PATCH /orders/{id}/status
  /// body: { status_pesanan, catatan }
  Future<void> updateStatus({
    required dynamic id,
    required String status,
    String? catatan,
  }) async {
    await ApiClient.patch(
      '/orders/$id/status',
      body: {
        'status_pesanan': status,
        if (catatan != null && catatan.trim().isNotEmpty)
          'catatan': catatan.trim(),
      },
    );
  }

  /// Konfirmasi pesanan dari halaman konfirmasi mobile.
  /// PUT /karyawan/orders/{id} (OrderController@update): menerima
  /// dalam_pengiriman, data kurir, dan catatan_toko.
  Future<void> konfirmasiPesanan({
    required dynamic id,
    required String status,
    String? namaKurir,
    String? noHpKurir,
    String? estimasiTiba,
    String? catatan,
  }) async {
    final estimasi = _estimasiKeTanggal(estimasiTiba);
    await ApiClient.put(
      '/karyawan/orders/$id',
      body: {
        'status_pesanan': status,
        if (namaKurir != null && namaKurir.trim().isNotEmpty)
          'nama_kurir': namaKurir.trim(),
        if (noHpKurir != null && noHpKurir.trim().isNotEmpty)
          'no_hp_kurir': noHpKurir.trim(),
        if (estimasi != null) 'estimasi_tiba': estimasi,
        if (catatan != null && catatan.trim().isNotEmpty)
          'catatan_toko': catatan.trim(),
      },
    );
  }

  /// "12:00 WIB" atau "12.30" -> "2026-11-26 12:00:00" (hari ini).
  /// Mengembalikan null kalau jam tidak terbaca.
  String? _estimasiKeTanggal(String? teks) {
    if (teks == null) return null;
    final m = RegExp(r'(\d{1,2})[:.](\d{2})').firstMatch(teks);
    if (m == null) return null;
    final jam = int.parse(m.group(1)!);
    final menit = int.parse(m.group(2)!);
    if (jam > 23 || menit > 59) return null;
    final n = DateTime.now();
    String dua(int v) => v.toString().padLeft(2, '0');
    return '${n.year}-${dua(n.month)}-${dua(n.day)} ${dua(jam)}:${dua(menit)}:00';
  }
}
