import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../../models/beranda_model.dart';
import '../../models/produk_model.dart';
import '../stok/produk_foto.dart';
import 'beranda_style.dart';

const Color _merahStok = Color(0xFFB3261E);
const Color _oranyeStok = Color(0xFFD97706);

/// Pop up notifikasi beranda: pesanan baru + stok habis + stok menipis.
Future<void> tampilkanNotifikasiDialog(
  BuildContext context, {
  required List<PesananBaruItem> pesanan,
  required List<Produk> stokHabis,
  required List<Produk> stokMenipis,
  required VoidCallback onLihatPesanan,
  required VoidCallback onLihatStok,
}) {
  final total = pesanan.length + stokHabis.length + stokMenipis.length;

  return showDialog(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.75,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: BerandaStyle.rose.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: BerandaStyle.rose,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notifikasi',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.maroon,
                          ),
                        ),
                        Text(
                          total == 0
                              ? 'Belum ada pemberitahuan'
                              : '$total pemberitahuan',
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
              const SizedBox(height: 4),
              Flexible(
                child: total == 0
                    ? const _Kosong()
                    : ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: [
                          if (pesanan.isNotEmpty)
                            _Bagian(
                              judul: 'Pesanan Baru',
                              keterangan: 'perlu dikonfirmasi',
                              warna: BerandaStyle.rose,
                              ikon: Icons.shopping_bag_outlined,
                              aksi: 'Lihat Pesanan',
                              onAksi: () {
                                Navigator.pop(ctx);
                                onLihatPesanan();
                              },
                              baris: [
                                for (final o in pesanan)
                                  _Baris(
                                    awal: const Icon(
                                      Icons.local_florist,
                                      color: AppColors.maroon,
                                    ),
                                    judul: o.kode,
                                    sub: o.pelanggan,
                                  ),
                              ],
                            ),
                          if (stokHabis.isNotEmpty)
                            _Bagian(
                              judul: 'Stok Habis',
                              keterangan: 'perlu diperbarui',
                              warna: _merahStok,
                              ikon: Icons.remove_circle_outline_rounded,
                              aksi: 'Update Stok',
                              onAksi: () {
                                Navigator.pop(ctx);
                                onLihatStok();
                              },
                              baris: [
                                for (final p in stokHabis)
                                  _Baris(
                                    awal: ProdukFoto(
                                      url: p.fotoUrl,
                                      lebar: 40,
                                      radius: 10,
                                    ),
                                    judul: p.nama,
                                    sub: p.pakaiStok
                                        ? 'Stok habis'
                                        : 'Tidak tersedia',
                                    warnaSub: _merahStok,
                                  ),
                              ],
                            ),
                          if (stokMenipis.isNotEmpty)
                            _Bagian(
                              judul: 'Stok Menipis',
                              keterangan: 'segera tambah stok',
                              warna: _oranyeStok,
                              ikon: Icons.warning_amber_rounded,
                              aksi: 'Update Stok',
                              onAksi: () {
                                Navigator.pop(ctx);
                                onLihatStok();
                              },
                              baris: [
                                for (final p in stokMenipis)
                                  _Baris(
                                    awal: ProdukFoto(
                                      url: p.fotoUrl,
                                      lebar: 40,
                                      radius: 10,
                                    ),
                                    judul: p.nama,
                                    sub: 'Sisa ${p.stok}',
                                    warnaSub: _oranyeStok,
                                  ),
                              ],
                            ),
                        ],
                      ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.maroon,
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _Kosong extends StatelessWidget {
  const _Kosong();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: Text(
          'Semua aman. Tidak ada pesanan baru dan stok masih cukup.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: BerandaStyle.teksRedup,
          ),
        ),
      ),
    );
  }
}

class _Bagian extends StatelessWidget {
  const _Bagian({
    required this.judul,
    required this.keterangan,
    required this.warna,
    required this.ikon,
    required this.aksi,
    required this.onAksi,
    required this.baris,
  });

  final String judul;
  final String keterangan;
  final Color warna;
  final IconData ikon;
  final String aksi;
  final VoidCallback onAksi;
  final List<_Baris> baris;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: warna.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(ikon, size: 16, color: warna),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$judul (${baris.length})',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: warna,
                      ),
                    ),
                    TextSpan(
                      text: '  $keterangan',
                      style: const TextStyle(
                        fontSize: 11,
                        color: BerandaStyle.teksRedup,
                      ),
                    ),
                  ],
                ),
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: warna,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: onAksi,
              child: Text(
                aksi,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        for (var i = 0; i < baris.length; i++) ...[
          if (i > 0) const Divider(height: 1),
          baris[i],
        ],
        const SizedBox(height: 4),
      ],
    );
  }
}

class _Baris extends StatelessWidget {
  const _Baris({
    required this.awal,
    required this.judul,
    required this.sub,
    this.warnaSub = BerandaStyle.teksRedup,
  });

  final Widget awal;
  final String judul;
  final String sub;
  final Color warnaSub;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 40, child: Center(child: awal)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: warnaSub,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
