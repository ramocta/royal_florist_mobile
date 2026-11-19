import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../beranda/beranda_style.dart';

class RingkasanSapaanCard extends StatelessWidget {
  const RingkasanSapaanCard({super.key, required this.nama, required this.role});

  final String nama;
  final String role;

  @override
  Widget build(BuildContext context) {
    final namaTampil = nama.trim().isEmpty ? 'karyawan' : nama.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BerandaStyle.kartu(radius: 24).copyWith(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, BerandaStyle.roseSoft.withValues(alpha: 0.35)],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -6,
            top: -10,
            child: Icon(
              Icons.local_florist_rounded,
              size: 76,
              color: BerandaStyle.rose.withValues(alpha: 0.18),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ringkasan Pesanan',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.maroon,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Lihat riwayat pesanan secara real-time',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: BerandaStyle.teksRedup,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}