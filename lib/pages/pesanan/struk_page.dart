// Figma: Struk
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/struk_model.dart';
import '../../services/struk_service.dart';

class StrukPage extends StatelessWidget {
  final StrukModel struk;

  const StrukPage({super.key, this.struk = StrukModel.contoh});

  // ====== Warna ======
  static const Color _bg = Color(0xFFFDF1F2);
  static const Color _maroon = Color(0xFF880A0E);
  static const Color _dark = Color(0xFF2B1A1F);
  static const Color _grey = Color(0xFF6B5B5E);
  static const Color _line = Color(0xFFEDE3E4);
  static const Color _tableHeader = Color(0xFFF7E9EB);

  static String _rp(int v) => StrukService.rp(v);

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
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 16),
                child: _buildReceiptCard(),
              ),
            ),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  // =================================================================
  // AKSI
  // =================================================================
  void _snack(BuildContext context, String pesan) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  Future<void> _cetak(BuildContext context) async {
    try {
      await StrukService.cetak(struk);
    } catch (e) {
      _snack(context, 'Gagal mencetak: $e');
    }
  }

  Future<void> _kirimWa(BuildContext context) async {
    try {
      final ok = await StrukService.kirimWhatsApp(struk);
      if (!ok) _snack(context, 'WhatsApp tidak bisa dibuka');
    } catch (e) {
      _snack(context, 'Gagal membuka WhatsApp: $e');
    }
  }

  // =================================================================
  // TAMPILAN
  // =================================================================
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
            'Cetak Struk',
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

  Widget _buildReceiptCard() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 36, 22, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: const Color(0xFFF3DDE0), width: 1),
            boxShadow: [
              BoxShadow(
                color: _maroon.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBrand(),
              const SizedBox(height: 26),
              Center(
                child: Text(
                  'STRUK PESANAN',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _dark,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              _infoRow('No. Invoice', struk.invoice),
              _infoRow('Tanggal', struk.tanggal),
              _infoRow('Pelanggan', struk.pelanggan),
              _infoRow('Alamat', struk.alamat),
              const SizedBox(height: 10),
              const Divider(color: _line, height: 1),
              const SizedBox(height: 32),
              _buildTable(),
              const SizedBox(height: 16),
              const Divider(color: _line, height: 1),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _dark,
                    ),
                  ),
                  Text(
                    _rp(struk.total),
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _dark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Divider(color: _line, height: 1),
              const SizedBox(height: 28),
              _buildFooter(),
            ],
          ),
        ),
        Positioned(
          top: -16,
          child: Container(
            width: 38,
            height: 32,
            decoration: BoxDecoration(
              color: _dark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.photo_camera_rounded,
                color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildBrand() {
    return Column(
      children: [
        Text(
          'ROYAL FLORIST',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: _dark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Fresh Flowers, Better Feelings',
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontStyle: FontStyle.italic,
            color: _grey,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: GoogleFonts.poppins(fontSize: 12.5, color: _grey)),
          ),
          Text(': ',
              style: GoogleFonts.poppins(
                  fontSize: 12.5, fontWeight: FontWeight.w600, color: _dark)),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: _dark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    final headStyle = GoogleFonts.poppins(
        fontSize: 11, fontWeight: FontWeight.w600, color: _dark);
    final cellStyle = GoogleFonts.poppins(fontSize: 12, color: _grey);
    final boldStyle = GoogleFonts.poppins(
        fontSize: 12, fontWeight: FontWeight.w700, color: _dark);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: _tableHeader,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(flex: 30, child: Text('Produk', style: headStyle)),
              Expanded(
                  flex: 17,
                  child: Text('Jumlah',
                      textAlign: TextAlign.center, style: headStyle)),
              Expanded(
                  flex: 20,
                  child: Text('Harga',
                      textAlign: TextAlign.right, style: headStyle)),
              Expanded(
                  flex: 22,
                  child: Text('Subtotal',
                      textAlign: TextAlign.right, style: headStyle)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        ...struk.items.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 30,
                  child: Text(e.nama,
                      style:
                          GoogleFonts.poppins(fontSize: 12, color: _dark)),
                ),
                Expanded(
                  flex: 17,
                  child: Text('${e.qty}',
                      textAlign: TextAlign.center, style: cellStyle),
                ),
                Expanded(
                  flex: 20,
                  child: Text(_rp(e.harga),
                      textAlign: TextAlign.right, style: cellStyle),
                ),
                Expanded(
                  flex: 22,
                  child: Text(_rp(e.subtotal),
                      textAlign: TextAlign.right, style: boldStyle),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text('Terima kasih telah mempercayai',
            style: GoogleFonts.poppins(fontSize: 12, color: _grey)),
        const SizedBox(height: 4),
        Text(
          'Royal Florist',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _dark,
          ),
        ),
        const SizedBox(height: 10),
        const Icon(Icons.favorite_rounded, color: Color(0xFFE0345A), size: 18),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tombol Cetak (sesuai desain)
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              onPressed: () => _cetak(context),
              icon: const Icon(Icons.print_rounded),
              label: Text(
                'Cetak',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _maroon,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Tombol Kirim WhatsApp
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              onPressed: () => _kirimWa(context),
              icon: const Icon(Icons.chat_rounded),
              label: Text(
                'Kirim ke WhatsApp',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: _maroon,
                side: const BorderSide(color: _maroon, width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
