import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../core/api/api_client.dart';
import '../models/profil_model.dart';

/// Lokasi: lib/services/profil_service.dart
class ProfilService {
  static const String _endpoint = '/karyawan/profil';

  Future<ProfilModel> getProfil() async {
    final response = await ApiClient.get(_endpoint);
    return ProfilModel.fromJson(_ambilData(response));
  }

  Future<ProfilModel> updateProfil(ProfilModel profil) async {
    final response = await ApiClient.put(_endpoint, body: profil.toJson());
    return ProfilModel.fromJson(_ambilData(response));
  }

  /// Upload foto (bisa di web maupun mobile).
  Future<String?> uploadFoto(XFile file) async {
    final bytes = await file.readAsBytes();
    final nama = file.name.isNotEmpty ? file.name : 'foto.jpg';

    final form = FormData.fromMap({
      'foto': MultipartFile.fromBytes(bytes, filename: nama),
    });

    final response = await ApiClient.postForm('$_endpoint/foto', form);
    return ProfilModel.fromJson(_ambilData(response)).fotoUrl;
  }

  Map<String, dynamic> _ambilData(dynamic response) {
    dynamic data = response;
    if (response is Map && response['data'] is Map) {
      data = response['data'];
    }
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }
}