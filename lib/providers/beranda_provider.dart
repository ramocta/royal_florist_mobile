import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/beranda_model.dart';
import '../models/produk_model.dart';
import '../services/beranda_service.dart';
import '../services/stok_service.dart';

class BerandaProvider extends ChangeNotifier {
  /// Stok 1 sampai batas ini dianggap "menipis" (sama dengan dashboard web).
  static const int batasMenipis = 10;

  /// Daftar produk tidak perlu diambil tiap 5 detik seperti pesanan baru.
  static const Duration _jedaStok = Duration(seconds: 30);

  final BerandaService _service = BerandaService();
  final StokService _stokService = StokService();
  Timer? _timer;
  bool _mengambil = false;
  bool _mengambilStok = false;
  bool _tutup = false;
  DateTime? _stokTerakhir;
  int _versi = 0;

  BerandaModel data = BerandaModel.empty();
  List<Produk> stokHabis = [];
  List<Produk> stokMenipis = [];
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

  /// Angka di lonceng: pesanan baru + produk stok habis + produk stok menipis.
  int get jumlahNotif =>
      data.pesananBaru.length + stokHabis.length + stokMenipis.length;

  Future<void> muat({bool silent = false}) async {
    if (silent && _mengambil) return;
    final v = ++_versi;
    _mengambil = true;
    if (!silent) {
      loading = true;
      notifyListeners();
    }
    // Tidak di-await: stok lambat/gagal tidak boleh menahan tampilan beranda.
    _muatStok(paksa: !silent);
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

  Future<void> _muatStok({required bool paksa}) async {
    if (_mengambilStok) return;
    final terakhir = _stokTerakhir;
    if (!paksa &&
        terakhir != null &&
        DateTime.now().difference(terakhir) < _jedaStok) {
      return;
    }
    _mengambilStok = true;
    try {
      final hasil = await _stokService.ambil();
      final aktif = hasil.items.where((p) => p.aktif);
      stokHabis = aktif.where((p) => !p.ada).toList();
      stokMenipis =
          aktif
              .where((p) => p.pakaiStok && p.stok > 0 && p.stok <= batasMenipis)
              .toList()
            ..sort((a, b) => a.stok.compareTo(b.stok));
      _stokTerakhir = DateTime.now();
      if (!_tutup) notifyListeners();
    } catch (_) {
      // Notifikasi stok gagal dimuat: abaikan, daftar lama tetap dipakai.
    } finally {
      _mengambilStok = false;
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
    _tutup = true;
    _timer?.cancel();
    super.dispose();
  }
}
