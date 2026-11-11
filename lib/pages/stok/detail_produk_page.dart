import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/shared/app_colors.dart';
import '../../models/produk_model.dart';
import '../../providers/stok_provider.dart';
import '../../widgets/beranda/beranda_style.dart';
import '../../widgets/common/latar_pink.dart';
import '../../widgets/stok/konfirmasi_hapus.dart';
import '../../widgets/stok/produk_foto.dart';

class DetailProdukPage extends StatefulWidget {
  const DetailProdukPage({super.key, this.produk});

  final Produk? produk;

  @override
  State<DetailProdukPage> createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {
  final _nama = TextEditingController();
  final _harga = TextEditingController();
  final _stok = TextEditingController(text: '0');
  final _deskripsi = TextEditingController();

  Kategori? _kategori;
  SubKategori? _sub;
  bool _tersedia = true;
  bool _aktif = true;
  XFile? _foto;
  Uint8List? _fotoBytes;
  bool _menyimpan = false;
  String? _error;

  Produk? get _edit => widget.produk;
  bool get _pakaiStok => _sub?.pakaiStok ?? false;
  bool get _namaOtomatis =>
      _kategori != null && _sub != null && !_sub!.pakaiStok;

  String get _teksNamaOtomatis {
    final k = _kategori;
    final s = _sub;
    if (k == null || s == null) return '';
    return s.nama.toLowerCase().startsWith(k.nama.toLowerCase())
        ? s.nama
        : '${k.nama} ${s.nama}';
  }

  @override
  void initState() {
    super.initState();
    final p = _edit;
    if (p == null) return;
    final daftar = context.read<StokProvider>().kategori;
    _kategori = daftar.where((k) => k.id == p.idKategori).firstOrNull;
    _sub = _kategori?.subs.where((s) => s.id == p.idSub).firstOrNull;
    _nama.text = p.nama;
    _harga.text = '${p.harga}';
    _stok.text = '${p.stok}';
    _deskripsi.text = p.deskripsi;
    _tersedia = p.tersedia;
    _aktif = p.aktif;
  }

  @override
  void dispose() {
    _nama.dispose();
    _harga.dispose();
    _stok.dispose();
    _deskripsi.dispose();
    super.dispose();
  }

  Future<void> _pilihFoto() async {
    final sumber = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galeri'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (sumber == null) return;
    final f = await ImagePicker().pickImage(
      source: sumber,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (f == null) return;
    final bytes = await f.readAsBytes();
    if (!mounted) return;
    setState(() {
      _foto = f;
      _fotoBytes = bytes;
    });
  }

  String? _validasi() {
    if (_kategori == null) return 'Pilih kategori.';
    if (_kategori!.subs.isNotEmpty && _sub == null)
      return 'Pilih ${_kategori!.subLabel.toLowerCase()} produk.';
    if (!_namaOtomatis && _nama.text.trim().isEmpty)
      return 'Nama produk wajib diisi.';
    if (int.tryParse(_harga.text.trim()) == null)
      return 'Harga wajib diisi dengan angka.';
    if (_pakaiStok && int.tryParse(_stok.text.trim()) == null)
      return 'Stok wajib diisi.';
    return null;
  }

  Map<String, dynamic> _data() => {
    'id_ctg': _kategori!.id,
    if (_sub != null) 'id_subctg': _sub!.id,
    'nama_produk': _namaOtomatis ? _teksNamaOtomatis : _nama.text.trim(),
    'harga': _harga.text.trim(),
    'deskripsi': _deskripsi.text.trim(),
    'is_active': _aktif ? 1 : 0,
    if (_pakaiStok)
      'stok': _stok.text.trim()
    else
      'tersedia': _tersedia ? 1 : 0,
  };

  Future<void> _simpan() async {
    final salah = _validasi();
    if (salah != null) {
      setState(() => _error = salah);
      return;
    }
    setState(() {
      _menyimpan = true;
      _error = null;
    });
    final err = await context.read<StokProvider>().simpanProduk(
      id: _edit?.id,
      data: _data(),
      foto: _foto,
    );
    if (!mounted) return;
    if (err == null) {
      Navigator.pop(
        context,
        _edit == null
            ? 'Produk berhasil ditambahkan'
            : 'Produk berhasil diperbarui',
      );
    } else {
      setState(() {
        _menyimpan = false;
        _error = err;
      });
    }
  }

  Future<void> _hapus() async {
    final p = _edit!;
    if (!await konfirmasiHapus(context, p) || !mounted) return;
    setState(() {
      _menyimpan = true;
      _error = null;
    });
    final err = await context.read<StokProvider>().hapus(p);
    if (!mounted) return;
    if (err == null) {
      Navigator.pop(context, '${p.nama} dihapus');
    } else {
      setState(() {
        _menyimpan = false;
        _error = err;
      });
    }
  }

  InputDecoration _dekor(String label, {String? bantu}) => InputDecoration(
    labelText: label,
    helperText: bantu,
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.85),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  );

  Widget _pilihan<T>({
    required String label,
    required T? nilai,
    required List<DropdownMenuItem<T>> item,
    required ValueChanged<T?> onUbah,
  }) {
    return InputDecorator(
      decoration: _dekor(label)
          .copyWith(contentPadding: const EdgeInsets.fromLTRB(16, 6, 12, 6)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: nilai,
          isExpanded: true,
          hint: Text('Pilih ${label.toLowerCase()}'),
          items: item,
          onChanged: _menyimpan ? null : onUbah,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kategori = context.watch<StokProvider>().kategori;
    final edit = _edit != null;

    return Scaffold(
      backgroundColor: BerandaStyle.latarBawah,
      body: LatarPink(
        child: SafeArea(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BerandaStyle.kartu(radius: 22),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.maroon,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    edit ? 'Edit Produk' : 'Tambah Produk',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.maroon,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: _menyimpan ? null : _pilihFoto,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ProdukFoto(
                      url: _edit?.fotoUrl,
                      bytes: _fotoBytes,
                      lebar: double.infinity,
                      tinggi: 190,
                      radius: 22,
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: BerandaStyle.rose,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.photo_camera_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _pilihan<Kategori>(
                label: 'Kategori',
                nilai: _kategori,
                item: [
                  for (final k in kategori)
                    DropdownMenuItem(value: k, child: Text(k.nama)),
                ],
                onUbah: (k) => setState(() {
                  _kategori = k;
                  _sub = null;
                }),
              ),
              if (_kategori != null && _kategori!.subs.isNotEmpty) ...[
                const SizedBox(height: 12),
                _pilihan<SubKategori>(
                  label: _kategori!.subLabel,
                  nilai: _sub,
                  item: [
                    for (final s in _kategori!.subs)
                      DropdownMenuItem(value: s, child: Text(s.nama)),
                  ],
                  onUbah: (s) => setState(() => _sub = s),
                ),
              ],
              const SizedBox(height: 12),
              if (_namaOtomatis)
                InputDecorator(
                  decoration: _dekor('Nama produk (otomatis dari jenis)'),
                  child: Text(
                    _teksNamaOtomatis,
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                )
              else
                TextField(
                  controller: _nama,
                  maxLength: 100,
                  decoration: _dekor(
                    _pakaiStok
                        ? 'Nama bunga (mis. Aster, Mawar)'
                        : 'Nama produk',
                  ).copyWith(counterText: ''),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: _harga,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _dekor('Harga jual (Rp)'),
              ),
              const SizedBox(height: 12),
              if (_pakaiStok)
                TextField(
                  controller: _stok,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _dekor('Stok (tangkai)'),
                )
              else
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BerandaStyle.kartu(radius: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _segmen(
                          'Tersedia',
                          _tersedia,
                          const Color(0xFF1E7A34),
                          () => setState(() => _tersedia = true),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _segmen(
                          'Tidak tersedia',
                          !_tersedia,
                          const Color(0xFFB3261E),
                          () => setState(() => _tersedia = false),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: _deskripsi,
                minLines: 3,
                maxLines: 5,
                decoration: _dekor('Deskripsi'),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                value: _aktif,
                activeThumbColor: BerandaStyle.rose,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Tampilkan di katalog (aktif)',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                ),
                onChanged: _menyimpan
                    ? null
                    : (v) => setState(() => _aktif = v),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFB3261E),
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: _menyimpan ? null : _simpan,
                child: _menyimpan
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(edit ? 'Simpan perubahan' : 'Simpan produk'),
              ),
              if (edit)
                TextButton(
                  onPressed: _menyimpan ? null : _hapus,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFB3261E),
                  ),
                  child: const Text('Hapus produk'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _segmen(String teks, bool aktif, Color warna, VoidCallback onTap) {
    return GestureDetector(
      onTap: _menyimpan ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: aktif ? warna : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            teks,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: aktif ? Colors.white : BerandaStyle.teksRedup,
            ),
          ),
        ),
      ),
    );
  }
}
