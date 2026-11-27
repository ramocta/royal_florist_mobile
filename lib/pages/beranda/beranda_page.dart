import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_provider.dart';
import '../../models/beranda_model.dart';
import '../../providers/beranda_provider.dart';
import '../../widgets/beranda/beranda_header.dart';
import '../../widgets/beranda/beranda_style.dart';
import '../../widgets/beranda/grafik_penjualan.dart';
import '../../widgets/beranda/info_hari_ini_card.dart';
import '../../widgets/beranda/menu_cepat.dart';
import '../../widgets/beranda/muncul.dart';
import '../../widgets/beranda/notifikasi_dialog.dart';
import '../../widgets/beranda/pesanan_baru_card.dart';
import '../../widgets/beranda/salam_card.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../widgets/common/latar_pink.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  late final BerandaProvider _p;

  @override
  void initState() {
    super.initState();
    _p = context.read<BerandaProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _p.mulai());
  }

  @override
  void dispose() {
    _p.berhenti();
    super.dispose();
  }

  void _ke(String route) => Navigator.pushReplacementNamed(context, route);

  @override
  Widget build(BuildContext context) {
    final p = context.watch<BerandaProvider>();
    final d = p.data;

    final namaLogin = context.watch<AuthProvider>().user?.nama;
    final nama = d.namaUser.isNotEmpty ? d.namaUser : (namaLogin ?? 'Karyawan');

    void bukaNotif() => tampilkanNotifikasiDialog(
      context,
      pesanan: d.pesananBaru,
      onLihatSemua: () => _ke('/status-order'),
    );

    return Scaffold(
      backgroundColor: BerandaStyle.latarBawah,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: LatarPink(
        child: SafeArea(
          child: p.loading && d.grafik.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: BerandaStyle.rose),
                )
              : RefreshIndicator(
                  color: BerandaStyle.rose,
                  onRefresh: () => p.muat(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    children: [
                      Muncul(
                        key: const ValueKey('header'),
                        child: BerandaHeader(
                          jumlahNotif: d.pesananBaru.length,
                          onNotif: bukaNotif,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Muncul(
                        key: const ValueKey('salam'),
                        urutan: 1,
                        child: SalamCard(nama: nama),
                      ),
                      if (d.pesananBaru.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Muncul(
                          key: const ValueKey('baru'),
                          urutan: 1,
                          child: PesananBaruCard(
                            jumlah: d.pesananBaru.length,
                            onTap: bukaNotif,
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      Muncul(
                        key: const ValueKey('menu'),
                        urutan: 2,
                        child: MenuCepat(
                          onUpdateStok: () => _ke('/update-stok'),
                          onStatusOrder: () => _ke('/status-order'),
                          onProfil: () => _ke('/profil'),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Muncul(
                        key: const ValueKey('info'),
                        urutan: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Info Hari Ini',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: BerandaStyle.teksGelap,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: InfoHariIniCard(
                                    judul: 'Total Pesanan',
                                    nilai: d.totalPesananHariIni.toDouble(),
                                    format: (v) => v.round().toString(),
                                    ikon: Icons.show_chart_rounded,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: InfoHariIniCard(
                                    judul: 'Total Pendapatan',
                                    nilai: d.pendapatanHariIni.toDouble(),
                                    format: (v) =>
                                        BerandaModel.rupiah(v.round()),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Muncul(
                        key: const ValueKey('grafik'),
                        urutan: 4,
                        child: GrafikPenjualan(
                          data: d.grafik,
                          tanggal: d.tanggal ?? DateTime.now(),
                          onPilihTanggal: p.ubahTanggal,
                          onHariIni: p.tanggalDipilih == null
                              ? null
                              : p.kembaliKeHariIni,
                        ),
                      ),
                      if (p.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            'Gagal memuat data: ${p.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
