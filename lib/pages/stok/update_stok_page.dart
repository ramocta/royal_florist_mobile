// Figma: Update Stok Barang (semua varian filter/dropdown)
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/common/asset_icon.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../widgets/common/search_filter_bar.dart';
import '../../widgets/stok/produk_card.dart';

class UpdateStokPage extends StatefulWidget {
  const UpdateStokPage({super.key});

  @override
  State<UpdateStokPage> createState() => _UpdateStokPageState();
}

class _UpdateStokPageState extends State<UpdateStokPage> {
  static const _semua = 'Semua';

  // chip filter -> sub-kategori (dropdown)
  static const _filters = {
    'Bucket': ['Bucket Satin', 'Bucket Uang', 'Bucket Snack', 'Bucket Fresh Flower'],
    'Hantaran': ['Hantaran Box Akrilik', 'Hantaran Box Fiber'],
    'Papan Bunga': ['Papan Bunga Kecil', 'Papan Bunga Besar'],
  };

  // TODO: ganti data dummy ini dengan stok_provider / stok_service
  static const _img = 'assets/images';
  static const Map<String, List<_Produk>> _data = {
    _semua: [
      _Produk('Bunga Aster', '$_img/aster.png', stok: 30),
      _Produk('Bunga Lily', '$_img/lily.png', stok: 30),
      _Produk('Bunga Sedap malam', '$_img/sedap-malam.png', stok: 30),
      _Produk('Baby Breath', '$_img/baby-breath.png', stok: 30),
    ],
    'Bucket Satin': [
      _Produk('Bucket Satin Pink', '$_img/bukcet-satin-pink.png'),
      _Produk('Bucket Satin Merah', '$_img/bucket-satin-merah.png'),
      _Produk('Bucket Satin Putih', '$_img/bukcet-satin-putih.png'),
    ],
    'Bucket Uang': [
      _Produk('Bucket Uang 5 Lembar', '$_img/bucket-uang1.png'),
      _Produk('Bucket Uang 10 Lembar', '$_img/bucket-uang2.png'),
      _Produk('Bucket Uang 15 Lembar', '$_img/bucket-uang3.png'),
    ],
  };

  String _filter = _semua;
  String? _opsi;
  String _query = '';
  final Map<String, bool> _tersedia = {};

  List<_Produk> get _items {
    final list = _data[_opsi ?? _semua] ?? const <_Produk>[];
    if (_query.isEmpty) return list;
    return list.where((p) => p.nama.toLowerCase().contains(_query.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Update Stok Barang'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: buka NotifikasiDialog
            },
            icon: const AssetIcon('assets/icons/lonceng1.png',
                size: 22, fallback: Icons.notifications),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: Column(
        children: [
          SearchFilterBar(
            filters: _filters,
            selectedFilter: _filter,
            selectedOption: _opsi,
            onSearch: (q) => setState(() => _query = q),
            onFilterSelected: (f, o) => setState(() {
              _filter = f;
              _opsi = o;
            }),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('Belum ada produk',
                        style: TextStyle(fontSize: 13, color: AppColors.muted)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final p = items[i];
                      if (p.stok != null) {
                        return ProdukCard.stok(
                          nama: p.nama,
                          gambar: p.gambar,
                          stok: p.stok!,
                          onEdit: () {
                            // TODO: buka halaman detail_produk_page
                          },
                        );
                      }
                      final ada = _tersedia[p.nama] ?? true;
                      return ProdukCard.ketersediaan(
                        nama: p.nama,
                        gambar: p.gambar,
                        tersedia: ada,
                        onTersedia: () => setState(() => _tersedia[p.nama] = true),
                        onTidak: () => setState(() => _tersedia[p.nama] = false),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _Produk {
  const _Produk(this.nama, this.gambar, {this.stok});
  final String nama;
  final String gambar;
  final int? stok; // null = mode Tersedia/Tidak
}
