import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../../models/ringkasan_model.dart';
import '../../services/ringkasan_service.dart';
import '../../widgets/beranda/beranda_header.dart';
import '../../widgets/beranda/beranda_style.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../widgets/common/latar_pink.dart';
import '../../widgets/beranda/muncul.dart';
import '../../widgets/ringkasan/pesanan_terbaru_card.dart';
import '../../widgets/ringkasan/periode_chip.dart';
import '../../widgets/ringkasan/ringkasan_error_view.dart';
import '../../widgets/ringkasan/ringkasan_sapaan_card.dart';
import '../../widgets/ringkasan/ringkasan_stat_grid.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({
    super.key,
    this.jumlahNotif = 0,
    this.onNotif,
    this.onLihatSemua,
  });

  final int jumlahNotif;
  final VoidCallback? onNotif;

  /// Default: buka halaman Status Order.
  final VoidCallback? onLihatSemua;

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final _service = RingkasanService();

  RingkasanModel _data = RingkasanModel.empty();
  bool _loading = true;
  String? _error;
  DateTime? _tanggal; // null = minggu berjalan

  @override
  void initState() {
    super.initState();
    _muat();
  }

  String _format(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _muat({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final hasil = await _service.ambilRingkasan(
        tanggal: _tanggal == null ? null : _format(_tanggal!),
      );
      if (!mounted) return;
      setState(() {
        _data = hasil;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
      if (silent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _pilihMinggu() async {
    final dipilih = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Pilih tanggal dalam minggu yang ingin dilihat',
    );
    if (dipilih == null) return;
    _tanggal = dipilih;
    _muat();
  }

  void _lihatSemua() {
    if (widget.onLihatSemua != null) {
      widget.onLihatSemua!();
    } else {
      Navigator.of(context).pushNamed('/status-order');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BerandaStyle.latarBawah,
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
      body: LatarPink(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: BerandaHeader(
                  jumlahNotif: widget.jumlahNotif,
                  onNotif: widget.onNotif ?? () {},
                ),
              ),
              Expanded(child: _isi()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _isi() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.maroon),
      );
    }

    if (_error != null && _data.cards.isEmpty) {
      return RingkasanErrorView(pesan: _error!, onCoba: _muat);
    }

    return RefreshIndicator(
      color: AppColors.maroon,
      onRefresh: () => _muat(silent: true),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Muncul(
            child: RingkasanSapaanCard(nama: _data.namaUser, role: _data.role),
          ),
          const SizedBox(height: 22),
          Muncul(
            urutan: 1,
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Ringkasan Minggu Ini',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: BerandaStyle.judul,
                    ),
                  ),
                ),
                PeriodeChip(label: _data.periodeLabel, onTap: _pilihMinggu),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Muncul(urutan: 2, child: RingkasanStatGrid(cards: _data.cards)),
          const SizedBox(height: 22),
          Muncul(
            urutan: 3,
            child: PesananTerbaruCard(
              items: _data.pesananTerbaru,
              onLihatSemua: _lihatSemua,
            ),
          ),
        ],
      ),
    );
  }
}