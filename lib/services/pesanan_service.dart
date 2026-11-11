
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
}
