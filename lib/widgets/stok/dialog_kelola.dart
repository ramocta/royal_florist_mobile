import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../../models/produk_model.dart';
import '../beranda/beranda_style.dart';
import 'produk_foto.dart';

class DialogKelola extends StatelessWidget {
  const DialogKelola({
    super.key,
    required this.judul,
    required this.subjudul,
    required this.info,
    required this.isi,
    required this.onSimpan,
    required this.menyimpan,
    this.error,
  });

  final String judul;
  final String subjudul;
  final String info;
  final List<Widget> isi;
  final VoidCallback onSimpan;
  final bool menyimpan;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF3F6), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          judul,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.maroon,
                          ),
                        ),
                        Text(
                          subjudul,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: BerandaStyle.teksRedup,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: menyimpan ? null : () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(17),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: BerandaStyle.rose.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: AppColors.maroon,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...isi,
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BerandaStyle.rose.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_rounded,
                      size: 18,
                      color: BerandaStyle.rose,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        info,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFB3261E),
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.maroon,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: menyimpan
                          ? null
                          : () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.maroon,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: menyimpan ? null : onSimpan,
                      icon: menyimpan
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_outlined, size: 18),
                      label: const Text('Simpan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RingkasanProduk extends StatelessWidget {
  const RingkasanProduk({
    super.key,
    required this.produk,
    required this.label,
    required this.nilai,
  });

  final Produk produk;
  final String label;
  final InlineSpan nilai;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProdukFoto(url: produk.fotoUrl, lebar: 84, radius: 16),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BerandaStyle.kartu(radius: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(nilai),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
