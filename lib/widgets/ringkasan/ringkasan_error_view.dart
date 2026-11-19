import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../beranda/beranda_style.dart';

class RingkasanErrorView extends StatelessWidget {
  const RingkasanErrorView({super.key, required this.pesan, required this.onCoba});

  final String pesan;
  final VoidCallback onCoba;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: BerandaStyle.rose.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 12),
            Text(
              pesan,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: BerandaStyle.teksRedup,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onCoba,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.maroon,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Coba lagi', style: TextStyle(fontFamily: 'Poppins')),
            ),
          ],
        ),
      ),
    );
  }
}