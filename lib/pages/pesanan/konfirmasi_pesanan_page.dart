import 'package:flutter/material.dart';
import '../../core/shared/app_colors.dart';
import '../../services/pesanan_service.dart';
import 'pesanan_berhasil_page.dart';

class KonfirmasiPesananPage extends StatefulWidget {
  final dynamic idOrder;
  final String statusSaatIni; // label, mis. 'Menunggu Konfirmasi'
  final String invoice;
  final String nama;
  final String tanggal;
  final String total;

  const KonfirmasiPesananPage({
    super.key,
    required this.idOrder,
    this.statusSaatIni = '',
    this.invoice = '-',
    this.nama = '-',
    this.tanggal = '',
    this.total = 'Rp0',
  });

  @override
  State<KonfirmasiPesananPage> createState() => _KonfirmasiPesananPageState();
}

class _KonfirmasiPesananPageState extends State<KonfirmasiPesananPage> {
  static const _statusList = [
    'Dikonfirmasi',
    'Diproses',
    'Siap Diambil',
    'Selesai',
    'Dibatalkan',
  ];

  // label di layar -> nilai yang dikirim ke backend
  static const _nilaiApi = {
    'Dikonfirmasi': 'dikonfirmasi',
    'Diproses': 'diproses',
    'Siap Diambil': 'siap_diambil',
    'Selesai': 'selesai',
    'Dibatalkan': 'dibatalkan',
  };

  final _service = PesananService();
  final _catatanCtrl = TextEditingController();
  late String _selected;
  bool _menyimpan = false;

  @override
  void initState() {
    super.initState();
    _selected = _statusList.contains(widget.statusSaatIni)
        ? widget.statusSaatIni
        : 'Dikonfirmasi';
  }

  @override
  void dispose() {
    _catatanCtrl.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (_menyimpan) return;
    setState(() => _menyimpan = true);

    try {
      await _service.updateStatus(
        id: widget.idOrder,
        status: _nilaiApi[_selected]!,
        catatan: _catatanCtrl.text,
      );
      if (!mounted) return;
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
    } catch (e) {
      if (!mounted) return;
      setState(() => _menyimpan = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.maroon),
        title: const Text(
          'Konfirmasi Pesanan',
          style: TextStyle(
            color: AppColors.maroon,
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
              const Divider(color: AppColors.divider, height: 28),
              const Text(
                'Ubah Status Pesanan',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 14),
              ..._statusList.map(_statusTile),
              const SizedBox(height: 24),
              const Text(
                'Catatan (opsional)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.ink,
                ),
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
            Text(
              widget.invoice,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.nama,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.tanggal,
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
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
            color: selected ? AppColors.pinkCard : AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.pinkSoft : AppColors.divider,
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
                    color: selected ? AppColors.maroon : AppColors.lightGrey,
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
              Text(
                status,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ink,
                ),
              ),
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
      style: const TextStyle(fontSize: 13, color: AppColors.ink),
      decoration: InputDecoration(
        hintText: 'Tulis catatan jika ada...',
        hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.all(18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
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
        onPressed: _menyimpan ? null : _simpan,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.maroon,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _menyimpan
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white),
              )
            : const Text(
                'Simpan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}