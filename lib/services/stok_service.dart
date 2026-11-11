import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../core/api/api_client.dart';
import '../models/produk_model.dart';

class StokService {
  Future<StokData> ambil() async {
    final res = Map<String, dynamic>.from(
      await ApiClient.get('/karyawan/produk') as Map,
    );
    return StokData(
      items: ((res['items'] as List?) ?? [])
          .map((e) => Produk.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      kategori: ((res['kategori'] as List?) ?? [])
          .map((e) => Kategori.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  Future<void> tambah(Map<String, dynamic> data, {XFile? foto}) async =>
      ApiClient.postForm('/karyawan/produk', await _form(data, foto));

  Future<void> ubah(int id, Map<String, dynamic> data, {XFile? foto}) async =>
      ApiClient.postForm('/karyawan/produk/$id', await _form(data, foto));

  Future<void> setStok(int id, int stok) =>
      ApiClient.patch('/karyawan/produk/$id/stok', body: {'stok': stok});

  Future<void> setTersedia(int id, bool tersedia) => ApiClient.patch(
    '/karyawan/produk/$id/ketersediaan',
    body: {'tersedia': tersedia ? 1 : 0},
  );

  Future<void> hapus(int id) => ApiClient.delete('/karyawan/produk/$id');

  Future<FormData> _form(Map<String, dynamic> data, XFile? foto) async =>
      FormData.fromMap({
        ...data,
        if (foto != null)
          'foto_produk': MultipartFile.fromBytes(
            await foto.readAsBytes(),
            filename: foto.name,
          ),
      });
}
