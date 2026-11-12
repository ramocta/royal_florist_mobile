// Figma: Detail pesanan
import 'package:flutter/material.dart';

import '../../core/api/api_client.dart';
import '../../core/shared/app_colors.dart';
import '../../widgets/beranda/beranda_style.dart';
import '../../widgets/common/latar_pink.dart';

// =====================================================================
// Model satu baris produk
// =====================================================================
class DetailProdukItem {
  final String nama;
  final int qty;
  final String satuan;
  final int harga;

  const DetailProdukItem(this.nama, this.qty, this.satuan, this.harga);

  int get subtotal => qty * harga;
}

// =====================================================================
// Halaman yang dipakai dari Status Order.
// Menerima satu pesanan (Map dari API /orders), langsung menampilkannya,
// lalu mencoba memuat detail lengkap (produk, alamat, catatan) dari server.
// =====================================================================
class DetailPesananPage extends StatefulWidget {
  final Map<String, dynamic> order;

  const DetailPesananPage({super.key, required this.order});

  @override
  State<DetailPesananPage> createState() => _DetailPesananPageState();
}

class _DetailPesananPageState extends State<DetailPesananPage> {
  late Map<String, dynamic> _data;
  bool _memuat = false;

  @override
  void initState() {
    super.initState();
    _data = Map<String, dynamic>.from(widget.order);
    _muatDetail();
  }

  /// Mencoba GET /orders/{id}. Kalau gagal / endpoint belum ada,
  /// halaman tetap memakai data dari daftar.
  Future<void> _muatDetail() async {
    final id =
        _data['id_order'] ?? _data['id'] ?? _data['id_pesanan'] ?? _data['order_id'];
    if (id == null) return;

    setState(() => _memuat = true);
    try {
      dynamic res = await ApiClient.get('/orders/$id');
      if (res is Map && res['data'] is Map) res = res['data'];
      if (res is Map && mounted) {
        setState(() => _data = {..._data, ...Map<String, dynamic>.from(res)});
      }
    } catch (_) {
      // abaikan: tetap tampilkan data dari daftar
    } finally {
      if (mounted) setState(() => _memuat = false);
    }
  }

  // ---------- Pembaca field yang toleran terhadap beda nama kolom ----------
  String _teks(List<String> kunci, {String bawaan = '-'}) {
    for (final k in kunci) {
      final v = _data[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return bawaan;
  }

  int? _angkaOrNull(Map m, List<String> kunci) {
    for (final k in kunci) {
      final n = num.tryParse(m[k]?.toString() ?? '');
      if (n != null) return n.toInt();
    }
    return null;
  }

  String _label(String raw) {
    switch (raw.toLowerCase()) {
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
        return raw;
    }
  }

  String _tanggal() {
    final raw = _teks(['dibuat_pada', 'tanggal'], bawaan: '');
    if (raw.isEmpty) return '';
    final d = DateTime.tryParse(raw);
    if (d == null) return raw;
    final l = d.toLocal();
    String dua(int n) => n.toString().padLeft(2, '0');
    return '${dua(l.day)}/${dua(l.month)}/${l.year}';
  }

  List<DetailProdukItem> _daftarProduk() {
    dynamic list;
    for (final k in ['items', 'detail_pesanan', 'detail', 'produk', 'order_items']) {
      if (_data[k] is List) {
        list = _data[k];
        break;
      }
    }
    if (list is! List) return const [];

    return list.whereType<Map>().map((m) {
      final nama =
          (m['nama_produk'] ?? m['nama'] ?? m['produk']?['nama'] ?? '-').toString();
      final qty = _angkaOrNull(m, ['jumlah', 'qty', 'kuantitas']) ?? 0;
      final harga = _angkaOrNull(m, ['harga', 'harga_satuan', 'harga_produk']) ?? 0;
      final satuan = (m['satuan'] ?? '').toString();
      return DetailProdukItem(nama, qty, satuan, harga);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final statusRaw = _teks(['status_pesanan', 'status'], bawaan: '');

    return DetailPesananView(
      invoice: _teks(['no_invoice', 'invoice']),
      status: statusRaw.isEmpty ? '-' : _label(statusRaw),
      tanggal: _tanggal(),
      nama: _teks(['nama_pelanggan', 'nama']),
      telepon: _teks(['no_hp', 'no_telepon', 'telepon', 'phone']),
      alamat: _teks(['alamat_pengiriman', 'alamat']),
      catatan: _teks(['catatan_pelanggan', 'catatan']),
      produk: _daftarProduk(),
      totalServer: _angkaOrNull(_data, ['total_harga', 'total']),
      memuat: _memuat,
    );
  }
}

// =====================================================================
// Tampilan (murni UI). Data dikirim lewat parameter.
// =====================================================================
class DetailPesananView extends StatelessWidget {
  final String invoice;
  final String status;
  final String tanggal;
  final String nama;
  final String telepon;
  final String alamat;
  final String catatan;
  final List<DetailProdukItem> produk;

  /// Total dari server (kolom total_harga). Dipakai kalau ada.
  final int? totalServer;
  final bool memuat;
  final VoidCallback? onKonfirmasi;

  const DetailPesananView({
    super.key,
    required this.invoice,
    required this.status,
    required this.nama,
    required this.telepon,
    required this.alamat,
    required this.catatan,
    required this.produk,
    this.tanggal = '',
    this.totalServer,
    this.memuat = false,
    this.onKonfirmasi,
  });

  // Gradasi yang sama dengan kartu "Pesanan Baru" di beranda.
  static const _gradPink = LinearGradient(
    colors: [Color(0xFFD9446F), Color(0xFFB02A52)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static String _rp(int v) {
    final s = v.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (m) => '${m[1]}.',
        );
    return 'Rp$s';
  }

  static TextStyle _t(double size, FontWeight w, Color c) =>
      TextStyle(fontFamily: 'Poppins', fontSize: size, fontWeight: w, color: c);

  int get _total =>
      totalServer ?? produk.fold<int>(0, (sum, e) => sum + e.subtotal);

  bool get _bisaKonfirmasi => status == 'Menunggu Konfirmasi';

  /// Warna chip status (latar, teks).
  (Color, Color) get _warnaStatus {
    switch (status) {
      case 'Menunggu Pembayaran':
        return (const Color(0xFFFFF1D6), const Color(0xFFB7791F));
      case 'Menunggu Konfirmasi':
        return (const Color(0xFFFCE4EA), const Color(0xFFD9446F));
      case 'Dikonfirmasi':
      case 'Diproses':
        return (const Color(0xFFFDE8D8), const Color(0xFFC2410C));
      case 'Dalam Pengiriman':
        return (const Color(0xFFE3EEFF), const Color(0xFF2F6FD1));
      case 'Siap Diambil':
        return (const Color(0xFFE2F5EA), const Color(0xFF2E8B57));
      case 'Selesai':
        return (const Color(0xFFDFF4E6), const Color(0xFF237A4B));
      case 'Dibatalkan':
        return (const Color(0xFFEDEDED), const Color(0xFF777777));
      default:
        return (BerandaStyle.latarAtas, BerandaStyle.rose);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BerandaStyle.latarAtas,
      body: LatarPink(
        child: SafeArea(
          child: Column(
            children: [
              _appBar(context),
              if (memuat)
                const LinearProgressIndicator(
                  minHeight: 2,
                  color: BerandaStyle.rose,
                  backgroundColor: Colors.transparent,
                )
              else
                const SizedBox(height: 2),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                  child: Column(
                    children: [
                      _kartuInvoice(),
                      const SizedBox(height: 14),
                      _kartuPelanggan(),
                      const SizedBox(height: 14),
                      _kartuProduk(),
                      const SizedBox(height: 14),
                      _kartuCatatan(),
                      const SizedBox(height: 14),
                      _kartuTotal(),
                    ],
                  ),
                ),
              ),
              if (_bisaKonfirmasi) _tombol(context),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- App bar ----------
  Widget _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 3,
            shadowColor: BerandaStyle.rose.withValues(alpha: 0.25),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.maybePop(context),
              child: const Padding(
                padding: EdgeInsets.all(9),
                child: Icon(Icons.arrow_back_ios_new_rounded,
                    size: 16, color: AppColors.maroon),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text('Detail Pesanan',
              style: _t(20, FontWeight.w600, AppColors.maroon)),
        ],
      ),
    );
  }

  // ---------- Kartu invoice + status ----------
  Widget _kartuInvoice() {
    final (bg, fg) = _warnaStatus;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BerandaStyle.kartu(),
      child: Row(
        children: [
          _ikonKotak(Icons.receipt_long_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(invoice,
                    style: _t(14.5, FontWeight.w700, BerandaStyle.teksGelap)),
                if (tanggal.isNotEmpty)
                  Text('Dipesan $tanggal',
                      style: _t(11, FontWeight.w400, BerandaStyle.teksRedup)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: _t(10.5, FontWeight.w600, fg)),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu pelanggan ----------
  Widget _kartuPelanggan() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BerandaStyle.kartu(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _judul('Informasi Pelanggan'),
          const SizedBox(height: 14),
          _barisInfo(Icons.person_rounded, nama, telepon),
          const SizedBox(height: 12),
          _barisInfo(Icons.location_on_rounded, 'Alamat', alamat),
        ],
      ),
    );
  }

  Widget _barisInfo(IconData icon, String atas, String bawah) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ikonKotak(icon, ukuran: 36),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(atas,
                  style: _t(13.5, FontWeight.w600, BerandaStyle.teksGelap)),
              const SizedBox(height: 1),
              Text(bawah,
                  style: _t(12, FontWeight.w400, BerandaStyle.teksRedup)),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- Kartu produk ----------
  Widget _kartuProduk() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
      decoration: BerandaStyle.kartu(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: _judul('Detail Produk'),
          ),
          const SizedBox(height: 12),
          if (produk.isEmpty)
            _kosongProduk()
          else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: AppColors.pinkLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(flex: 28, child: _kepala('Produk')),
                  Expanded(flex: 22, child: _kepala('Jumlah')),
                  Expanded(flex: 19, child: _kepala('Harga')),
                  Expanded(
                      flex: 22,
                      child: _kepala('Subtotal', rata: TextAlign.right)),
                ],
              ),
            ),
            for (int i = 0; i < produk.length; i++) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 28,
                      child: Text(produk[i].nama,
                          style: _t(12, FontWeight.w500,
                              BerandaStyle.teksGelap)),
                    ),
                    Expanded(
                      flex: 22,
                      child: Text(
                        '${produk[i].qty} ${produk[i].satuan}'.trim(),
                        style: _t(12, FontWeight.w400, BerandaStyle.teksRedup),
                      ),
                    ),
                    Expanded(
                      flex: 19,
                      child: Text(_rp(produk[i].harga),
                          style: _t(11.5, FontWeight.w400,
                              BerandaStyle.teksRedup)),
                    ),
                    Expanded(
                      flex: 22,
                      child: Text(_rp(produk[i].subtotal),
                          textAlign: TextAlign.right,
                          style: _t(12, FontWeight.w700, AppColors.maroon)),
                    ),
                  ],
                ),
              ),
              if (i != produk.length - 1)
                Divider(
                    height: 1,
                    color: BerandaStyle.rose.withValues(alpha: 0.10)),
            ],
          ],
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _kepala(String t, {TextAlign rata = TextAlign.left}) =>
      Text(t, textAlign: rata, style: _t(11, FontWeight.w600, AppColors.maroon));

  Widget _kosongProduk() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.pinkLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(Icons.local_florist_rounded,
              size: 30, color: BerandaStyle.roseSoft),
          const SizedBox(height: 8),
          Text('Rincian produk belum tersedia',
              style: _t(12, FontWeight.w500, BerandaStyle.teksRedup)),
        ],
      ),
    );
  }

  // ---------- Kartu catatan ----------
  Widget _kartuCatatan() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BerandaStyle.kartu(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ikonKotak(Icons.notes_rounded, ukuran: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Catatan Pelanggan',
                    style:
                        _t(13.5, FontWeight.w600, BerandaStyle.teksGelap)),
                const SizedBox(height: 1),
                Text(catatan,
                    style: _t(12, FontWeight.w400, BerandaStyle.teksRedup)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu total (gradasi pink) ----------
  Widget _kartuTotal() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        gradient: _gradPink,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: BerandaStyle.rose.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Colors.white24, shape: BoxShape.circle),
                child: const Icon(Icons.payments_rounded,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Text('Total', style: _t(15, FontWeight.w600, Colors.white)),
            ],
          ),
          Text(_rp(_total), style: _t(19, FontWeight.w700, Colors.white)),
        ],
      ),
    );
  }

  // ---------- Tombol konfirmasi ----------
  Widget _tombol(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.maroon, AppColors.crimson],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.maroon.withValues(alpha: 0.28),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onKonfirmasi ??
                () {
                  // TODO: panggil API konfirmasi pesanan
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Konfirmasi pesanan')),
                  );
                },
            child: Center(
              child: Text('Konfirmasi Pesanan',
                  style: _t(15.5, FontWeight.w600, Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Util kecil ----------
  Widget _judul(String t) => Text(t,
      style: _t(14.5, FontWeight.w700, BerandaStyle.teksGelap));

  Widget _ikonKotak(IconData icon, {double ukuran = 40}) {
    return Container(
      width: ukuran,
      height: ukuran,
      decoration: BoxDecoration(
        color: AppColors.pinkLight,
        borderRadius: BorderRadius.circular(ukuran * 0.32),
      ),
      child: Icon(icon, color: AppColors.maroon, size: ukuran * 0.5),
    );
  }
}
