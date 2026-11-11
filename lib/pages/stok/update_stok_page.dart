import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/produk_model.dart';
import '../../providers/stok_provider.dart';
import '../../widgets/beranda/beranda_style.dart';
import '../../widgets/beranda/muncul.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../widgets/common/info_snack.dart';
import '../../widgets/common/latar_pink.dart';
import '../../widgets/stok/filter_kategori.dart';
import '../../widgets/stok/kelola_ketersediaan_dialog.dart';
import '../../widgets/stok/kelola_stok_dialog.dart';
import '../../widgets/stok/konfirmasi_hapus.dart';
import '../../widgets/stok/peringatan_stok_dialog.dart';
import '../../widgets/stok/produk_card.dart';
import '../../widgets/stok/status_filter_sheet.dart';
import '../../widgets/stok/stok_header.dart';
import '../../widgets/stok/stok_search_bar.dart';
import 'detail_produk_page.dart';

class UpdateStokPage extends StatefulWidget {
  const UpdateStokPage({super.key});

  @override
  State<UpdateStokPage> createState() => _UpdateStokPageState();
}

class _UpdateStokPageState extends State<UpdateStokPage> {
  late final StokProvider _p;

  @override
  void initState() {
    super.initState();
    _p = context.read<StokProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _p.mulai());
  }

  @override
  void dispose() {
    _p.berhenti();
    super.dispose();
  }

  Future<void> _kelola(Produk p) async {
    final berhasil = await showDialog<bool>(
      context: context,
      builder: (_) => p.pakaiStok
          ? KelolaStokDialog(produk: p)
          : KelolaKetersediaanDialog(produk: p),
    );
    if (berhasil == true && mounted)
      tampilkanInfo(context, '${p.nama} berhasil diperbarui');
  }

  Future<void> _form([Produk? p]) async {
    final pesan = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => DetailProdukPage(produk: p)),
    );
    if (pesan != null && mounted) tampilkanInfo(context, pesan);
  }

  Future<void> _hapus(Produk p) async {
    if (!await konfirmasiHapus(context, p) || !mounted) return;
    final err = await _p.hapus(p);
    if (!mounted) return;
    tampilkanInfo(context, err ?? '${p.nama} dihapus', galat: err != null);
  }

  Future<void> _filterStatus() async {
    final pilihan = await tampilkanFilterStatus(context, _p.statusFilter);
    if (pilihan != null) _p.ubahStatus(pilihan);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StokProvider>();
    final daftar = p.tampil;

    return Scaffold(
      backgroundColor: BerandaStyle.latarBawah,
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _form,
        backgroundColor: BerandaStyle.rose,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
      ),
      body: LatarPink(
        child: SafeArea(
          child: p.loading && p.semua.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: BerandaStyle.rose),
                )
              : RefreshIndicator(
                  color: BerandaStyle.rose,
                  onRefresh: () => p.muat(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                    children: [
                      Muncul(
                        key: const ValueKey('header'),
                        child: StokHeader(
                          jumlahPeringatan: p.produkHabis.length,
                          onKembali: () => Navigator.pushReplacementNamed(
                            context,
                            '/beranda',
                          ),
                          onNotif: () =>
                              tampilkanPeringatanStok(context, p.produkHabis),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Muncul(
                        key: const ValueKey('cari'),
                        urutan: 1,
                        child: StokSearchBar(
                          onUbah: p.cari,
                          onFilter: _filterStatus,
                          filterAktif: p.filterAktif,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Muncul(
                        key: const ValueKey('kategori'),
                        urutan: 2,
                        child: FilterKategori(
                          kategori: p.kategori,
                          kategoriTerpilih: p.kategoriTerpilih,
                          subTerpilih: p.subTerpilih,
                          onPilih: p.pilihKategori,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (daftar.isEmpty)
                        const _Kosong()
                      else
                        for (final produk in daftar)
                          Padding(
                            key: ValueKey(produk.id),
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ProdukCard(
                              produk: produk,
                              onKelola: () => _kelola(produk),
                              onEdit: () => _form(produk),
                              onHapus: () => _hapus(produk),
                            ),
                          ),
                      if (p.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
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

class _Kosong extends StatelessWidget {
  const _Kosong();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            Icons.local_florist_outlined,
            size: 48,
            color: BerandaStyle.roseSoft,
          ),
          SizedBox(height: 8),
          Text(
            'Belum ada produk',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: BerandaStyle.teksRedup,
            ),
          ),
        ],
      ),
    );
  }
}
