import 'package:flutter/material.dart';

import '../../models/ringkasan_model.dart';
import 'ringkasan_stat_card.dart';

/// Grid 2 kolom untuk kartu statistik. Tinggi tiap baris menyesuaikan isi
/// (aman untuk ukuran font besar).
class RingkasanStatGrid extends StatelessWidget {
  const RingkasanStatGrid({super.key, required this.cards});

  final List<RingkasanCardItem> cards;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        for (int i = 0; i < cards.length; i += 2) ...[
          if (i > 0) const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: RingkasanStatCard(item: cards[i])),
                const SizedBox(width: 12),
                Expanded(
                  child: i + 1 < cards.length
                      ? RingkasanStatCard(item: cards[i + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}