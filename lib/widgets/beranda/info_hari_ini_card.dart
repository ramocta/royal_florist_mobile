import 'package:flutter/material.dart';

import 'beranda_style.dart';

class InfoHariIniCard extends StatelessWidget {
  const InfoHariIniCard({
    super.key,
    required this.judul,
    required this.nilai,
    required this.format,
    this.ikon,
  });

  final String judul;
  final double nilai;
  final String Function(double) format;
  final IconData? ikon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BerandaStyle.kartu(radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: BerandaStyle.rose,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: nilai),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, v, _) => FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      format(v),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: BerandaStyle.teksGelap,
                      ),
                    ),
                  ),
                ),
              ),
              if (ikon != null)
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: BerandaStyle.rose.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(ikon, color: BerandaStyle.rose, size: 20),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
