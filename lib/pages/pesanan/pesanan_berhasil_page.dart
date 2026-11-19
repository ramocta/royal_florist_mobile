import 'package:flutter/material.dart';
import '../../core/shared/app_colors.dart';
import 'struk_loader_page.dart';

class PesananBerhasilPage extends StatelessWidget {
  final dynamic idOrder;
  final String invoice;
  final String nama;
  final String total;
  final String status;

  const PesananBerhasilPage({
    super.key,
    this.idOrder,
    this.invoice = 'INV-20261004-001',
    this.nama = 'Siti Maisyaroh',
    this.total = 'Rp75.000',
    this.status = 'Dikonfirmasi',
  });

  void _bukaStruk(BuildContext context) {
    if (idOrder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID pesanan tidak ditemukan')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StrukLoaderPage(idOrder: idOrder)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              'assets/login/bunga_kiri_bawah.png',
              width: 150,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/login/bunga_kanan_bawah.png',
              width: 150,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.maroon,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Pesanan berhasil\n${status.toLowerCase()}!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.maroon,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    invoice,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 15, color: AppColors.ink),
                  ),
                  Text(
                    total,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _bukaStruk(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.maroon,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Cetak Struk',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/status-order',
                        (route) => false,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.maroon,
                        side: const BorderSide(color: AppColors.maroon),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Kembali ke Status Order',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}