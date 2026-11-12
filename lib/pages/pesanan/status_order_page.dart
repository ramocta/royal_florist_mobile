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
  static const Color _maroon = Color(0xFF800020);

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
        backgroundColor: const Color(0xFFFFF5F7),
        bottomNavigationBar: const BottomNavBar(currentIndex: 2),
        appBar: AppBar(
          backgroundColor: _maroon,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          actionsIconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: _kembali,
          ),
          title: const Text('Status Order'),
          actions: [
            IconButton(
              onPressed: _loadPesanan,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cari invoice atau nama pelanggan',
                  prefixIcon: const Icon(Icons.search, color: _maroon),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 45,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = _filters[index];

                  return ChoiceChip(
                    label: Text(item),
                    selected: _filter == item,
                    selectedColor: _maroon,
                    backgroundColor: Colors.white,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: _filter == item ? Colors.white : Colors.black87,
                    ),
                    onSelected: (_) => setState(() => _filter = item),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: _maroon));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 50, color: Colors.red),
            const SizedBox(height: 12),
            const Text('Gagal memuat pesanan'),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(_error!, textAlign: TextAlign.center),
            ),
            ElevatedButton(
              onPressed: _loadPesanan,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    final orders = _filteredOrders;

    if (orders.isEmpty) {
      return RefreshIndicator(
        color: _maroon,
        onRefresh: _loadPesanan,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 100),
            Icon(Icons.receipt_long_outlined, size: 70, color: Colors.grey),
            SizedBox(height: 15),
            Center(
              child: Text(
                'Belum ada pesanan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 5),
            Center(child: Text('Pesanan pelanggan akan muncul di sini.')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: _maroon,
      onRefresh: _loadPesanan,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
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

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _bukaDetail(order),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.receipt_long, color: _maroon),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      invoice.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.person_outline, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(nama.toString())),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 17,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(tanggal),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  total,
                  style: const TextStyle(
                    color: _maroon,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Lihat detail pesanan →',
                  style: TextStyle(
                    color: _maroon,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}