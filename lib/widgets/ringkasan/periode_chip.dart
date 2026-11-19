import 'package:flutter/material.dart';

import '../beranda/beranda_style.dart';

/// Pill periode minggu (mis. "28 Sep – 04 Okt 2026"), bisa diketuk untuk ganti minggu.
class PeriodeChip extends StatelessWidget {
  const PeriodeChip({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BerandaStyle.rose.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.isEmpty ? 'Pilih minggu' : label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: BerandaStyle.rose,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: BerandaStyle.rose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}