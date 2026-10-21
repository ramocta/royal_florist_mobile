// Kartu total pesanan + pendapatan hari ini

import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class InfoHariIniCard extends StatelessWidget {
  const InfoHariIniCard({
    super.key,
    required this.totalPesanan,
    required this.totalPendapatan,
  });

  final String totalPesanan;
  final String totalPendapatan;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Info Hari Ini',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _InfoTile(label: 'Total Pesanan', value: totalPesanan, valueSize: 28)),
            const SizedBox(width: 12),
            Expanded(child: _InfoTile(label: 'Total Pendapatan', value: totalPendapatan, valueSize: 17)),
          ],
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value, required this.valueSize});

  final String label;
  final String value;
  final double valueSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.muted)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value,
                style: TextStyle(
                    fontSize: valueSize, fontWeight: FontWeight.w700, color: AppColors.ink)),
          ),
        ],
      ),
    );
  }
}