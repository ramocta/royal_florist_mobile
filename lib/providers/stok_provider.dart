import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../core/api/api_client.dart';
import '../models/produk_model.dart';
import '../services/stok_service.dart';

class StokProvider extends ChangeNotifier {
  static const opsiStatus = ['Semua', 'Tersedia', 'Habis', 'Nonaktif'];

  final StokService _service = StokService();
  Timer? _timer;
  bool _mengambil = false;
  int _versi = 0;

  List<Produk> semua = [];
  List<Kategori> kategori = [];
  bool loading = false;
  String? error;

  String query = '';
  String statusFilter = 'Semua';
  Kategori? kategoriTerpilih;
  SubKategori? subTerpilih;

  bool get filterAktif => statusFilter != 'Semua';

  List<Produk> get produkHabis =>
      semua.where((p) => p.aktif && !p.ada).toList();

  List<Produk> get tampil {
    final q = query.trim().toLowerCase();
    final k = kategoriTerpilih;
    final s = subTerpilih;
    return semua.where((p) {
      if (k != null && p.idKategori != k.id) return false;
      if (s != null && p.idSub != s.id) return false;
      if (statusFilter != 'Semua' && p.status != statusFilter) return false;
      if (q.isNotEmpty &&
          !p.nama.toLowerCase().contains(q) &&
          !p.sku.toLowerCase().contains(q)) {
        return false;
      }
      return true;
    }).toList();
  }

  void mulai({Duration interval = const Duration(seconds: 5)}) {
    muat();
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => muat(silent: true));
  }

  void berhenti() => _timer?.cancel();

  Future<void> muat({bool silent = false, bool paksa = false}) async {
    if (silent && _mengambil && !paksa) return;
    final v = ++_versi;
    _mengambil = true;
    if (!silent) {
      loading = true;
      notifyListeners();
    }
    try {
      final hasil = await _service.ambil();
      if (v == _versi) {
        semua = hasil.items;
        kategori = hasil.kategori;
        error = null;
      }
    } catch (e) {
      if (v == _versi) error = e.toString();
    } finally {
      _mengambil = false;
    }
    if (v == _versi) {
      loading = false;
      notifyListeners();
    }
  }

  void cari(String teks) {
    query = teks;
    notifyListeners();
  }

  void ubahStatus(String status) {
    statusFilter = status;
    notifyListeners();
  }

  void pilihKategori(Kategori? k, SubKategori? s) {
    kategoriTerpilih = k;
    subTerpilih = s;
    notifyListeners();
  }

  Future<String?> simpanStok(Produk p, int stok) =>
      _jalankan(() => _service.setStok(p.id, stok));

  Future<String?> setTersedia(Produk p, bool nilai) async {
    _ganti(p.copyWith(tersedia: nilai));
    final err = await _jalankan(() => _service.setTersedia(p.id, nilai));
    if (err != null) await muat(silent: true, paksa: true);
    return err;
  }

  Future<String?> simpanProduk({
    int? id,
    required Map<String, dynamic> data,
    XFile? foto,
  }) => _jalankan(
    () => id == null
        ? _service.tambah(data, foto: foto)
        : _service.ubah(id, data, foto: foto),
  );

  Future<String?> hapus(Produk p) => _jalankan(() => _service.hapus(p.id));

  Future<String?> _jalankan(Future<void> Function() aksi) async {
    try {
      await aksi();
      await muat(silent: true, paksa: true);
      return null;
    } on ApiException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _ganti(Produk baru) {
    _versi++;
    semua = [for (final p in semua) p.id == baru.id ? baru : p];
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
