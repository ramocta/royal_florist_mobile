// Kartu satu produk + tombol Tersedia/Tidak

import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../common/asset_icon.dart';

/// Kartu produk. Dua mode:
/// - [ProdukCard.stok]         : nama + "Stok Tangkai = N" + tombol edit
/// - [ProdukCard.ketersediaan] : nama + tombol Tersedia / Tidak
class ProdukCard extends StatelessWidget {
  const ProdukCard.stok({
    super.key,
    required this.nama,
    required this.gambar,
    required int this.stok,
    this.onEdit,
  })  : tersedia = null,
        onTersedia = null,
        onTidak = null;

  const ProdukCard.ketersediaan({
    super.key,
    required this.nama,
    required this.gambar,
    required bool this.tersedia,
    this.onTersedia,
    this.onTidak,
  })  : stok = null,
        onEdit = null;

  final String nama;
  final String gambar;
  final int? stok;
  final bool? tersedia;
  final VoidCallback? onEdit;
  final VoidCallback? onTersedia;
  final VoidCallback? onTidak;

  bool get _modeStok => stok != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 64,
              height: 64,
              color: _modeStok ? AppColors.maroon : AppColors.pinkSoft,
              child: Image.asset(
                gambar,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.local_florist, color: AppColors.white),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: _modeStok ? _infoStok() : _infoKetersediaan()),
          if (_modeStok)
            InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: AssetIcon('assets/icons/pencil.png', size: 22, fallback: Icons.edit_outlined),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoStok() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(nama, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text('Stok Tangkai = $stok',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.red)),
      ],
    );
  }

  Widget _infoKetersediaan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(nama, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const Text('Apakah barang ini tersedia?',
            style: TextStyle(fontSize: 10, color: AppColors.muted)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _pill('Tersedia', tersedia == true, onTersedia)),
            const SizedBox(width: 8),
            Expanded(child: _pill('Tidak', tersedia == false, onTidak)),
          ],
        ),
      ],
    );
  }

  Widget _pill(String label, bool active, VoidCallback? onTap) {
    return SizedBox(
      height: 30,
      child: Material(
        color: active ? AppColors.maroon : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: AppColors.maroon),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: active ? AppColors.white : AppColors.maroon)),
          ),
        ),
      ),
    );
  }
}