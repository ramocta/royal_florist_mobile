import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../../services/pesanan_service.dart';
import '../../widgets/beranda/beranda_style.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../widgets/common/latar_pink.dart';
import 'detail_pesanan_page.dart';

class StatusOrderPage extends StatefulWidget {
  const StatusOrderPage({super.key});

  @override
  State<StatusOrderPage> createState() => _StatusOrderPageState();
}

class _StatusOrderPageState extends State<StatusOrderPage> {
  static const Color _maroon = AppColors.maroon;

  final PesananService _service = PesananService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _pesanan = [];
  bool _loading = true;
  String? _error;
  String _filter = 'Semua';

  final List<String> _filters = [
    'Semua',
    'Dikonfirmasi',
    'Diproses',
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

  Color _statusColor(String status) {
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

  void _bukaDetail(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPesananPage(order: order)),
    );
  }

  void _kembali() {
    Navigator.pushReplacementNamed(context, '/beranda');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _kembali();
      },
      child: Scaffold(
        backgroundColor: BerandaStyle.latarBawah,
        bottomNavigationBar: const BottomNavBar(currentIndex: 2),
        body: LatarPink(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _header(),
                _searchBar(),
                _filterChips(),
                const SizedBox(height: 8),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: _kembali,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: _maroon,
            ),
          ),
          const Expanded(
            child: Text(
              'Status Order',
              style: TextStyle(
                fontFamily: 'CormorantGaramond',
                fontWeight: FontWeight.w700,
                fontSize: 26,
                color: _maroon,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BerandaStyle.kartu(radius: 14),
            child: IconButton(
              onPressed: _loadPesanan,
              icon: const Icon(Icons.refresh_rounded, color: BerandaStyle.rose),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        decoration: BerandaStyle.kartu(radius: 16),
        child: TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(color: BerandaStyle.teksGelap),
          decoration: const InputDecoration(
            hintText: 'Cari invoice atau nama pelanggan',
            hintStyle: TextStyle(color: BerandaStyle.teksRedup, fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: BerandaStyle.rose),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _filterChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = _filters[index];
          final aktif = _filter == item;

          return GestureDetector(
            onTap: () => setState(() => _filter = item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: aktif
                    ? const LinearGradient(
                        colors: [AppColors.crimson, BerandaStyle.rose],
                      )
                    : null,
                color: aktif ? null : Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: aktif
                      ? Colors.transparent
                      : BerandaStyle.rose.withValues(alpha: 0.15),
                ),
                boxShadow: aktif
                    ? [
                        BoxShadow(
                          color: BerandaStyle.rose.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: aktif ? FontWeight.w600 : FontWeight.w500,
                  color: aktif ? Colors.white : BerandaStyle.teksGelap,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: BerandaStyle.rose),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 50, color: AppColors.red),
              const SizedBox(height: 12),
              const Text(
                'Gagal memuat pesanan',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: BerandaStyle.teksGelap,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: BerandaStyle.teksRedup),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BerandaStyle.rose,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _loadPesanan,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final orders = _filteredOrders;

    if (orders.isEmpty) {
      return RefreshIndicator(
        color: BerandaStyle.rose,
        onRefresh: _loadPesanan,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 100),
            Icon(
              Icons.receipt_long_outlined,
              size: 70,
              color: BerandaStyle.roseSoft,
            ),
            SizedBox(height: 15),
            Center(
              child: Text(
                'Belum ada pesanan',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: BerandaStyle.teksGelap,
                ),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: Text(
                'Pesanan pelanggan akan muncul di sini.',
                style: TextStyle(color: BerandaStyle.teksRedup),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: BerandaStyle.rose,
      onRefresh: _loadPesanan,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: orders.length,
        itemBuilder: (context, index) => _orderCard(orders[index]),
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
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BerandaStyle.kartu(),
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
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: BerandaStyle.rose.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        size: 18,
                        color: BerandaStyle.rose,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        invoice.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: BerandaStyle.teksGelap,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: warna.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: warna,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 24,
                  color: BerandaStyle.rose.withValues(alpha: 0.12),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 20,
                      color: BerandaStyle.teksRedup,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        nama.toString(),
                        style: const TextStyle(color: BerandaStyle.teksGelap),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 17,
                      color: BerandaStyle.teksRedup,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tanggal,
                      style: const TextStyle(color: BerandaStyle.teksRedup),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    total,
                    style: const TextStyle(
                      color: _maroon,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Lihat detail pesanan →',
                    style: TextStyle(
                      color: BerandaStyle.rose,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
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