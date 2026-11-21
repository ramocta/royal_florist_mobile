import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'produk_model.dart';

class ProdukDraft {
  ProdukDraft({this.kategori, this.sub, this.aktif = true, this.fotoLama});

  factory ProdukDraft.dariProduk(Produk p, List<Kategori> daftar) {
    final kategori = daftar.where((k) => k.id == p.idKategori).firstOrNull;
    return ProdukDraft(
        kategori: kategori,
        sub: kategori?.subs.where((s) => s.id == p.idSub).firstOrNull,
        aktif: p.aktif,
        fotoLama: p.fotoUrl,
      )
      ..nama.text = p.nama
      ..harga.text = '${p.harga}'
      ..stok.text = '${p.stok}'
      ..deskripsi.text = p.deskripsi
      ..tersedia = p.tersedia;
  }

  final nama = TextEditingController();
  final harga = TextEditingController();
  final stok = TextEditingController(text: '0');
  final deskripsi = TextEditingController();
  final String? fotoLama;

  Kategori? kategori;
  SubKategori? sub;
  bool tersedia = true;
  bool aktif;
  XFile? foto;
  Uint8List? fotoBytes;
  String? error;

  bool get pakaiStok {
    final s = sub;
    final k = kategori;
    if (s != null) return s.pakaiStok;
    return k != null && k.subs.isEmpty && k.pakaiStok;
  }

  bool get namaOtomatis {
    final s = sub;
    return kategori != null && s != null && !s.pakaiStok;
  }

  String get teksNamaOtomatis {
    final k = kategori;
    final s = sub;
    if (k == null || s == null) return '';
    return s.nama.toLowerCase().startsWith(k.nama.toLowerCase())
        ? s.nama
        : '${k.nama} ${s.nama}';
  }

  String get satuan => sub != null ? 'tangkai' : 'pcs';

  String get judul {
    final teks = namaOtomatis ? teksNamaOtomatis : nama.text.trim();
    return teks.isEmpty ? 'Produk baru' : teks;
  }

  String get ringkasan {
    final k = kategori;
    if (k == null) return 'Pilih kategori untuk mulai';
    return sub == null ? k.nama : '${k.nama} · ${sub!.nama}';
  }

  String? validasi() {
    final k = kategori;
    if (k == null) return 'Pilih kategori.';
    if (k.subs.isNotEmpty && sub == null) {
      return 'Pilih ${k.subLabel.toLowerCase()} produk.';
    }
    if (!namaOtomatis && nama.text.trim().isEmpty) {
      return 'Nama produk wajib diisi.';
    }
    if (int.tryParse(harga.text.trim()) == null) {
      return 'Harga wajib diisi dengan angka.';
    }
    if (pakaiStok && int.tryParse(stok.text.trim()) == null) {
      return 'Stok wajib diisi.';
    }
    return null;
  }

  Map<String, dynamic> toMap() => {
    'id_ctg': kategori!.id,
    if (sub != null) 'id_subctg': sub!.id,
    'nama_produk': namaOtomatis ? teksNamaOtomatis : nama.text.trim(),
    'harga': harga.text.trim(),
    'deskripsi': deskripsi.text.trim(),
    'is_active': aktif ? 1 : 0,
    if (pakaiStok) 'stok': stok.text.trim() else 'tersedia': tersedia ? 1 : 0,
  };

  /// Produk baru dengan kategori, jenis, dan pengaturan yang sama.
  ProdukDraft turunan() =>
      ProdukDraft(kategori: kategori, sub: sub, aktif: aktif)
        ..tersedia = tersedia;

  /// Seperti [turunan], ditambah isian (tanpa foto).
  ProdukDraft salinan() => turunan()
    ..nama.text = nama.text
    ..harga.text = harga.text
    ..stok.text = stok.text
    ..deskripsi.text = deskripsi.text;

  void dispose() {
    nama.dispose();
    harga.dispose();
    stok.dispose();
    deskripsi.dispose();
  }
}
