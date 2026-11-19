import 'package:flutter/material.dart';

import 'status_order_helper.dart';
import 'status_order_style.dart';

/// Kartu satu pesanan pada daftar Status Order.
class StatusOrderCard extends StatelessWidget {
  const StatusOrderCard({super.key, required this.order, required this.onTap});

  final Map<String, dynamic> order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final invoice = order['no_invoice'] ?? order['invoice'] ?? '-';
    final nama = order['nama_pelanggan'] ?? order['nama'] ?? 'Pelanggan';
    final status =
        StatusOrderHelper.status(order['status_pesanan'] ?? order['status']);
    final tanggal = StatusOrderHelper.tanggal(
      order['dibuat_pada'] ?? order['created_at'],
    );
    final total = StatusOrderHelper.rupiah(StatusOrderHelper.ambilTotal(order));
    final warna = StatusOrderHelper.statusColor(status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: StatusOrderStyle.shadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: StatusOrderStyle.blush,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: StatusOrderStyle.maroon,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        invoice.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF5E1A2E),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: warna.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: warna.shade800,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 16,
                      color: StatusOrderStyle.muted,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        nama.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: StatusOrderStyle.muted,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 15,
                      color: StatusOrderStyle.muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tanggal,
                      style: const TextStyle(
                        color: StatusOrderStyle.muted,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 24,
                  thickness: 1,
                  color: StatusOrderStyle.line,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            color: StatusOrderStyle.muted,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          total,
                          style: const TextStyle(
                            color: StatusOrderStyle.maroon,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: StatusOrderStyle.blush,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Lihat detail',
                            style: TextStyle(
                              color: StatusOrderStyle.maroon,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: StatusOrderStyle.maroon,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
