import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/shared/app_colors.dart';
import '../../providers/stok_provider.dart';
import '../beranda/beranda_style.dart';
import 'dialog_kelola.dart';

class TambahKategoriDialog extends StatefulWidget {
  const TambahKategoriDialog({super.key});

  @override
  State<TambahKategoriDialog> createState() => _TambahKategoriDialogState();
}

class _TambahKategoriDialogState extends State<TambahKategoriDialog> {
  final _nama = TextEditingController();
  bool _pakaiStok = false;
  bool _menyimpan = false;
  String? _error;

  @override
  void dispose() {
    _nama.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    final nama = _nama.text.trim();
    if (nama.isEmpty) {
      setState(() => _error = 'Nama kategori wajib diisi.');
      return;
    }
    setState(() {
      _menyimpan = true;
      _error = null;
    });
    final err = await context.read<StokProvider>().tambahKategori(
      nama,
      _pakaiStok,
    );
    if (!mounted) return;
    if (err == null) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _menyimpan = false;
        _error = err;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogKelola(
      judul: 'Kategori Baru',
      subjudul: 'Pilih cara menghitung produknya',
      info: 'Kategori baru langsung muncul di web admin dan katalog pelanggan.',
      menyimpan: _menyimpan,
      error: _error,
      onSimpan: _simpan,
      isi: [
        TextField(
          controller: _nama,
          maxLength: 50,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Nama kategori',
            hintText: 'Mis. Parcel, Bunga Potong',
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _Pilihan(
          judul: 'Keterangan ketersediaan',
          keterangan: 'Produk cukup ditandai tersedia atau tidak tersedia.',
          ikon: Icons.check_circle_outline_rounded,
          dipilih: !_pakaiStok,
          onTap: () => setState(() => _pakaiStok = false),
        ),
        const SizedBox(height: 8),
        _Pilihan(
          judul: 'Pakai stok',
          keterangan: 'Produk dihitung per jumlah (stok).',
          ikon: Icons.inventory_2_outlined,
          dipilih: _pakaiStok,
          onTap: () => setState(() => _pakaiStok = true),
        ),
      ],
    );
  }
}

class _Pilihan extends StatelessWidget {
  const _Pilihan({
    required this.judul,
    required this.keterangan,
    required this.ikon,
    required this.dipilih,
    required this.onTap,
  });

  final String judul;
  final String keterangan;
  final IconData ikon;
  final bool dipilih;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: dipilih
              ? BerandaStyle.rose.withValues(alpha: 0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: dipilih
                ? BerandaStyle.rose
                : BerandaStyle.rose.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              ikon,
              color: dipilih ? BerandaStyle.rose : BerandaStyle.teksRedup,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.maroon,
                    ),
                  ),
                  Text(
                    keterangan,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: BerandaStyle.teksRedup,
                    ),
                  ),
                ],
              ),
            ),
            if (dipilih)
              const Icon(
                Icons.check_circle_rounded,
                color: BerandaStyle.rose,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
