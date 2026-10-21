// Grafik batang penjualan (fl_chart)

import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class GrafikPenjualan extends StatelessWidget {
  const GrafikPenjualan({
    super.key,
    this.periode = '16-22 september 2025',
    this.data = const [770000, 890000, 680000, 1120000, 1400000, 1700000, 2000000],
    this.onPeriodeTap,
  });

  final String periode;

  /// Pendapatan Sen..Min (7 nilai).
  final List<double> data;
  final VoidCallback? onPeriodeTap;

  static const _hari = ['Sen', 'Sel', 'Rabu', 'Kam', 'Jum', 'Sab', 'Min'];
  static const double _maxY = 2000000;
  static const double _chartH = 160;
  static const double _labelW = 60;

  static String _fmt(num v) => v
      .toInt()
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');

  @override
  Widget build(BuildContext context) {
    const labelStyle =
        TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.black);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Grafik Penjualan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              InkWell(
                onTap: onPeriodeTap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.pinkSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(periode,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.maroon)),
                      const Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.maroon),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: _chartH + 8,
            child: Row(
              children: [
                // label sumbu Y
                SizedBox(
                  width: _labelW,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      for (var i = 0; i <= 4; i++)
                        Positioned(
                          right: 8,
                          bottom: i / 4 * _chartH - 7,
                          child: Text(i == 0 ? '0' : _fmt(_maxY * i / 4), style: labelStyle),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      for (var i = 0; i <= 4; i++)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: i / 4 * _chartH,
                          child: Container(height: 1, color: AppColors.grey),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (final v in data)
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: 22,
                                  height: (v / _maxY).clamp(0.0, 1.0) * _chartH,
                                  color: AppColors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const SizedBox(width: _labelW),
              for (final h in _hari)
                Expanded(child: Center(child: Text(h, style: labelStyle))),
            ],
          ),
        ],
      ),
    );
  }
}