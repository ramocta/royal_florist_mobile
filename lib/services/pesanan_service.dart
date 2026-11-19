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
}