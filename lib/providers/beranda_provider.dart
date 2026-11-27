import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/beranda_model.dart';
import '../services/beranda_service.dart';

class BerandaProvider extends ChangeNotifier {
  final BerandaService _service = BerandaService();
  Timer? _timer;
  bool _mengambil = false;
  int _versi = 0;

  BerandaModel data = BerandaModel.empty();
  bool loading = false;
  String? error;

  /// null = otomatis mengikuti "hari ini" versi server (seperti dashboard web).
  DateTime? tanggalDipilih;

  void mulai({Duration interval = const Duration(seconds: 5)}) {
    tanggalDipilih = null;
    muat();
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => muat(silent: true));
  }

  void berhenti() => _timer?.cancel();

  Future<void> muat({bool silent = false}) async {
    if (silent && _mengambil) return;
    final v = ++_versi;
    _mengambil = true;
    if (!silent) {
      loading = true;
      notifyListeners();
    }
    try {
      final hasil = await _service.ambilBeranda(tanggal: _tanggalParam());
      if (v == _versi) {
        data = hasil;
        error = null;
      }
    } catch (e) {
      if (v == _versi) error = e.toString();
    }
    if (v == _versi) {
      _mengambil = false;
      loading = false;
      notifyListeners();
    }
  }

  void kembaliKeHariIni() {
    tanggalDipilih = null;
    muat();
  }

  void ubahTanggal(DateTime t) {
    final h = DateTime.now();
    final hariIni = t.year == h.year && t.month == h.month && t.day == h.day;
    tanggalDipilih = hariIni ? null : DateTime(t.year, t.month, t.day);
    muat();
  }

  String? _tanggalParam() {
    final t = tanggalDipilih;
    if (t == null) return null;
    return '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
