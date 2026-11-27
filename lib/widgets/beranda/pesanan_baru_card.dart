import 'package:flutter/material.dart';

import 'beranda_style.dart';

class PesananBaruCard extends StatelessWidget {
  const PesananBaruCard({
    super.key,
    required this.pesanan,
    required this.stokHabis,
    required this.stokMenipis,
    required this.onTap,
  });

  final int pesanan;
  final int stokHabis;
  final int stokMenipis;
  final VoidCallback onTap;

  int get _total => pesanan + stokHabis + stokMenipis;

  /// Contoh: "9 pesanan baru • 2 stok habis • 3 stok menipis"
  String get _ringkas => [
    if (pesanan > 0) '$pesanan pesanan baru',
    if (stokHabis > 0) '$stokHabis stok habis',
    if (stokMenipis > 0) '$stokMenipis stok menipis',
  ].join(' • ');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFD9446F), Color(0xFFB02A52)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: BerandaStyle.rose.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifikasi ($_total)',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _ringkas,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
