import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import 'beranda_style.dart';
import 'bunga_dekor.dart';

class SalamCard extends StatelessWidget {
  const SalamCard({super.key, this.nama = 'Karyawan'});

  final String nama;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.white, Color(0xFFFFD9E1)],
        ),
        boxShadow: [
          BoxShadow(
            color: BerandaStyle.rose.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            const Positioned(
              right: -16,
              top: -8,
              bottom: -8,
              width: 124,
              child: BungaDekor(),
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 112),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(20, 16, 100, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, $nama',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.maroon,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Selamat bekerja!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: BerandaStyle.teksRedup,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
