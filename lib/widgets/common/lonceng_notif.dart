import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../beranda/beranda_style.dart';

class LoncengNotif extends StatelessWidget {
  const LoncengNotif({super.key, required this.jumlah, required this.onTap});

  final int jumlah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 46,
        height: 46,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BerandaStyle.kartu(radius: 22),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.maroon,
              ),
            ),
            if (jumlah > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      jumlah > 9 ? '9+' : '$jumlah',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
