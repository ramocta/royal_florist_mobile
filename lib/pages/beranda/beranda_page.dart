// Figma: Beranda
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/beranda/grafik_penjualan.dart';
import '../../widgets/beranda/info_hari_ini_card.dart';
import '../../widgets/common/asset_icon.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  // TODO: ganti dengan data dari ringkasan_provider / pesanan_provider
  static const _jumlahPesananBaru = 2;
  static const _totalPesanan = '2';
  static const _totalPendapatan = 'Rp 200.000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(15, 12, 15, 24),
          children: [
            _HeaderCard(onBellTap: () {
              // TODO: showDialog(context: context, builder: (_) => const NotifikasiDialog());
            }),
            const SizedBox(height: 16),
            _PesananBaruCard(
              jumlah: _jumlahPesananBaru,
              onTap: () => Navigator.of(context).pushNamed('/status-order'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MenuTile(
                    label: 'Update Stok',
                    asset: 'assets/icons/stok-icon.png',
                    fallback: Icons.inventory_2_outlined,
                    onTap: () => Navigator.of(context).pushNamed('/update-stok'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MenuTile(
                    label: 'Status Order',
                    asset: 'assets/icons/order-icon.png',
                    fallback: Icons.receipt_long_outlined,
                    onTap: () => Navigator.of(context).pushNamed('/status-order'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MenuTile(
                    label: 'Profil',
                    asset: 'assets/icons/profiil-icon.png',
                    fallback: Icons.person_outline,
                    onTap: () => Navigator.of(context).pushNamed('/profil'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const InfoHariIniCard(
              totalPesanan: _totalPesanan,
              totalPendapatan: _totalPendapatan,
            ),
            const SizedBox(height: 16),
            const GrafikPenjualan(),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({this.onBellTap});
  final VoidCallback? onBellTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.maroon,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: 165,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
        decoration: BoxDecoration(
          color: AppColors.pinkCard,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Halo, Karyawan',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  SizedBox(height: 2),
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text('Selamat bekerja!',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: onBellTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: AssetIcon('assets/icons/lonceng1.png',
                      size: 22, fallback: Icons.notifications),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PesananBaruCard extends StatelessWidget {
  const _PesananBaruCard({required this.jumlah, this.onTap});
  final int jumlah;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.pinkSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: AssetIcon('assets/icons/lonceng.png',
                      size: 24, fallback: Icons.notifications),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pesanan Baru ($jumlah)',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    Text('Ada $jumlah pesanan yang perlu dikonfirmasi',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.muted)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.label,
    required this.asset,
    required this.fallback,
    this.onTap,
  });

  final String label;
  final String asset;
  final IconData fallback;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AssetIcon(asset, size: 32, fallback: fallback),
              const SizedBox(height: 8),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink)),
            ],
          ),
        ),
      ),
    );
  }
}
