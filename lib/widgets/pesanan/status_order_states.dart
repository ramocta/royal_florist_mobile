import 'package:flutter/material.dart';

import 'status_order_style.dart';

/// Indikator loading daftar pesanan.
class StatusOrderLoading extends StatelessWidget {
  const StatusOrderLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 60),
      child: Center(
        child: CircularProgressIndicator(color: StatusOrderStyle.maroon),
      ),
    );
  }
}

/// Tampilan saat gagal memuat pesanan.
class StatusOrderError extends StatelessWidget {
  const StatusOrderError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: StatusOrderStyle.pagePadding,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: StatusOrderStyle.shadow,
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 44, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat pesanan',
              style: TextStyle(
                color: StatusOrderStyle.maroon,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: StatusOrderStyle.muted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: StatusOrderStyle.maroon,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tampilan saat belum ada pesanan.
class StatusOrderEmpty extends StatelessWidget {
  const StatusOrderEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: StatusOrderStyle.pagePadding,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: StatusOrderStyle.shadow,
        ),
        child: const Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 56,
              color: StatusOrderStyle.rose,
            ),
            SizedBox(height: 12),
            Text(
              'Belum ada pesanan',
              style: TextStyle(
                color: StatusOrderStyle.maroon,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Pesanan pelanggan akan muncul di sini.',
              style: TextStyle(color: StatusOrderStyle.muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
