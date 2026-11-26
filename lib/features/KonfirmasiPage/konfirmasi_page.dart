import 'dart:typed_data'; // [BARU]

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // [BARU]
import '../../core/app_colors.dart';
import '../../pages/pesanan/pesanan_berhasil_page.dart';

// [BARU] Data form, dikirim ke onSimpan supaya bisa disambung ke API tim.
class KonfirmasiData {
  final String status;
  final String? namaKurir;
  final String? noHpKurir;
  final String? estimasiTiba;
  final Uint8List? fotoBytes;
  final String? pesan;

  const KonfirmasiData({
    required this.status,
    this.namaKurir,
    this.noHpKurir,
    this.estimasiTiba,
    this.fotoBytes,
    this.pesan,
  });
}

class KonfirmasiPage extends StatefulWidget {
  final String invoice;
  final String nama;
  final String tanggal;
  final String total;
  final dynamic idOrder; // [BARU] dipakai halaman sukses untuk membuka struk
  final String? statusLabel; // [BARU] badge kanan atas, null = disembunyikan
  final bool dikirim; // [BARU] true: opsi ke-3 "Dalam Pengiriman"
  final Future<void> Function(KonfirmasiData data)? onSimpan; // [BARU]

  const KonfirmasiPage({
    super.key,
    this.invoice = 'INV-20261004-001',
    this.nama = 'Siti Maisyaroh',
    this.tanggal = '04 Okt 2026 • 14:32',
    this.total = 'Rp75.000',
    this.idOrder, // [BARU]
    this.statusLabel, // [BARU]
    this.dikirim = false, // [BARU] false = perilaku lama (Siap Diambil)
    this.onSimpan, // [BARU]
  });

  @override
  State<KonfirmasiPage> createState() => _KonfirmasiPageState();
}

class _KonfirmasiPageState extends State<KonfirmasiPage> {
  // [UBAH KECIL] dari static const jadi getter, supaya opsi ke-3 bisa
  // "Dalam Pengiriman" atau "Siap Diambil". Isi lain tetap sama.
  List<String> get _statusList => [
        'Dikonfirmasi',
        'Diproses',
        widget.dikirim ? 'Dalam Pengiriman' : 'Siap Diambil',
        'Selesai',
        'Dibatalkan',
      ];

  String _selected = 'Dikonfirmasi';
  final _catatanCtrl = TextEditingController();

  // [BARU]
  final _formKey = GlobalKey<FormState>();
  final _kurirCtrl = TextEditingController();
  final _hpCtrl = TextEditingController();
  final _estimasiCtrl = TextEditingController();
  Uint8List? _foto;

  bool get _perluKurir => widget.dikirim && _selected == 'Dalam Pengiriman';

  @override
  void dispose() {
    _catatanCtrl.dispose();
    _kurirCtrl.dispose(); // [BARU]
    _hpCtrl.dispose(); // [BARU]
    _estimasiCtrl.dispose(); // [BARU]
    super.dispose();
  }

  // [BARU]
  Future<void> _pilihFoto() async {
    final file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (mounted) setState(() => _foto = bytes);
  }

  // [UBAH KECIL] jadi async + validasi + panggil onSimpan.
  // Navigasi ke PesananBerhasilPage tetap sama seperti kodemu.
  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    String? isi(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();

    try {
      await widget.onSimpan?.call(KonfirmasiData(
      status: _selected,
      namaKurir: _perluKurir ? isi(_kurirCtrl) : null,
      noHpKurir: _perluKurir ? isi(_hpCtrl) : null,
      estimasiTiba: _perluKurir ? isi(_estimasiCtrl) : null,
      fotoBytes: _foto,
      pesan: isi(_catatanCtrl),
    ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
      return;
    }
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PesananBerhasilPage(
          idOrder: widget.idOrder, // [BARU]
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
          child: Form(
            // [BARU] pembungkus Form untuk validasi
            key: _formKey,
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
                // [BARU] keterangan kecil di bawah pilihan status
                const Text(
                  'Pilihan ke-3: Dikirim → Dalam Pengiriman, Ambil di Toko → Siap Diambil',
                  style: TextStyle(fontSize: 10, color: AppColors.muted),
                ),
                // [BARU] info kurir, hanya saat "Dalam Pengiriman"
                if (_perluKurir) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Info Kurir (muncul saat Dalam Pengiriman)',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  _kurirField('Nama Kurir', _kurirCtrl, wajib: true),
                  _kurirField('No. HP Kurir', _hpCtrl,
                      wajib: true, tipe: TextInputType.phone),
                  _kurirField('Estimasi Tiba', _estimasiCtrl,
                      hint: 'Contoh: 12:00 WIB'),
                ],
                // [BARU] foto buket
                const SizedBox(height: 24),
                const Text(
                  'Foto Buket (opsional)',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 12),
                _uploadFoto(),
                const SizedBox(height: 24),
                // [UBAH KECIL] judul & hint disesuaikan dengan desain Figma
                const Text(
                  'Pesan untuk Pelanggan (opsional)',
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
        // [UBAH KECIL] dibungkus Expanded supaya badge bisa di kanan
        Expanded(
          child: Column(
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
        ),
        // [BARU] badge status
        if (widget.statusLabel != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0A8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.statusLabel!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B4E00),
              ),
            ),
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

  // [BARU] kolom isian info kurir
  Widget _kurirField(
    String label,
    TextEditingController ctrl, {
    bool wajib = false,
    TextInputType? tipe,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl,
            keyboardType: tipe,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(color: AppColors.muted, fontSize: 13),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.maroon),
              ),
            ),
            validator: wajib
                ? (v) => (v == null || v.trim().isEmpty)
                    ? '$label wajib diisi'
                    : null
                : null,
          ),
        ],
      ),
    );
  }

  // [BARU] kotak unggah foto bergaris putus-putus
  Widget _uploadFoto() {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: _pilihFoto,
      child: CustomPaint(
        painter: _DashedBorderPainter(color: AppColors.maroon),
        child: Container(
          height: 120,
          width: double.infinity,
          alignment: Alignment.center,
          child: _foto != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.memory(_foto!,
                      fit: BoxFit.cover, width: double.infinity, height: 120),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColors.selectedBg,
                      child: Icon(Icons.add,
                          color: AppColors.maroon, size: 20),
                    ),
                    SizedBox(height: 8),
                    Text('Lampirkan foto buket',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.maroon)),
                    SizedBox(height: 2),
                    Text('Foto tampil di kartu pesanan pelanggan',
                        style:
                            TextStyle(fontSize: 10, color: AppColors.muted)),
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
        // [UBAH KECIL] hint sesuai desain
        hintText:
            'Contoh: Buketnya sudah rapi, kurir sedang menuju alamat Anda.',
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

// [BARU] pelukis garis putus-putus untuk kotak foto
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  const _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Offset.zero & size, const Radius.circular(14)));
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 6), paint);
        d += 10;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color;
}