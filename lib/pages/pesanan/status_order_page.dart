import 'package:flutter/material.dart';

import '../../services/pesanan_service.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import 'detail_pesanan_page.dart';

class StatusOrderPage extends StatefulWidget {
  const StatusOrderPage({super.key});

  @override
  State<StatusOrderPage> createState() => _StatusOrderPageState();
}

class _StatusOrderPageState extends State<StatusOrderPage> {
  // Warna disamakan dengan Beranda
  static const Color _maroon = Color(0xFF800020);
  static const Color _rose = Color(0xFFB8305F);
  static const Color _roseDark = Color(0xFF9E1B4C);
  static const Color _blush = Color(0xFFFBE3EA);
  static const Color _muted = Color(0xFF85606C);
  static const Color _line = Color(0xFFF6DCE3);

  static const EdgeInsets _pagePadding = EdgeInsets.symmetric(horizontal: 20);

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

  List<BoxShadow> get _shadow => [
        BoxShadow(
          color: _maroon.withValues(alpha: 0.08),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
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

  String _status(dynamic value) {
    final status = (value ?? '').toString().toLowerCase();

    switch (status) {
      case 'menunggu_pembayaran':
        return 'Menunggu Pembayaran';
      case 'menunggu_dikonfirmasi':
      case 'menunggu_konfirmasi':
        return 'Menunggu Konfirmasi';
      case 'dikonfirmasi':
        return 'Dikonfirmasi';
      case 'diproses':
        return 'Diproses';
      case 'dalam_pengiriman':
        return 'Dalam Pengiriman';
      case 'siap_diambil':
        return 'Siap Diambil';
      case 'selesai':
        return 'Selesai';
      case 'dibatalkan':
        return 'Dibatalkan';
      default:
        return value?.toString() ?? 'Belum diketahui';
    }
  }

  MaterialColor _statusColor(String status) {
    switch (status) {
      case 'Menunggu Pembayaran':
      case 'Menunggu Konfirmasi':
        return Colors.orange;
      case 'Dikonfirmasi':
        return Colors.blue;
      case 'Diproses':
      case 'Dalam Pengiriman':
      case 'Siap Diambil':
        return Colors.purple;
      case 'Selesai':
        return Colors.green;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Mencari nilai total: coba nama field umum dulu, lalu field apa pun
  /// yang namanya mengandung "total" / "harga" / "bayar".
  dynamic _ambilTotal(Map<String, dynamic> order) {
    const kunci = [
      'total_harga',
      'total_bayar',
      'total_pembayaran',
      'grand_total',
      'total',
      'jumlah_bayar',
      'harga_total',
    ];
    for (final k in kunci) {
      final v = order[k];
      if (v != null && v.toString().isNotEmpty) return v;
    }
    for (final e in order.entries) {
      final k = e.key.toLowerCase();
      if ((k.contains('total') || k.contains('harga') || k.contains('bayar')) &&
          num.tryParse(e.value?.toString() ?? '') != null) {
        return e.value;
      }
    }
    return null;
  }

  String _rupiah(dynamic value) {
    // num.tryParse supaya "250000.00" tidak menjadi 0
    final number = (num.tryParse(value?.toString() ?? '') ?? 0).toInt();
    final formatted = number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'Rp $formatted';
  }

  String _tanggal(dynamic value) {
    if (value == null) return '-';
    try {
      final date = DateTime.parse(value.toString());
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return value.toString();
    }
  }

  List<Map<String, dynamic>> get _filteredOrders {
    final keyword = _searchController.text.toLowerCase();

    return _pesanan.where((order) {
      final invoice =
          (order['no_invoice'] ?? order['invoice'] ?? '').toString();
      final nama = (order['nama_pelanggan'] ?? order['nama'] ?? '').toString();
      final status = _status(order['status_pesanan'] ?? order['status']);

      return (invoice.toLowerCase().contains(keyword) ||
              nama.toLowerCase().contains(keyword)) &&
          (_filter == 'Semua' || status == _filter);
    }).toList();
  }

  /// Jumlah pesanan per filter (untuk badge di chip & banner).
  int _hitung(String filter) {
    if (filter == 'Semua') return _pesanan.length;
    return _pesanan
        .where((o) => _status(o['status_pesanan'] ?? o['status']) == filter)
        .length;
  }

  void _bukaDetail(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPesananPage(order: order)),
    );
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
                _buildHeader(),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          _roundButton(
            icon: Icons.arrow_back_ios_new_rounded,
            size: 18,
            tooltip: 'Kembali',
            onTap: _kembali,
          ),
          const Expanded(
            child: Column(
              children: [
                Text(
                  'Status Order',
                  style: TextStyle(
                    color: _maroon,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Royal Florist',
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          _roundButton(
            icon: Icons.refresh_rounded,
            tooltip: 'Muat ulang',
            onTap: _loadPesanan,
          ),
        ],
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    double size = 22,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: _shadow,
      ),
      child: IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        onPressed: onTap,
        icon: Icon(icon, size: size, color: _maroon),
      ),
    );
  }

  Widget _buildBody() {
    final orders = _filteredOrders;
    final menungguBayar = _hitung('Menunggu Pembayaran');

    return RefreshIndicator(
      color: _maroon,
      onRefresh: _loadPesanan,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          if (!_loading && _error == null && menungguBayar > 0) ...[
            Padding(
              padding: _pagePadding,
              child: _buildSummaryBanner(menungguBayar),
            ),
            const SizedBox(height: 16),
          ],
          Padding(padding: _pagePadding, child: _buildSearch()),
          const SizedBox(height: 16),
          _buildFilters(),
          const SizedBox(height: 16),
          if (!_loading && _error == null) ...[
            Padding(
              padding: _pagePadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Pesanan',
                    style: TextStyle(
                      color: _maroon,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${orders.length} pesanan',
                    style: const TextStyle(color: _muted, fontSize: 12),
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
    if (_loading) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: 60),
          child: Center(child: CircularProgressIndicator(color: _maroon)),
        ),
      ];
    }

    if (_error != null) {
      return [
        Padding(
          padding: _pagePadding,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: _shadow,
            ),
            child: Column(
              children: [
                const Icon(Icons.error_outline, size: 44, color: Colors.red),
                const SizedBox(height: 12),
                const Text(
                  'Gagal memuat pesanan',
                  style: TextStyle(
                    color: _maroon,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadPesanan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _maroon,
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
        ),
      ];
    }

    if (orders.isEmpty) {
      return [
        Padding(
          padding: _pagePadding,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: _shadow,
            ),
            child: const Column(
              children: [
                Icon(Icons.receipt_long_outlined, size: 56, color: _rose),
                SizedBox(height: 12),
                Text(
                  'Belum ada pesanan',
                  style: TextStyle(
                    color: _maroon,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pesanan pelanggan akan muncul di sini.',
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    return [
      for (final order in orders)
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: _orderCard(order),
        ),
    ];
  }

  // ───────────────────────── KOMPONEN ─────────────────────────

  Widget _buildSummaryBanner(int jumlah) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_rose, _roseDark]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _roseDark.withValues(alpha: 0.28),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => setState(() => _filter = 'Menunggu Pembayaran'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.schedule_rounded,
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
                        'Menunggu Pembayaran ($jumlah)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Ada $jumlah pesanan yang belum dibayar',
                        style: const TextStyle(
                          color: Color(0xFFFFE9EF),
                          fontSize: 11,
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

  Widget _buildSearch() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: _shadow,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(fontSize: 13, color: _maroon),
        decoration: const InputDecoration(
          hintText: 'Cari invoice atau nama pelanggan',
          hintStyle: TextStyle(color: _muted, fontSize: 13),
          prefixIcon: Icon(Icons.search, color: _maroon),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: _pagePadding,
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = _filters[index];
          final aktif = _filter == item;

          return Material(
            color: aktif ? _maroon : Colors.white,
            shape: StadiumBorder(
              side: BorderSide(
                color: aktif ? _maroon : const Color(0xFFF0C9D3),
              ),
            ),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => setState(() => _filter = item),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 8, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: aktif ? Colors.white : const Color(0xFF5E1A2E),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 22,
                      constraints: const BoxConstraints(minWidth: 22),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: aktif
                            ? Colors.white.withValues(alpha: 0.22)
                            : _blush,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        '${_hitung(item)}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: aktif ? Colors.white : _maroon,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _orderCard(Map<String, dynamic> order) {
    final invoice = order['no_invoice'] ?? order['invoice'] ?? '-';
    final nama = order['nama_pelanggan'] ?? order['nama'] ?? 'Pelanggan';
    final status = _status(order['status_pesanan'] ?? order['status']);
    final tanggal = _tanggal(order['dibuat_pada'] ?? order['created_at']);
    final total = _rupiah(_ambilTotal(order));
    final warna = _statusColor(status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: _shadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _bukaDetail(order),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _blush,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: _maroon,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        invoice.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF5E1A2E),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: warna.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: warna.shade800,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16, color: _muted),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        nama.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _muted, fontSize: 12.5),
                      ),
                    ),
                    const SizedBox(width: 18),
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 15,
                      color: _muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tanggal,
                      style: const TextStyle(color: _muted, fontSize: 12.5),
                    ),
                  ],
                ),
                const Divider(height: 24, thickness: 1, color: _line),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(color: _muted, fontSize: 11),
                        ),
                        Text(
                          total,
                          style: const TextStyle(
                            color: _maroon,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: _blush,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Lihat detail',
                            style: TextStyle(
                              color: _maroon,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: _maroon,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}