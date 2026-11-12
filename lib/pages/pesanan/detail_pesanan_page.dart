// Figma: Detail Pesanan
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPesananPage extends StatelessWidget {
  const DetailPesananPage({super.key});

  // ====== Warna ======
  static const Color _bg = Color(0xFFFDF1F2);
  static const Color _maroon = Color(0xFF880A0E);
  static const Color _dark = Color(0xFF2B1A1F);
  static const Color _grey = Color(0xFF6B5B5E);
  static const Color _line = Color(0xFFEBDDDF);
  static const Color _tableHeader = Color(0xFFF7E9EB);
  static const Color _pink = Color(0xFFE0345A);
  static const Color _chipBg = Color(0xFFFBE3E8);

  // ====== Data dummy (ganti dengan data asli dari API / database) ======
  static const String _invoice = 'INV-20261004-001';
  static const String _status = 'Menunggu Konfirmasi';
  static const String _nama = 'Siti Maisyarah';
  static const String _telepon = '0812 3456 7890';
  static const String _alamat = 'Jl. Melati No. 12, Nganjuk';
  static const String _catatan = 'Untuk tanggal 5 Oktober, pukul 15.00.';

  static const List<_ProdukItem> _produk = [
    _ProdukItem('Bunga Mawar', 5, 'tangkai', 10000),
    _ProdukItem('Bunga Lily', 2, 'tangkai', 8000),
    _ProdukItem('Kartu Ucapan', 1, 'pcs', 9000),
  ];

  static String _rp(int v) {
    final s = v.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (m) => '${m[1]}.',
        );
    return 'Rp$s';
  }

  int get _total => _produk.fold(0, (sum, e) => sum + e.subtotal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInvoiceRow(),
                    const SizedBox(height: 16),
                    const Divider(color: _line, height: 1),
                    const SizedBox(height: 18),
                    _buildInfoPelanggan(),
                    const SizedBox(height: 18),
                    const Divider(color: _line, height: 1),
                    const SizedBox(height: 18),
                    _buildDetailProduk(),
                    const SizedBox(height: 18),
                    _buildCatatan(),
                    const SizedBox(height: 18),
                    _buildTotal(),
                  ],
                ),
              ),
            ),
            _buildButton(context),
          ],
        ),
      ),
    );
  }

  // ---------- App bar ----------
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: _maroon, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Detail Pesanan',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _maroon,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Invoice + status ----------
  Widget _buildInvoiceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            _invoice,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _dark,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: _chipBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _status,
            style: GoogleFonts.poppins(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: _pink,
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Informasi pelanggan ----------
  Widget _buildInfoPelanggan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Informasi Pelanggan'),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.person_rounded, color: _maroon, size: 26),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nama,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                Text(
                  _telepon,
                  style: GoogleFonts.poppins(fontSize: 12, color: _grey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.location_on_outlined, color: _maroon, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alamat',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _dark,
                    ),
                  ),
                  Text(
                    _alamat,
                    style: GoogleFonts.poppins(fontSize: 12, color: _grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: _dark,
      ),
    );
  }

  // ---------- Detail produk ----------
  Widget _buildDetailProduk() {
    final headStyle = GoogleFonts.poppins(
        fontSize: 11.5, fontWeight: FontWeight.w600, color: _dark);
    final cellStyle = GoogleFonts.poppins(fontSize: 12, color: _grey);
    final nameStyle = GoogleFonts.poppins(fontSize: 12, color: _dark);
    final boldStyle = GoogleFonts.poppins(
        fontSize: 12, fontWeight: FontWeight.w700, color: _dark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Detail Produk'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1DDE0)),
          ),
          child: Column(
            children: [
              // Header tabel
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                decoration: const BoxDecoration(
                  color: _tableHeader,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: 28, child: Text('Produk', style: headStyle)),
                    Expanded(
                        flex: 22, child: Text('Jumlah', style: headStyle)),
                    Expanded(
                        flex: 19, child: Text('Harga', style: headStyle)),
                    Expanded(
                        flex: 22,
                        child: Text('Subtotal',
                            textAlign: TextAlign.right, style: headStyle)),
                  ],
                ),
              ),
              // Baris produk
              for (int i = 0; i < _produk.length; i++) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 28,
                          child: Text(_produk[i].nama, style: nameStyle)),
                      Expanded(
                          flex: 22,
                          child: Text(
                              '${_produk[i].qty} ${_produk[i].satuan}',
                              style: cellStyle)),
                      Expanded(
                          flex: 19,
                          child:
                              Text(_rp(_produk[i].harga), style: cellStyle)),
                      Expanded(
                          flex: 22,
                          child: Text(_rp(_produk[i].subtotal),
                              textAlign: TextAlign.right, style: boldStyle)),
                    ],
                  ),
                ),
                if (i != _produk.length - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Divider(color: _line, height: 1),
                  ),
              ],
              const SizedBox(height: 14),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- Catatan pelanggan ----------
  Widget _buildCatatan() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _tableHeader,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.notes_rounded, color: _maroon, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catatan Pelanggan',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _catatan,
                  style: GoogleFonts.poppins(fontSize: 12, color: _grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Total ----------
  Widget _buildTotal() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _dark,
            ),
          ),
          Text(
            _rp(_total),
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _dark,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Tombol ----------
  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: () {
            // TODO: lanjut ke halaman konfirmasi pesanan
            // Navigator.push(context, MaterialPageRoute(
            //   builder: (_) => const KonfirmasiPesananPage()));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Konfirmasi pesanan')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _maroon,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Text(
            'Konfirmasi Pesanan',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProdukItem {
  final String nama;
  final int qty;
  final String satuan;
  final int harga;

  const _ProdukItem(this.nama, this.qty, this.satuan, this.harga);

  int get subtotal => qty * harga;
}
