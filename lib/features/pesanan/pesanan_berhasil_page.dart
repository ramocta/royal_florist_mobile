import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class PesananBerhasilPage extends StatelessWidget {
  final String invoice;
  final String nama;
  final String total;
  final String status;

  /// Dipanggil saat tombol "Cetak Struk" ditekan.
  final VoidCallback? onCetakStruk;

  const PesananBerhasilPage({
    super.key,
    this.invoice = 'INV-20261004-001',
    this.nama = 'Siti Maisyaroh',
    this.total = 'Rp75.000',
    this.status = 'Dikonfirmasi',
    this.onCetakStruk,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/kelopak.png',
              fit: BoxFit.fitWidth,
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
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Pesanan berhasil\n${status.toLowerCase()}!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.title,
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
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6B5B5E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Total:', style: TextStyle(fontSize: 15)),
                  Text(
                    total,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (onCetakStruk != null) {
                          onCetakStruk!();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Membuka struk...')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.maroon,
                        foregroundColor: Colors.white,
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
                      onPressed: () => Navigator.popUntil(
                        context,
                        (route) => route.isFirst,
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