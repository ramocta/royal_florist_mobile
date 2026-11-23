import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

/// Halaman login karyawan Royal Florist (tampilan baru: pink elegan).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ---------- warna ----------
  static const Color _marun = Color(0xFF8A0E2B);
  static const Color _marunGelap = Color(0xFF6E0019);
  static const Color _pinkTombol = Color(0xFFD94A6A);
  static const Color _pinkGaris = Color(0xFFF2A6B8);
  static const Color _emas = Color(0xFFC9946E);

  // ---------- aset ----------
  static const String _asetLogo = 'assets/login/logo.png';

  final _user = TextEditingController();
  final _password = TextEditingController();
  final _fokusUser = FocusNode();
  final _fokusPassword = FocusNode();
  bool _sembunyi = true;
  String? _pesanLokal;

  @override
  void dispose() {
    _user.dispose();
    _password.dispose();
    _fokusUser.dispose();
    _fokusPassword.dispose();
    super.dispose();
  }

  Future<void> _masuk() async {
    FocusScope.of(context).unfocus();

    if (_user.text.trim().isEmpty || _password.text.isEmpty) {
      setState(() => _pesanLokal = 'Username dan password wajib diisi');
      return;
    }
    setState(() => _pesanLokal = null);

    // API login memakai email, jadi isi kolom pertama = email.
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_user.text, _password.text);
    if (ok && mounted) Navigator.pushReplacementNamed(context, '/beranda');
  }

  // ---------- gaya teks ----------

  TextStyle _poppins(double ukuran, FontWeight berat, Color warna) =>
      TextStyle(
        fontFamily: 'Poppins',
        fontSize: ukuran,
        fontWeight: berat,
        color: warna,
      );

  TextStyle _serif(double ukuran, Color warna,
          {FontWeight berat = FontWeight.w700,
          FontStyle gaya = FontStyle.normal,
          double jarak = 0}) =>
      TextStyle(
        fontFamily: 'CormorantGaramond',
        fontSize: ukuran,
        fontWeight: berat,
        fontStyle: gaya,
        letterSpacing: jarak,
        color: warna,
      );

  // ---------- potongan tampilan ----------

  Widget _logo(double s) {
    return Image.asset(
      _asetLogo,
      width: 104 * s,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.local_florist_rounded,
        size: 90 * s,
        color: _marun,
      ),
    );
  }

  Widget _judul(double s) {
    final besar = _serif(44 * s, _marun, jarak: 1);
    final kecil = _serif(33 * s, _marun, jarak: 1);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(text: 'R', style: besar),
          TextSpan(text: 'OYAL ', style: kecil),
          TextSpan(text: 'F', style: besar),
          TextSpan(text: 'LORIST', style: kecil),
        ],
      ),
    );
  }

  Widget _garisHias(double s, {double lebar = 220}) {
    Widget garis() => Expanded(
          child: Container(height: 1.2, color: _marun.withOpacity(0.75)),
        );
    return SizedBox(
      width: lebar * s,
      child: Row(
        children: [
          garis(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10 * s),
            child: Icon(Icons.local_florist_rounded, size: 22 * s, color: _marun),
          ),
          garis(),
        ],
      ),
    );
  }

  Widget _lingkaranIkon(double s, IconData ikon) {
    return Container(
      width: 52 * s,
      height: 52 * s,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFE3EA), Color(0xFFF7B8C8)],
        ),
        border: Border.all(color: _pinkGaris, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: _pinkTombol.withOpacity(0.25),
            blurRadius: 8 * s,
            offset: Offset(0, 3 * s),
          ),
        ],
      ),
      child: Icon(ikon, size: 26 * s, color: _marun),
    );
  }

  Widget _barisInput({
    required double s,
    required IconData ikon,
    required String label,
    required String hint,
    required TextEditingController ctrl,
    required FocusNode fokus,
    required TextInputAction aksi,
    required ValueChanged<String> onSubmit,
    bool sandi = false,
    TextInputType? tipe,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Transform.translate(
          offset: Offset(0, 3 * s),
          child: _lingkaranIkon(s, ikon),
        ),
        SizedBox(width: 12 * s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4 * s, bottom: 6 * s),
                child: Text(
                  label,
                  style: _poppins(12.5 * s, FontWeight.w600, _marun),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: fokus.requestFocus,
                child: Container(
                  height: 46 * s,
                  padding: EdgeInsets.only(left: 18 * s, right: 12 * s),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.78),
                    borderRadius: BorderRadius.circular(23 * s),
                    border: Border.all(color: _pinkGaris, width: 1.3),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: ctrl,
                          focusNode: fokus,
                          obscureText: sandi && _sembunyi,
                          keyboardType: tipe,
                          textInputAction: aksi,
                          onSubmitted: onSubmit,
                          autocorrect: false,
                          enableSuggestions: !sandi,
                          cursorColor: _marun,
                          style: _poppins(
                              14 * s, FontWeight.w400, const Color(0xFF2C1820)),
                          decoration: InputDecoration(
                            hintText: hint,
                            hintStyle: _poppins(
                                14 * s, FontWeight.w400, const Color(0xFF8A8A8A)),
                            isCollapsed: true,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 12 * s),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      if (sandi)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => setState(() => _sembunyi = !_sembunyi),
                          child: Padding(
                            padding: EdgeInsets.all(4 * s),
                            child: Icon(
                              _sembunyi
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 24 * s,
                              color: const Color(0xFF555555),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tombolMasuk(double s, bool loading) {
    return Container(
      height: 54 * s,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27 * s),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_pinkTombol, _marun, _marunGelap],
          stops: [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: _marun.withOpacity(0.35),
            blurRadius: 14 * s,
            offset: Offset(0, 6 * s),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(27 * s),
          onTap: loading ? null : _masuk,
          child: Center(
            child: loading
                ? SizedBox(
                    width: 24 * s,
                    height: 24 * s,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Masuk',
                        style:
                            _poppins(20 * s, FontWeight.w600, Colors.white),
                      ),
                      SizedBox(width: 10 * s),
                      Icon(Icons.arrow_forward_rounded,
                          size: 24 * s, color: Colors.white),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _kartu(double s, AuthProvider auth) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30 * s),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.fromLTRB(18 * s, 26 * s, 18 * s, 28 * s),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30 * s),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.62),
                const Color(0xFFFFE4EA).withOpacity(0.55),
              ],
            ),
            border: Border.all(color: _emas.withOpacity(0.7), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: _pinkTombol.withOpacity(0.18),
                blurRadius: 24 * s,
                offset: Offset(0, 10 * s),
              ),
            ],
          ),
          child: Column(
            children: [
              _barisInput(
                s: s,
                ikon: Icons.person_rounded,
                label: 'Masukkan Username Anda',
                hint: 'Masukkan Username',
                ctrl: _user,
                fokus: _fokusUser,
                tipe: TextInputType.emailAddress,
                aksi: TextInputAction.next,
                onSubmit: (_) => _fokusPassword.requestFocus(),
              ),
              SizedBox(height: 22 * s),
              _barisInput(
                s: s,
                ikon: Icons.lock_rounded,
                label: 'Masukkan Password Anda',
                hint: 'Masukkan Password',
                ctrl: _password,
                fokus: _fokusPassword,
                sandi: true,
                aksi: TextInputAction.done,
                onSubmit: (_) => _masuk(),
              ),
              SizedBox(height: 28 * s),
              _tombolMasuk(s, auth.loading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footer(double s) {
    return Column(
      children: [
        Icon(Icons.local_florist_rounded, size: 18 * s, color: _marun),
        SizedBox(height: 2 * s),
        SizedBox(
          width: 300 * s,
          child: Row(
            children: [
              Expanded(
                  child: Container(height: 1.2, color: _marun.withOpacity(0.7))),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12 * s),
                child: Text(
                  'Royal Florist',
                  style: _serif(18 * s, _marun,
                      berat: FontWeight.w600,
                      gaya: FontStyle.italic,
                      jarak: 2),
                ),
              ),
              Expanded(
                  child: Container(height: 1.2, color: _marun.withOpacity(0.7))),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final pesanError = _pesanLokal ?? auth.error;

    return Scaffold(
      backgroundColor: const Color(0xFFFCE3EA),
      body: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: _LatarPainter())),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, c) {
                final s = (c.maxWidth / 412).clamp(0.8, 1.25).toDouble();
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: c.maxHeight),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22 * s),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 28 * s),
                              _logo(s),
                              SizedBox(height: 10 * s),
                              _judul(s),
                              SizedBox(height: 6 * s),
                              _garisHias(s),
                              SizedBox(height: 10 * s),
                              Text(
                                'Selamat Datang di Royal Florist',
                                textAlign: TextAlign.center,
                                style: _serif(23 * s, _marun,
                                    berat: FontWeight.w600,
                                    gaya: FontStyle.italic),
                              ),
                              SizedBox(height: 28 * s),
                              _kartu(s, auth),
                              if (pesanError != null) ...[
                                SizedBox(height: 14 * s),
                                Text(
                                  pesanError,
                                  textAlign: TextAlign.center,
                                  style: _poppins(
                                          12 * s, FontWeight.w500, _marun)
                                      .copyWith(height: 1.3),
                                ),
                              ],
                              SizedBox(height: 26 * s),
                              _footer(s),
                              SizedBox(height: 40 * s),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
//  Latar belakang: gradasi pink, gelombang bergaris emas, daun & kelopak
// =====================================================================
class _LatarPainter extends CustomPainter {
  const _LatarPainter();

  static const Color _emas = Color(0xFFC9946E);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final s = w / 412;
    final rect = Offset.zero & size;

    // --- dasar gradasi ---
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFCE6EC), Color(0xFFFBDEE6), Color(0xFFF9D3DD)],
        ).createShader(rect),
    );

    // --- gelombang kiri atas (pink tua) ---
    final blob = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.60, 0)
      ..cubicTo(w * 0.32, h * 0.02, w * 0.06, h * 0.07, 0, h * 0.16)
      ..close();
    canvas.drawPath(
      blob,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFCF5F7C), Color(0x00F4B6C5)],
        ).createShader(Rect.fromLTWH(0, 0, w * 0.6, h * 0.17)),
    );

    // --- gelombang putih transparan + garis emas di atas ---
    final garisAtas = Path()
      ..moveTo(0, h * 0.145)
      ..cubicTo(w * 0.18, h * 0.03, w * 0.50, h * 0.085, w * 0.72, h * 0.03)
      ..cubicTo(w * 0.84, h * 0.008, w * 0.94, h * 0.012, w, 0);
    final isiAtas = Path.from(garisAtas)
      ..lineTo(w, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(isiAtas, Paint()..color = Colors.white.withOpacity(0.30));
    canvas.drawPath(
      garisAtas,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3
        ..color = _emas.withOpacity(0.85),
    );

    // --- gelombang kanan bawah (pink tua) + garis emas ---
    final garisBawah = Path()
      ..moveTo(w * 0.26, h)
      ..cubicTo(w * 0.45, h * 0.955, w * 0.70, h * 0.975, w, h * 0.915);
    final isiBawah = Path.from(garisBawah)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(
      isiBawah,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x00F4B6C5), Color(0xFFD16E88)],
        ).createShader(Rect.fromLTWH(w * 0.26, h * 0.91, w * 0.74, h * 0.09)),
    );
    canvas.drawPath(
      garisBawah,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3
        ..color = _emas.withOpacity(0.85),
    );

    // --- ranting daun ---
    _ranting(canvas, Offset(w + 4 * s, h * 0.26), math.pi * 1.16, 1.15 * s);
    _ranting(canvas, Offset(w + 4 * s, h * 0.935), math.pi * 1.22, 1.0 * s);
    _ranting(canvas, Offset(-4 * s, h * 0.985), -0.95, 0.95 * s);

    // --- kelopak melayang ---
    _kelopak(canvas, Offset(w * 0.84, h * 0.095), 0.7, 17 * s);
    _kelopak(canvas, Offset(w * 0.12, h * 0.19), -0.8, 14 * s);
    _kelopak(canvas, Offset(w * 0.06, h * 0.335), 0.5, 15 * s);
    _kelopak(canvas, Offset(w * 0.93, h * 0.385), -0.6, 14 * s);
    _kelopak(canvas, Offset(w * 0.16, h * 0.90), 0.4, 17 * s);
  }

  void _ranting(Canvas canvas, Offset asal, double sudut, double skala) {
    final arah = Offset(math.cos(sudut), math.sin(sudut));
    final panjang = 120 * skala;
    final ujung = asal + arah * panjang;

    canvas.drawLine(
      asal,
      ujung,
      Paint()
        ..color = const Color(0xFFE88DA4).withOpacity(0.75)
        ..strokeWidth = 1.6 * skala
        ..strokeCap = StrokeCap.round,
    );

    final daun = Paint()..color = const Color(0xFFF2A3B8).withOpacity(0.62);
    for (var i = 0; i < 5; i++) {
      final t = (i + 1) / 5.4;
      final titik = asal + arah * (panjang * t);
      final sisi = i.isEven ? 1.0 : -1.0;
      _daun(canvas, titik, sudut + sisi * 0.75, 52 * skala * (1 - 0.1 * i), daun);
    }
    _daun(canvas, ujung, sudut, 40 * skala, daun);
  }

  void _daun(Canvas canvas, Offset titik, double sudut, double panjang,
      Paint cat) {
    canvas.save();
    canvas.translate(titik.dx, titik.dy);
    canvas.rotate(sudut);
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(panjang * 0.5, -panjang * 0.30, panjang, 0)
      ..quadraticBezierTo(panjang * 0.5, panjang * 0.30, 0, 0);
    canvas.drawPath(path, cat);
    canvas.restore();
  }

  void _kelopak(Canvas canvas, Offset pusat, double sudut, double r) {
    canvas.save();
    canvas.translate(pusat.dx, pusat.dy);
    canvas.rotate(sudut);
    final path = Path()
      ..moveTo(0, -r)
      ..cubicTo(r * 0.95, -r * 0.55, r * 0.75, r * 0.75, 0, r)
      ..cubicTo(-r * 0.75, r * 0.75, -r * 0.95, -r * 0.55, 0, -r)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF9A9BF), Color(0xFFE0607F)],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: r)),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}