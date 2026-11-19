import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../models/profil_model.dart';
import '../../providers/profil_provider.dart';
import '../../widgets/common/bottom_nav_bar.dart';

/// Halaman Profil karyawan Royal Florist.
/// Lokasi: lib/pages/profil/profil_page.dart
class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  // Warna disamakan dengan Beranda & Status Order
  static const Color _maroon = Color(0xFF800020);
  static const Color _roseDark = Color(0xFF9E1B4C);
  static const Color _rose = Color(0xFFB8305F);
  static const Color _blush = Color(0xFFFBE3EA);
  static const Color _fieldFill = Color(0xFFFDE9EE);
  static const Color _muted = Color(0xFF85606C);
  static const Color _teks = Color(0xFF5E1A2E);

  static const EdgeInsets _pad = EdgeInsets.symmetric(horizontal: 20);

  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nama = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _telepon = TextEditingController();
  final TextEditingController _alamat = TextEditingController();

  final FocusNode _fokusNama = FocusNode();
  final FocusNode _fokusEmail = FocusNode();
  final FocusNode _fokusTelepon = FocusNode();
  final FocusNode _fokusAlamat = FocusNode();

  static const List<String> _opsiGender = ['Laki-laki', 'Perempuan'];
  final List<int> _opsiUmur = List.generate(66, (i) => i + 15); // 15–80

  String? _gender;
  int? _umur;
  XFile? _foto;
  Uint8List? _fotoBytes;
  bool _berubah = false;

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _muat());
  }

  @override
  void dispose() {
    for (final c in [_nama, _email, _telepon, _alamat]) {
      c.dispose();
    }
    for (final f in [_fokusNama, _fokusEmail, _fokusTelepon, _fokusAlamat]) {
      f.dispose();
    }
    super.dispose();
  }

  // ───────────────────────── DATA ─────────────────────────

  Future<void> _muat() async {
    final provider = context.read<ProfilProvider>();
    await provider.muat();
    if (!mounted) return;
    _isiForm(provider.profil);
  }

  void _isiForm(ProfilModel? p) {
    if (p == null) return;
    setState(() {
      _nama.text = p.nama;
      _email.text = p.email;
      _telepon.text = p.telepon;
      _alamat.text = p.alamat;
      _gender = p.jenisKelamin;
      _umur = _opsiUmur.contains(p.umur) ? p.umur : null;
      _berubah = false;
    });
  }

  Future<void> _simpan() async {
    FocusScope.of(context).unfocus();

    if (_nama.text.trim().isEmpty) {
      _snack('Nama lengkap wajib diisi');
      return;
    }

    final provider = context.read<ProfilProvider>();
    final baru = ProfilModel(
      nama: _nama.text.trim(),
      email: _email.text.trim(),
      telepon: _telepon.text.trim(),
      alamat: _alamat.text.trim(),
      jenisKelamin: _gender,
      umur: _umur,
    );

    final ok = await provider.simpan(baru, foto: _foto);
    if (!mounted) return;

    if (ok) {
      _foto = null;
      _fotoBytes = null;
      _isiForm(provider.profil);
      _snack('Profil berhasil diperbarui');
    } else {
      _snack(provider.error ?? 'Gagal menyimpan profil');
    }
  }

  void _snack(String pesan) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  // ───────────────────────── AKSI ─────────────────────────

  void _kembali() {
    Navigator.pushReplacementNamed(context, '/beranda');
  }

  void _tandaiBerubah() {
    if (!_berubah) setState(() => _berubah = true);
  }

  Future<void> _ambilFoto(ImageSource sumber) async {
    try {
      final hasil = await _picker.pickImage(
        source: sumber,
        imageQuality: 80,
        maxWidth: 1024,
      );
      if (hasil == null || !mounted) return;
      final bytes = await hasil.readAsBytes();
      if (!mounted) return;
      setState(() {
        _foto = hasil;
        _fotoBytes = bytes;
        _berubah = true;
      });
    } catch (e) {
      if (!mounted) return;
      _snack('Gagal mengambil foto: $e');
    }
  }

  Future<void> _konfirmasiKeluar() async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Keluar dari akun?',
          style: TextStyle(color: _maroon, fontWeight: FontWeight.w600),
        ),
        content: const Text('Anda perlu masuk lagi untuk memakai aplikasi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: _muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Keluar',
              style: TextStyle(color: _maroon, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (yakin != true || !mounted) return;

    // Hapus token di memori, lalu jalankan alur "tidak terautentikasi"
    // yang dipasang di main.dart (ApiClient.onUnauthorized).
    ApiClient.token = null;
    final callback = ApiClient.onUnauthorized;
    if (callback != null) {
      callback();
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _dialogGantiFoto() {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Ganti Foto Profil',
                      style: TextStyle(
                        color: _maroon,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tutup',
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded, color: _maroon),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              _avatar(96, kamera: true),
              const SizedBox(height: 24),
              _tombolFoto(
                label: 'Pilih dari Galeri',
                ikon: Icons.image_rounded,
                terisi: true,
                onTap: () {
                  Navigator.pop(ctx);
                  _ambilFoto(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 12),
              _tombolFoto(
                label: 'Buka Kamera',
                ikon: Icons.photo_camera_rounded,
                terisi: false,
                onTap: () {
                  Navigator.pop(ctx);
                  _ambilFoto(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────── BUILD ─────────────────────────

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProfilProvider>();

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
          bottomNavigationBar: const BottomNavBar(currentIndex: 4),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildIsi(p)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIsi(ProfilProvider p) {
    if (p.loading && p.profil == null) {
      return const Center(child: CircularProgressIndicator(color: _maroon));
    }

    if (p.profil == null && p.error != null) {
      return ListView(
        padding: _pad,
        children: [
          const SizedBox(height: 40),
          Container(
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
                  'Gagal memuat profil',
                  style: TextStyle(
                    color: _maroon,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  p.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _muat,
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
        ],
      );
    }

    return RefreshIndicator(
      color: _maroon,
      onRefresh: _muat,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 4, bottom: 24),
        children: [
          _buildIdentitas(p),
          const SizedBox(height: 20),
          Padding(padding: _pad, child: _kartuAkun()),
          const SizedBox(height: 16),
          Padding(padding: _pad, child: _kartuTambahan()),
          const SizedBox(height: 20),
          Padding(
            padding: _pad,
            child: _berubah
                ? _tombolUtama(
                    label: 'Simpan Perubahan',
                    ikon: Icons.check_rounded,
                    loading: p.saving,
                    onTap: _simpan,
                  )
                : _tombolUtama(
                    label: 'Keluar',
                    ikon: Icons.logout_rounded,
                    onTap: _konfirmasiKeluar,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Kembali',
            onPressed: _kembali,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: _maroon,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'Profil',
            style: TextStyle(
              color: _maroon,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentitas(ProfilProvider p) {
    final nama = _nama.text.isEmpty ? '-' : _nama.text;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        const Positioned(left: 28, top: 22, child: _Bintang(ukuran: 30)),
        const Positioned(right: 24, top: 34, child: _Bintang(ukuran: 34)),
        Column(
          children: [
            _avatar(112, kamera: true, bisaDiketuk: true),
            const SizedBox(height: 14),
            Text(
              nama,
              style: const TextStyle(
                color: _maroon,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (_email.text.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.mail_rounded, size: 15, color: _maroon),
                  const SizedBox(width: 6),
                  Text(
                    _email.text,
                    style: const TextStyle(color: _maroon, fontSize: 12),
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }

  // ───────────────────────── KARTU ─────────────────────────

  Widget _kartuAkun() {
    return _kartu(
      judul: 'Informasi Akun',
      ikon: Icons.person_rounded,
      children: [
        _fieldTeks(
          label: 'Nama Lengkap',
          ikon: Icons.person_rounded,
          controller: _nama,
          fokus: _fokusNama,
          onChanged: () => setState(() => _berubah = true),
        ),
        _fieldTeks(
          label: 'Email',
          ikon: Icons.mail_rounded,
          controller: _email,
          fokus: _fokusEmail,
          tipe: TextInputType.emailAddress,
          onChanged: () => setState(() => _berubah = true),
        ),
        _fieldTeks(
          label: 'No. Telepon',
          ikon: Icons.phone_rounded,
          controller: _telepon,
          fokus: _fokusTelepon,
          tipe: TextInputType.phone,
          onChanged: _tandaiBerubah,
        ),
      ],
    );
  }

  Widget _kartuTambahan() {
    return _kartu(
      judul: 'Informasi Tambahan',
      ikon: Icons.description_rounded,
      children: [
        _fieldTeks(
          label: 'Alamat',
          ikon: Icons.location_on_rounded,
          controller: _alamat,
          fokus: _fokusAlamat,
          tipe: TextInputType.multiline,
          maxLines: 3,
          onChanged: _tandaiBerubah,
        ),
        _fieldDropdown<String>(
          label: 'Jenis Kelamin',
          ikon: Icons.person_rounded,
          nilai: _gender,
          pilihan: _opsiGender,
          tampil: (v) => v,
          onChanged: (v) => setState(() {
            _gender = v;
            _berubah = true;
          }),
        ),
        _fieldDropdown<int>(
          label: 'Umur',
          ikon: Icons.calendar_today_outlined,
          nilai: _umur,
          pilihan: _opsiUmur,
          tampil: (v) => '$v Tahun',
          onChanged: (v) => setState(() {
            _umur = v;
            _berubah = true;
          }),
        ),
      ],
    );
  }

  Widget _kartu({
    required String judul,
    required IconData ikon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: _shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ikon, size: 20, color: _maroon),
              const SizedBox(width: 8),
              Text(
                judul,
                style: const TextStyle(
                  color: _maroon,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  // ───────────────────────── FIELD ─────────────────────────

  Widget _kotakField({required String label, required Widget isi}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
      decoration: BoxDecoration(
        color: _fieldFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _roseDark,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          isi,
        ],
      ),
    );
  }

  Widget _fieldTeks({
    required String label,
    required IconData ikon,
    required TextEditingController controller,
    required FocusNode fokus,
    required VoidCallback onChanged,
    TextInputType? tipe,
    int maxLines = 1,
  }) {
    return _kotakField(
      label: label,
      isi: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(ikon, size: 16, color: _maroon),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: fokus,
              keyboardType: tipe,
              minLines: 1,
              maxLines: maxLines,
              onChanged: (_) => onChanged(),
              cursorColor: _maroon,
              style: const TextStyle(
                color: _teks,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Ubah $label',
            onPressed: fokus.requestFocus,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 36, height: 36),
            icon: const Icon(Icons.edit_rounded, size: 16, color: _rose),
          ),
        ],
      ),
    );
  }

  Widget _fieldDropdown<T>({
    required String label,
    required IconData ikon,
    required T? nilai,
    required List<T> pilihan,
    required String Function(T) tampil,
    required ValueChanged<T> onChanged,
  }) {
    return _kotakField(
      label: label,
      isi: Row(
        children: [
          Icon(ikon, size: 16, color: _maroon),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: nilai,
                isExpanded: true,
                isDense: true,
                borderRadius: BorderRadius.circular(14),
                dropdownColor: Colors.white,
                hint: const Text(
                  'Belum diisi',
                  style: TextStyle(color: _muted, fontSize: 12.5),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _muted,
                ),
                style: const TextStyle(
                  color: _teks,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
                items: [
                  for (final item in pilihan)
                    DropdownMenuItem<T>(value: item, child: Text(tampil(item))),
                ],
                onChanged: (v) {
                  if (v != null) onChanged(v);
                },
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  // ───────────────────────── AVATAR & TOMBOL ─────────────────────────

  Widget _fotoPlaceholder(double ukuran) {
    return Container(
      color: _blush,
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        size: ukuran * 0.55,
        color: _maroon.withValues(alpha: 0.65),
      ),
    );
  }

  Widget _isiFoto(double ukuran) {
    if (_fotoBytes != null) {
      return Image.memory(
        _fotoBytes!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    final url = context.read<ProfilProvider>().profil?.fotoUrl;
    if (url != null && url.startsWith('http')) {
      return Image.network(
        url,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fotoPlaceholder(ukuran),
      );
    }

    return _fotoPlaceholder(ukuran);
  }

  Widget _avatar(double ukuran, {bool kamera = false, bool bisaDiketuk = false}) {
    final isi = SizedBox(
      width: ukuran,
      height: ukuran,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFF0C9D3), width: 2),
            ),
            child: ClipOval(child: _isiFoto(ukuran)),
          ),
          if (kamera)
            Positioned(
              right: 0,
              bottom: 2,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _maroon,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.photo_camera_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );

    if (!bisaDiketuk) return isi;

    return Semantics(
      button: true,
      label: 'Ganti foto profil',
      child: GestureDetector(onTap: _dialogGantiFoto, child: isi),
    );
  }

  Widget _tombolFoto({
    required String label,
    required IconData ikon,
    required bool terisi,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Material(
        color: terisi ? const Color(0xFFFFC7D4) : Colors.white,
        shape: StadiumBorder(
          side: terisi
              ? BorderSide.none
              : const BorderSide(color: Color(0xFFF0A9BC), width: 1.5),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(ikon, size: 20, color: _maroon),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: _maroon,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tombolUtama({
    required String label,
    required IconData ikon,
    required VoidCallback onTap,
    bool loading = false,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: _maroon.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: _maroon,
        borderRadius: BorderRadius.circular(26),
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: loading ? null : onTap,
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(ikon, size: 20, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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

/// Hiasan bintang empat sudut di sisi atas halaman (sesuai desain).
class _Bintang extends StatelessWidget {
  final double ukuran;
  const _Bintang({required this.ukuran});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size(ukuran, ukuran),
        painter: _BintangPainter(),
      ),
    );
  }
}

class _BintangPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final k = r * 0.22;

    final path = Path()
      ..moveTo(c.dx, c.dy - r)
      ..quadraticBezierTo(c.dx + k, c.dy - k, c.dx + r, c.dy)
      ..quadraticBezierTo(c.dx + k, c.dy + k, c.dx, c.dy + r)
      ..quadraticBezierTo(c.dx - k, c.dy + k, c.dx - r, c.dy)
      ..quadraticBezierTo(c.dx - k, c.dy - k, c.dx, c.dy - r)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeJoin = StrokeJoin.round
        ..color = const Color(0xFFE9A9BA),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}