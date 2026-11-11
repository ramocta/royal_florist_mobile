import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../beranda/beranda_style.dart';
import '../beranda/bunga_dekor.dart';
import '../common/lonceng_notif.dart';

class StokHeader extends StatelessWidget {
  const StokHeader({
    super.key,
    required this.jumlahPeringatan,
    required this.onKembali,
    required this.onNotif,
  });

  final int jumlahPeringatan;
  final VoidCallback onKembali;
  final VoidCallback onNotif;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onKembali,
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
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_florist_outlined,
                    size: 28,
                    color: BerandaStyle.rose,
                  ),
                  SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Royal Florist',
                        style: TextStyle(
                          fontFamily: 'CormorantGaramond',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.maroon,
                          height: 1,
                        ),
                      ),
                      Text(
                        'Fresh Flower • Special Moment',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 8,
                          color: BerandaStyle.teksRedup,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            LoncengNotif(jumlah: jumlahPeringatan, onTap: onNotif),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 118,
          child: Stack(
            children: [
              const Positioned(
                right: -16,
                top: -6,
                bottom: -6,
                width: 130,
                child: BungaDekor(),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 110),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Update Stok Barang',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.maroon,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kelola stok bunga dengan mudah dan real-time.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: BerandaStyle.teksGelap.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
