import 'package:flutter/material.dart';

import '../../models/ringkasan_model.dart';
import '../beranda/beranda_style.dart';
import 'ringkasan_tema.dart';
import 'status_badge.dart';

class PesananItemTile extends StatelessWidget {
  const PesananItemTile({super.key, required this.item, this.onTap});

  final PesananTerbaruItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final warna = RingkasanTema.warnaStatus(item.status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: warna.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(RingkasanTema.ikonStatus(item.status), size: 22, color: warna),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.noInvoice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: BerandaStyle.teksGelap,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.pelanggan} • ${item.jam}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.5,
                      color: BerandaStyle.teksRedup,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StatusBadge(status: item.status, label: item.statusLabel),
          ],
        ),
      ),
    );
  }
}