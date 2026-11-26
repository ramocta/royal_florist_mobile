import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/shared/app_colors.dart';
import '../../models/produk_draft.dart';
import '../../models/produk_model.dart';
import '../../providers/stok_provider.dart';
import '../../widgets/beranda/beranda_style.dart';
import '../../widgets/common/info_snack.dart';
import '../../widgets/common/latar_pink.dart';
import '../../widgets/stok/form_produk.dart';

/// Tambah satu atau beberapa produk sekaligus (maksimal 20).
class TambahProdukPage extends StatefulWidget {
  const TambahProdukPage({super.key});

  @override
  State<TambahProdukPage> createState() => _TambahProdukPageState();
}

class _TambahProdukPageState extends State<TambahProdukPage> {
  static const _maks = 20;

  final List<ProdukDraft> _draft = [ProdukDraft()];
  final Map<ProdukDraft, GlobalKey> _kunci = {};
  bool _menyimpan = false;
  String? _error;

  GlobalKey _k(ProdukDraft d) => _kunci.putIfAbsent(d, GlobalKey.new);

  @override
  void dispose() {
    for (final d in _draft) {
      d.dispose();
    }
    super.dispose();
  }

  void _gulir(ProdukDraft d) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final konteks = _k(d).currentContext;
      if (konteks == null) return;
      Scrollable.ensureVisible(
        konteks,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        alignment: 0.05,
      );
    });
  }

  void _tambah({ProdukDraft? dari, bool salin = false}) {
    if (_draft.length >= _maks) {
      tampilkanInfo(
        context,
        'Maksimal $_maks produk sekali simpan.',
        galat: true,
      );
      return;
    }
    final baru = salin ? dari!.salinan() : (dari?.turunan() ?? ProdukDraft());
    setState(() {
      final indeks = salin ? _draft.indexOf(dari!) + 1 : _draft.length;
      _draft.insert(indeks, baru);
    });
    _gulir(baru);
  }

  void _hapus(ProdukDraft d) {
    if (_draft.length == 1) return;
    setState(() => _draft.remove(d));
    _kunci.remove(d);
    d.dispose();
  }

  Future<void> _simpan() async {
    ProdukDraft? pertama;
    for (var i = 0; i < _draft.length; i++) {
      final salah = _draft[i].validasi();
      _draft[i].error = salah == null ? null : 'Produk ${i + 1}: $salah';
      if (salah != null) pertama ??= _draft[i];
    }
    if (pertama != null) {
      setState(() => _error = 'Lengkapi isian yang ditandai merah.');
      _gulir(pertama);
      return;
    }
    setState(() {
      _menyimpan = true;
      _error = null;
    });
    final err = await context.read<StokProvider>().tambahBanyak(
      [for (final d in _draft) d.toMap()],
      [for (final d in _draft) d.foto],
    );
    if (!mounted) return;
    if (err == null) {
      Navigator.pop(
        context,
        _draft.length == 1
            ? 'Produk berhasil ditambahkan'
            : '${_draft.length} produk berhasil ditambahkan',
      );
    } else {
      setState(() {
        _menyimpan = false;
        _error = err;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final kategori = context.watch<StokProvider>().kategori;
    final jumlah = _draft.length;

    return Scaffold(
      backgroundColor: BerandaStyle.latarBawah,
      body: LatarPink(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _menyimpan ? null : () => Navigator.pop(context),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tambah Produk',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.maroon,
                            ),
                          ),
                          Text(
                            '$jumlah produk akan ditambahkan',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: BerandaStyle.teksRedup,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  children: [
                    for (var i = 0; i < jumlah; i++)
                      _KartuProduk(
                        key: _k(_draft[i]),
                        nomor: i + 1,
                        draft: _draft[i],
                        kategori: kategori,
                        terkunci: _menyimpan,
                        bisaHapus: jumlah > 1,
                        onUbah: () => setState(() {}),
                        onSalin: () => _tambah(dari: _draft[i], salin: true),
                        onHapus: () => _hapus(_draft[i]),
                      ),
                  ],
                ),
              ),
              _BarBawah(
                jumlah: jumlah,
                error: _error,
                menyimpan: _menyimpan,
                onTambah: () => _tambah(dari: _draft.last),
                onSimpan: _simpan,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KartuProduk extends StatelessWidget {
  const _KartuProduk({
    super.key,
    required this.nomor,
    required this.draft,
    required this.kategori,
    required this.terkunci,
    required this.bisaHapus,
    required this.onUbah,
    required this.onSalin,
    required this.onHapus,
  });

  final int nomor;
  final ProdukDraft draft;
  final List<Kategori> kategori;
  final bool terkunci;
  final bool bisaHapus;
  final VoidCallback onUbah;
  final VoidCallback onSalin;
  final VoidCallback onHapus;

  @override
  Widget build(BuildContext context) {
    final salah = draft.error != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BerandaStyle.kartu(radius: 22).copyWith(
        border: Border.all(
          color: salah
              ? const Color(0xFFE5736F)
              : BerandaStyle.rose.withValues(alpha: 0.08),
          width: salah ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.maroon,
                child: Text(
                  '$nomor',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      draft.judul,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      draft.ringkasan,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: BerandaStyle.teksRedup,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Duplikat',
                onPressed: terkunci ? null : onSalin,
                icon: const Icon(Icons.copy_rounded, size: 20),
                color: BerandaStyle.teksRedup,
              ),
              if (bisaHapus)
                IconButton(
                  tooltip: 'Hapus dari daftar',
                  onPressed: terkunci ? null : onHapus,
                  icon: const Icon(Icons.delete_outline_rounded, size: 22),
                  color: const Color(0xFFB3261E),
                ),
            ],
          ),
          const Divider(height: 20),
          FormProduk(
            draft: draft,
            kategori: kategori,
            terkunci: terkunci,
            onUbah: onUbah,
          ),
        ],
      ),
    );
  }
}

class _BarBawah extends StatelessWidget {
  const _BarBawah({
    required this.jumlah,
    required this.error,
    required this.menyimpan,
    required this.onTambah,
    required this.onSimpan,
  });

  final int jumlah;
  final String? error;
  final bool menyimpan;
  final VoidCallback onTambah;
  final VoidCallback onSimpan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.maroon.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFB3261E), fontSize: 12),
              ),
            ),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: menyimpan ? null : onTambah,
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('Produk lain'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.maroon,
                  side: const BorderSide(color: AppColors.maroon),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: menyimpan ? null : onSimpan,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.maroon,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: menyimpan
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          jumlah == 1
                              ? 'Simpan produk'
                              : 'Simpan $jumlah produk',
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
