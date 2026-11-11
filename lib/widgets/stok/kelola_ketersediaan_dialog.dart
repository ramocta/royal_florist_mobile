import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/produk_model.dart';
import '../../providers/stok_provider.dart';
import 'dialog_kelola.dart';

class KelolaKetersediaanDialog extends StatefulWidget {
  const KelolaKetersediaanDialog({super.key, required this.produk});

  final Produk produk;

  @override
  State<KelolaKetersediaanDialog> createState() =>
      _KelolaKetersediaanDialogState();
}

class _KelolaKetersediaanDialogState extends State<KelolaKetersediaanDialog> {
  late bool _tersedia = widget.produk.tersedia;
  bool _menyimpan = false;
  String? _error;

  Future<void> _simpan() async {
    setState(() {
      _menyimpan = true;
      _error = null;
    });
    final err = await context.read<StokProvider>().setTersedia(
      widget.produk,
      _tersedia,
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
    final sekarang = widget.produk.tersedia;
    return DialogKelola(
      judul: 'Kelola Ketersediaan',
      subjudul: widget.produk.nama,
      info: 'Ketersediaan akan diperbarui secara real-time di web admin dan katalog pelanggan.',
      menyimpan: _menyimpan,
      error: _error,
      onSimpan: _simpan,
      isi: [
        RingkasanProduk(
          produk: widget.produk,
          label: 'Status Saat Ini',
          nilai: TextSpan(
            text: sekarang ? 'Tersedia' : 'Tidak tersedia',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: sekarang
                  ? const Color(0xFF1E7A34)
                  : const Color(0xFFB3261E),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _Pilihan(
                teks: 'Tersedia',
                ikon: Icons.check_circle_rounded,
                warna: const Color(0xFF1E7A34),
                dipilih: _tersedia,
                onTap: () => setState(() => _tersedia = true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Pilihan(
                teks: 'Tidak tersedia',
                ikon: Icons.cancel_rounded,
                warna: const Color(0xFFB3261E),
                dipilih: !_tersedia,
                onTap: () => setState(() => _tersedia = false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Pilihan extends StatelessWidget {
  const _Pilihan({
    required this.teks,
    required this.ikon,
    required this.warna,
    required this.dipilih,
    required this.onTap,
  });

  final String teks;
  final IconData ikon;
  final Color warna;
  final bool dipilih;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: dipilih ? warna : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: warna.withValues(alpha: dipilih ? 1 : 0.35),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(ikon, color: dipilih ? Colors.white : warna, size: 26),
            const SizedBox(height: 6),
            Text(
              teks,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: dipilih ? Colors.white : warna,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
