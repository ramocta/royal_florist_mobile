import 'package:flutter/material.dart';

import '../../models/ringkasan_model.dart';
import '../beranda/beranda_style.dart';
import 'ringkasan_tema.dart';

class RingkasanStatCard extends StatelessWidget {
  const RingkasanStatCard({super.key, required this.item});

  final RingkasanCardItem item;

  @override
  Widget build(BuildContext context) {
    final aksen = RingkasanTema.aksenCard(item.key);
    final warnaTrend = RingkasanTema.warnaTrend(item.key, item.trend);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BerandaStyle.kartu(radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: BerandaStyle.rose,
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: aksen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(RingkasanTema.ikonCard(item.key), size: 18, color: aksen),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${item.jumlah}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: aksen,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(RingkasanTema.ikonTrend(item.trend), size: 14, color: warnaTrend),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.perubahanLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: warnaTrend,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}