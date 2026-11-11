import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../../models/produk_model.dart';
import '../beranda/beranda_style.dart';
import 'produk_foto.dart';

class ProdukCard extends StatelessWidget {
  const ProdukCard({
    super.key,
    required this.produk,
    required this.onKelola,
    required this.onEdit,
    required this.onHapus,
  });

  final Produk produk;
  final VoidCallback onKelola;
  final VoidCallback onEdit;
  final VoidCallback onHapus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BerandaStyle.kartu(radius: 22),
      child: Row(
        children: [
          Stack(
            children: [
              ProdukFoto(url: produk.fotoUrl, lebar: 92),
              const Positioned(top: 6, left: 6, child: _Lencana()),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produk.nama,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.maroon,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _Pil(produk.kategori),
                    if (!produk.aktif) const _Pil('Nonaktif', abu: true),
                  ],
                ),
                const SizedBox(height: 8),
                produk.pakaiStok
                    ? _Stok(produk.stok)
                    : _Ketersediaan(produk.tersedia),
              ],
            ),
          ),
          Column(
            children: [
              Material(
                color: BerandaStyle.rose.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: onKelola,
                  child: const SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(Icons.edit_outlined, color: BerandaStyle.rose),
                  ),
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: BerandaStyle.teksRedup,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onSelected: (v) => v == 'edit' ? onEdit() : onHapus(),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit produk')),
                  PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Lencana extends StatelessWidget {
  const _Lencana();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: BerandaStyle.rose,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.local_florist_rounded,
        size: 14,
        color: Colors.white,
      ),
    );
  }
}

class _Pil extends StatelessWidget {
  const _Pil(this.teks, {this.abu = false});

  final String teks;
  final bool abu;

  @override
  Widget build(BuildContext context) {
    final warna = abu ? Colors.grey.shade600 : BerandaStyle.rose;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        teks,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: warna,
        ),
      ),
    );
  }
}

class _Stok extends StatelessWidget {
  const _Stok(this.stok);

  final int stok;

  @override
  Widget build(BuildContext context) {
    final warna = stok > 0 ? BerandaStyle.rose : const Color(0xFFB3261E);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 13,
              color: BerandaStyle.teksRedup,
            ),
            SizedBox(width: 4),
            Text(
              'Stok Tersedia',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: BerandaStyle.teksRedup,
              ),
            ),
          ],
        ),
        Text.rich(
          TextSpan(
            text: '$stok',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: warna,
            ),
            children: const [
              TextSpan(
                text: ' Tangkai',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Ketersediaan extends StatelessWidget {
  const _Ketersediaan(this.tersedia);

  final bool tersedia;

  @override
  Widget build(BuildContext context) {
    final warna = tersedia ? const Color(0xFF1E7A34) : const Color(0xFFB3261E);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ketersediaan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: BerandaStyle.teksRedup,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: warna.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                tersedia ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 16,
                color: warna,
              ),
              const SizedBox(width: 5),
              Text(
                tersedia ? 'Tersedia' : 'Tidak tersedia',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: warna,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
