import 'package:flutter/material.dart';

import '../../services/pesanan_service.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../widgets/pesanan/status_order_banner.dart';
import '../../widgets/pesanan/status_order_card.dart';
import '../../widgets/pesanan/status_order_filters.dart';
import '../../widgets/pesanan/status_order_header.dart';
import '../../widgets/pesanan/status_order_helper.dart';
import '../../widgets/pesanan/status_order_search.dart';
import '../../widgets/pesanan/status_order_states.dart';
import '../../widgets/pesanan/status_order_style.dart';
import 'detail_pesanan_page.dart';

class StatusOrderPage extends StatefulWidget {
  const StatusOrderPage({super.key});

  @override
  State<StatusOrderPage> createState() => _StatusOrderPageState();
}

class _StatusOrderPageState extends State<StatusOrderPage> {
  final PesananService _service = PesananService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _pesanan = [];
  bool _loading = true;
  String? _error;
  String _filter = 'Semua';

  final List<String> _filters = [
    'Semua',
    'Menunggu Pembayaran',
    'Menunggu Konfirmasi',
    'Dikonfirmasi',
    'Diproses',
    'Dalam Pengiriman',
    'Siap Diambil',
    'Selesai',
    'Dibatalkan',
  ];

  @override
  void initState() {
    super.initState();
    _loadPesanan();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPesanan() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _service.getPesanan();
      if (!mounted) return;
      setState(() {
        _pesanan = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredOrders {
    final keyword = _searchController.text.toLowerCase();

    return _pesanan.where((order) {
      final invoice =
          (order['no_invoice'] ?? order['invoice'] ?? '').toString();
      final nama = (order['nama_pelanggan'] ?? order['nama'] ?? '').toString();
      final status = StatusOrderHelper.status(
        order['status_pesanan'] ?? order['status'],
      );

      return (invoice.toLowerCase().contains(keyword) ||
              nama.toLowerCase().contains(keyword)) &&
          (_filter == 'Semua' || status == _filter);
    }).toList();
  }

  /// Jumlah pesanan per filter (untuk badge di chip & banner).
  int _hitung(String filter) {
    if (filter == 'Semua') return _pesanan.length;
    return _pesanan
        .where(
          (o) =>
              StatusOrderHelper.status(o['status_pesanan'] ?? o['status']) ==
              filter,
        )
        .length;
  }

  Future<void> _bukaDetail(Map<String, dynamic> order) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPesananPage(order: order)),
    );
    // Muat ulang daftar supaya status terbaru langsung tampil.
    if (!mounted) return;
    _loadPesanan();
  }

  void _kembali() {
    Navigator.pushReplacementNamed(context, '/beranda');
  }

  // ───────────────────────── BUILD ─────────────────────────

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _kembali();
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE1E9), Color(0xFFFFF0F3), Color(0xFFFFF8F9)],
            stops: [0, 0.36, 1],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: const BottomNavBar(currentIndex: 2),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                StatusOrderHeader(
                  onBack: _kembali,
                  onRefresh: _loadPesanan,
                ),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final orders = _filteredOrders;
    final menungguBayar = _hitung('Menunggu Pembayaran');

    return RefreshIndicator(
      color: StatusOrderStyle.maroon,
      onRefresh: _loadPesanan,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          if (!_loading && _error == null && menungguBayar > 0) ...[
            Padding(
              padding: StatusOrderStyle.pagePadding,
              child: StatusOrderBanner(
                jumlah: menungguBayar,
                onTap: () => setState(() => _filter = 'Menunggu Pembayaran'),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Padding(
            padding: StatusOrderStyle.pagePadding,
            child: StatusOrderSearch(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 16),
          StatusOrderFilters(
            filters: _filters,
            selected: _filter,
            countOf: _hitung,
            onSelected: (item) => setState(() => _filter = item),
          ),
          const SizedBox(height: 16),
          if (!_loading && _error == null) ...[
            Padding(
              padding: StatusOrderStyle.pagePadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Pesanan',
                    style: TextStyle(
                      color: StatusOrderStyle.maroon,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${orders.length} pesanan',
                    style: const TextStyle(
                      color: StatusOrderStyle.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          ..._buildListContent(orders),
        ],
      ),
    );
  }

  List<Widget> _buildListContent(List<Map<String, dynamic>> orders) {
    if (_loading) return const [StatusOrderLoading()];

    if (_error != null) {
      return [StatusOrderError(message: _error!, onRetry: _loadPesanan)];
    }

    if (orders.isEmpty) return const [StatusOrderEmpty()];

    return [
      for (final order in orders)
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: StatusOrderCard(order: order, onTap: () => _bukaDetail(order)),
        ),
    ];
  }
}
