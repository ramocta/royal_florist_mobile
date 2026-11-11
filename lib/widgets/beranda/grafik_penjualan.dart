import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../../models/beranda_model.dart';
import 'beranda_style.dart';

/// Grafik 7 hari dengan data yang sama seperti dashboard admin web.
class GrafikPenjualan extends StatefulWidget {
  const GrafikPenjualan({
    super.key,
    required this.data,
    required this.tanggal,
    required this.onPilihTanggal,
    this.onHariIni,
  });

  final List<PenjualanHarian> data;

  final DateTime tanggal;
  final ValueChanged<DateTime> onPilihTanggal;
  final VoidCallback? onHariIni;

  @override
  State<GrafikPenjualan> createState() => _GrafikPenjualanState();
}

class _GrafikPenjualanState extends State<GrafikPenjualan> {
  int? _dipilih;

  static const _bln = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  static const double _tinggi = 150;

  static const _langkahNyaman = [
    10000,
    20000,
    50000,
    100000,
    200000,
    500000,
    1000000,
    2000000,
    5000000,
    10000000,
    20000000,
    50000000,
  ];

  int _hitungLangkah(int maxData) {
    if (maxData <= 0) return 500000;
    return _langkahNyaman.firstWhere(
      (s) => maxData <= s * 5,
      orElse: () => ((maxData / 5 / 1000000).ceil()) * 1000000,
    );
  }

  String get _rentang {
    final t = widget.tanggal;
    final awal = t.subtract(const Duration(days: 6));
    if (awal.month == t.month && awal.year == t.year) {
      return '${awal.day}–${t.day} ${_bln[t.month - 1]} ${t.year}';
    }
    return '${awal.day} ${_bln[awal.month - 1]} – ${t.day} ${_bln[t.month - 1]} ${t.year}';
  }

  String _singkat(int v) {
    if (v == 0) return '0';
    if (v >= 1000000) {
      final j = v / 1000000;
      return '${j == j.roundToDouble() ? j.round() : j.toStringAsFixed(1)}jt';
    }
    return '${v ~/ 1000}rb';
  }

  double _tinggiBatang(int total, int maxY) => total <= 0
      ? 3.0
      : (total / maxY * _tinggi).clamp(4.0, _tinggi).toDouble();

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final int maxData = data.isEmpty
        ? 0
        : data.map((e) => e.total).reduce((a, b) => a > b ? a : b);

    final int langkah = _hitungLangkah(maxData);
    final int maxY = langkah * 5;
    final int n = data.length;
    final int? dipilih = (_dipilih != null && _dipilih! < n) ? _dipilih : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BerandaStyle.kartu(radius: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grafik Penjualan',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: BerandaStyle.teksGelap,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  final sekarang = DateTime.now();
                  final batas = widget.tanggal.isAfter(sekarang)
                      ? widget.tanggal
                      : sekarang;
                  final p = await showDatePicker(
                    context: context,
                    initialDate: widget.tanggal,
                    firstDate: DateTime(2024),
                    lastDate: batas,
                  );
                  if (p != null) widget.onPilihTanggal(p);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: BerandaStyle.rose.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _rentang,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.maroon,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: AppColors.maroon,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (widget.onHariIni != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.onHariIni,
                icon: const Icon(Icons.today_rounded, size: 14),
                label: const Text(
                  'Kembali ke hari ini',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: BerandaStyle.rose,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
          const SizedBox(height: 26),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                height: _tinggi,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    for (int i = 0; i <= 5; i++)
                      Positioned(
                        right: 6,
                        bottom: _tinggi * i / 5 - 6,
                        child: Text(
                          _singkat(langkah * i),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9,
                            color: BerandaStyle.teksRedup,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: _tinggi,
                      child: LayoutBuilder(
                        builder: (context, c) {
                          final w = c.maxWidth;
                          final slot = n == 0 ? w : w / n;
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              for (int i = 0; i <= 5; i++)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: _tinggi * i / 5,
                                  child: Container(
                                    height: 1,
                                    color: BerandaStyle.rose.withValues(
                                      alpha: 0.14,
                                    ),
                                  ),
                                ),
                              Positioned.fill(
                                child: Row(
                                  children: [
                                    for (int i = 0; i < n; i++)
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () => setState(
                                            () => _dipilih = _dipilih == i
                                                ? null
                                                : i,
                                          ),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: TweenAnimationBuilder<double>(
                                              tween: Tween<double>(
                                                begin: 0,
                                                end: _tinggiBatang(
                                                  data[i].total,
                                                  maxY,
                                                ),
                                              ),
                                              duration: const Duration(
                                                milliseconds: 700,
                                              ),
                                              curve: Curves.easeOutCubic,
                                              builder: (context, h, _) => Stack(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    width: 24,
                                                    height: h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                      gradient:
                                                          const LinearGradient(
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                            colors: [
                                                              BerandaStyle.rose,
                                                              BerandaStyle
                                                                  .roseSoft,
                                                            ],
                                                          ),
                                                      boxShadow: dipilih == i
                                                          ? [
                                                              BoxShadow(
                                                                color: BerandaStyle
                                                                    .rose
                                                                    .withValues(
                                                                      alpha:
                                                                          0.35,
                                                                    ),
                                                                blurRadius: 10,
                                                              ),
                                                            ]
                                                          : null,
                                                    ),
                                                  ),
                                                  if (data[i].total > 0 &&
                                                      dipilih != i)
                                                    Positioned(
                                                      bottom: h + 3,
                                                      child: Text(
                                                        _singkat(data[i].total),
                                                        style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              AppColors.maroon,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (dipilih != null)
                                Positioned(
                                  left: (slot * dipilih + slot / 2 - 40)
                                      .clamp(0.0, math.max(0.0, w - 80))
                                      .toDouble(),
                                  bottom:
                                      _tinggiBatang(data[dipilih].total, maxY) +
                                      8,
                                  width: 80,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.maroon,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        BerandaModel.rupiah(
                                          data[dipilih].total,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (final d in data)
                          Expanded(
                            child: Text(
                              d.label,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: BerandaStyle.teksGelap,
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
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Ketuk batang untuk melihat nominal',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 9,
                color: BerandaStyle.teksRedup,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
