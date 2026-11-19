import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../../models/ringkasan_model.dart';
import '../beranda/beranda_style.dart';
import 'pesanan_item_tile.dart';

class PesananTerbaruCard extends StatelessWidget {
  const PesananTerbaruCard({
    super.key,
    required this.items,
    this.onLihatSemua,
    this.onTapItem,
  });

  final List<PesananTerbaruItem> items;
  final VoidCallback? onLihatSemua;
  final ValueChanged<PesananTerbaruItem>? onTapItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BerandaStyle.kartu(radius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Pesanan Terbaru',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.maroon,
                  ),
                ),
              ),
              InkWell(
                onTap: onLihatSemua,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Text(
                    'Lihat Semua ›',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: BerandaStyle.rose,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Belum ada pesanan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: BerandaStyle.teksRedup,
                  ),
                ),
              ),
            )
          else
            for (int i = 0; i < items.length; i++) ...[
              if (i > 0)
                Divider(
                  height: 1,
                  color: BerandaStyle.rose.withValues(alpha: 0.10),
                ),
              PesananItemTile(
                item: items[i],
                onTap: onTapItem == null ? null : () => onTapItem!(items[i]),
              ),
            ],
        ],
      ),
    );
  }
}