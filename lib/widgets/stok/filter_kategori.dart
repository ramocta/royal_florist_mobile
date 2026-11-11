import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../../models/produk_model.dart';
import '../beranda/beranda_style.dart';

class FilterKategori extends StatelessWidget {
  const FilterKategori({
    super.key,
    required this.kategori,
    required this.kategoriTerpilih,
    required this.subTerpilih,
    required this.onPilih,
  });

  final List<Kategori> kategori;
  final Kategori? kategoriTerpilih;
  final SubKategori? subTerpilih;
  final void Function(Kategori?, SubKategori?) onPilih;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _Chip(
            label: 'Semua',
            ikon: Icons.apps_rounded,
            aktif: kategoriTerpilih == null,
            onTap: () => onPilih(null, null),
          ),
          for (final k in kategori) ...[
            const SizedBox(width: 10),
            _chipKategori(k),
          ],
        ],
      ),
    );
  }

  Widget _chipKategori(Kategori k) {
    final aktif = kategoriTerpilih?.id == k.id;
    final label = aktif && subTerpilih != null ? subTerpilih!.nama : k.nama;

    if (k.subs.isEmpty) {
      return _Chip(label: label, aktif: aktif, onTap: () => onPilih(k, null));
    }

    return PopupMenuButton<int>(
      offset: const Offset(0, 46),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (id) =>
          onPilih(k, id == -1 ? null : k.subs.firstWhere((s) => s.id == id)),
      itemBuilder: (_) => [
        PopupMenuItem(value: -1, child: Text('Semua ${k.nama}')),
        for (final s in k.subs) PopupMenuItem(value: s.id, child: Text(s.nama)),
      ],
      child: _Chip(label: label, aktif: aktif, dropdown: true),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.aktif,
    this.ikon,
    this.dropdown = false,
    this.onTap,
  });

  final String label;
  final bool aktif;
  final IconData? ikon;
  final bool dropdown;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final warna = aktif ? Colors.white : AppColors.maroon;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: aktif
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [BerandaStyle.rose, Color(0xFF9E1F48)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: BerandaStyle.rose.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              )
            : BerandaStyle.kartu(radius: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (ikon != null) ...[
              Icon(ikon, size: 16, color: warna),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: warna,
              ),
            ),
            if (dropdown)
              Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: warna),
          ],
        ),
      ),
    );
  }
}
