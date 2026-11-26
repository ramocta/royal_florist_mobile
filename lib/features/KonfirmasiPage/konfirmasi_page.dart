import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../pesanan/pesanan_berhasil_page.dart';

class KonfirmasiPage extends StatefulWidget {
  final String invoice;
  final String nama;
  final String tanggal;
  final String total;

  const KonfirmasiPage({
    super.key,
    this.invoice = 'INV-20261004-001',
    this.nama = 'Siti Maisyaroh',
    this.tanggal = '04 Okt 2026 • 14:32',
    this.total = 'Rp75.000',
  });

  @override
  State<KonfirmasiPage> createState() => _KonfirmasiPageState();
}

class _KonfirmasiPageState extends State<KonfirmasiPage> {
  static const _statusList = [
    'Dikonfirmasi',
    'Diproses',
    'Siap Diambil',
    'Selesai',
    'Dibatalkan',
  ];

  String _selected = 'Dikonfirmasi';
  final _catatanCtrl = TextEditingController();

  @override
  void dispose() {
    _catatanCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    // TODO: kirim _selected dan _catatanCtrl.text ke API / database
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PesananBerhasilPage(
          invoice: widget.invoice,
          nama: widget.nama,
          total: widget.total,
          status: _selected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.maroon),
        title: const Text(
          'Konfirmasi Pesanan',
          style: TextStyle(
            color: AppColors.title,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const Divider(color: Color(0xFFF1DDE0), height: 28),
              const Text(
                'Ubah Status Pesanan',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 14),
              ..._statusList.map(_statusTile),
              const SizedBox(height: 24),
              const Text(
                'Catatan (opsional)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 12),
              _catatanField(),
              const SizedBox(height: 28),
              _simpanButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(Icons.person, color: AppColors.maroon, size: 30),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.invoice,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(widget.nama,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(widget.tanggal,
                style:
                    const TextStyle(fontSize: 12, color: AppColors.muted)),
          ],
        ),
      ],
    );
  }

  Widget _statusTile(String status) {
    final selected = status == _selected;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _selected = status),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: selected ? AppColors.selectedBg : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color:
                  selected ? AppColors.selectedBorder : AppColors.cardBorder,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color:
                        selected ? AppColors.maroon : const Color(0xFFB9AEB0),
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppColors.maroon,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Text(status,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _catatanField() {
    return TextField(
      controller: _catatanCtrl,
      maxLines: 5,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: 'Tulis catatan jika ada...',
        hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.maroon),
        ),
      ),
    );
  }

  Widget _simpanButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _simpan,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.maroon,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text('Simpan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}