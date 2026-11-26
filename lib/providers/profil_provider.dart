import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/profil_model.dart';
import '../services/profil_service.dart';

/// Lokasi: lib/providers/profil_provider.dart
class ProfilProvider extends ChangeNotifier {
  final ProfilService _service = ProfilService();

  ProfilModel? _profil;
  bool _loading = false;
  bool _saving = false;
  String? _error;

  ProfilModel? get profil => _profil;
  bool get loading => _loading;
  bool get saving => _saving;
  String? get error => _error;

  String _pesan(Object e) => e.toString().replaceFirst('Exception: ', '');

  Future<void> muat() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _profil = await _service.getProfil();
    } catch (e) {
      _error = _pesan(e);
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> simpan(ProfilModel baru, {XFile? foto}) async {
    _saving = true;
    _error = null;
    notifyListeners();

    try {
      await _service.updateProfil(baru);
      if (foto != null) {
        await _service.uploadFoto(foto);
      }
      _profil = await _service.getProfil();
      _saving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _pesan(e);
      _saving = false;
      notifyListeners();
      return false;
    }
  }
}