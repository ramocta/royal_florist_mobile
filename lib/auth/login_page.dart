import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/shared/app_colors.dart';
import 'auth_provider.dart';

/// Halaman login karyawan Royal Florist.
///
/// Semua posisi dan ukuran di bawah diukur langsung dari foto desain
/// (bingkai 412 x 917). Tampilan diskalakan sesuai lebar layar.
/// Login memakai AuthProvider yang sudah ada (POST /karyawan/login).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Lebar bingkai desain.
  static const double _lebarDesain = 412;
  static const double _tinggiDesain = 917;

  // Warna dari desain.
  static const Color _warnaKartu = Color(0xFFFFACAC);
  static const Color _garisKartu = Color(0xFF727272);
  static const Color _garisInput = Color(0xFF949494);

  // Teks di desain. API login memakai email, jadi isi kolom pertama = email.
  static const String _labelUser = 'Masukan Username Anda';
  static const String _hintUser = 'Masukan Username';

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

    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_user.text, _password.text);
    if (ok && mounted) Navigator.pushReplacementNamed(context, '/beranda');
  }

  // ---------- gaya teks ----------

  TextStyle _poppins(double ukuran, FontWeight berat, Color warna) => TextStyle(
        fontFamily: 'Poppins',
        fontSize: ukuran,
        fontWeight: berat,
        color: warna,
        height: 1.0,
      );

  // Di desain, label & hint kolom password memakai font Inter.
  TextStyle _inter(double ukuran, FontWeight berat, Color warna) => TextStyle(
        fontFamily: 'Inter',
        fontSize: ukuran,
        fontWeight: berat,
        color: warna,
        height: 1.0,
      );

  // ---------- pembantu penempatan ----------

  /// Menaruh teks sehingga garis dasarnya (baseline) tepat di [baseline].
  Widget _teksDiBaseline({
    required double left,
    required double baseline,
    required Widget child,
    double? width,
  }) {
    return Positioned(
      left: left,
      top: 0,
      width: width,
      child: Baseline(
        baseline: baseline,
        baselineType: TextBaseline.alphabetic,
        child: child,
      ),
    );
  }

  Widget _bunga(String nama, double lebar, double tinggi, double s) {
    return IgnorePointer(
      child: Image.asset(
        'assets/login/$nama.png',
        width: lebar * s,
        height: tinggi * s,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _kotakInput({
    required double s,
    required double top,
    required FocusNode fokus,
  }) {
    return Positioned(
      left: 57 * s,
      top: top * s,
      width: 298 * s,
      height: 49 * s,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: fokus.requestFocus,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.5 * s),
            border: Border.all(color: _garisInput, width: 1 * s),
            boxShadow: [
              BoxShadow(
                color: const Color(0x40000000),
                blurRadius: 4 * s,
                offset: Offset(0, 4 * s),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dekorTeks(String hint, TextStyle gaya) => InputDecoration(
        hintText: hint,
        hintStyle: gaya,
        isCollapsed: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      );

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final keyboardTerbuka = MediaQuery.of(context).viewInsets.bottom > 0;
    final pesanError = _pesanLokal ?? auth.error;

    return Scaffold(
      backgroundColor: AppColors.background, // #FFF1F1
      body: LayoutBuilder(
        builder: (context, c) {
          final s = c.maxWidth / _lebarDesain;
          final tinggiKanvas = _tinggiDesain * s;
          final tinggiTotal =
              tinggiKanvas > c.maxHeight ? tinggiKanvas : c.maxHeight;

          return Stack(
            children: [
              // ===== Bunga di empat sudut layar (ukuran asli aset) =====
              Positioned(
                top: 0,
                left: 0,
                child: _bunga('bunga_kiri_atas', 207, 146, s),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: _bunga('bunga_kanan_atas', 205, 165, s),
              ),
              if (!keyboardTerbuka) ...[
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: _bunga('bunga_kiri_bawah', 170, 130, s),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: _bunga('bunga_kanan_bawah', 187, 165, s),
                ),
              ],

              // ===== Isi halaman (kanvas 412 x 917) =====
              SingleChildScrollView(
                child: SizedBox(
                  width: c.maxWidth,
                  height: tinggiTotal,
                  child: Stack(
                    children: [
                      // Logo
                      Positioned(
                        left: 159 * s,
                        top: 106 * s,
                        width: 88 * s,
                        height: 107 * s,
                        child: Image.asset(
                          'assets/login/logo_royal_florist.png',
                          fit: BoxFit.fill,
                        ),
                      ),

                      // Judul: Cormorant Garamond Bold 36
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Baseline(
                          baseline: 278 * s,
                          baselineType: TextBaseline.alphabetic,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'ROYAL FLORIST',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'CormorantGaramond',
                                fontSize: 36 * s,
                                fontWeight: FontWeight.w700,
                                color: AppColors.maroon,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Subjudul: Poppins Regular 16
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Baseline(
                          baseline: 310 * s,
                          baselineType: TextBaseline.alphabetic,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Selamat Datang di Royal Florist',
                              textAlign: TextAlign.center,
                              style: _poppins(
                                15.9 * s,
                                FontWeight.w400,
                                AppColors.maroon,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Kartu form: 367 x 312, border 3, radius 22
                      Positioned(
                        left: 22 * s,
                        top: 353 * s,
                        width: 367 * s,
                        height: 312 * s,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _warnaKartu,
                            borderRadius: BorderRadius.circular(22 * s),
                            border: Border.all(
                              color: _garisKartu,
                              width: 3 * s,
                            ),
                          ),
                        ),
                      ),

                      // ----- Username -----
                      _teksDiBaseline(
                        left: 69 * s,
                        baseline: 395 * s,
                        child: Text(
                          _labelUser,
                          style: _poppins(12 * s, FontWeight.w600, Colors.black),
                        ),
                      ),
                      _kotakInput(s: s, top: 405, fokus: _fokusUser),
                      _teksDiBaseline(
                        left: 82 * s,
                        baseline: 436 * s,
                        width: 249 * s,
                        child: TextField(
                          controller: _user,
                          focusNode: _fokusUser,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => _fokusPassword.requestFocus(),
                          autocorrect: false,
                          cursorColor: AppColors.maroon,
                          style: _poppins(15 * s, FontWeight.w400, Colors.black),
                          decoration: _dekorTeks(
                            _hintUser,
                            _poppins(15 * s, FontWeight.w400, Colors.black),
                          ),
                        ),
                      ),

                      // ----- Password (font Inter sesuai desain) -----
                      _teksDiBaseline(
                        left: 68.5 * s,
                        baseline: 484 * s,
                        child: Text(
                          'Masukkan Password Anda',
                          style: _inter(12 * s, FontWeight.w600, Colors.black),
                        ),
                      ),
                      _kotakInput(s: s, top: 493, fokus: _fokusPassword),
                      _teksDiBaseline(
                        left: 81.5 * s,
                        baseline: 522 * s,
                        width: 224 * s,
                        child: TextField(
                          controller: _password,
                          focusNode: _fokusPassword,
                          obscureText: _sembunyi,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _masuk(),
                          cursorColor: AppColors.maroon,
                          style: _inter(15 * s, FontWeight.w400, Colors.black),
                          decoration: _dekorTeks(
                            'Masukkan Password',
                            _inter(15 * s, FontWeight.w400, Colors.black),
                          ),
                        ),
                      ),

                      // Ikon mata (pusat di x 320.5, y 516)
                      Positioned(
                        left: (320.5 - 20) * s,
                        top: (516 - 20) * s,
                        width: 40 * s,
                        height: 40 * s,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => setState(() => _sembunyi = !_sembunyi),
                          child: Center(
                            child: Icon(
                              _sembunyi
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 24 * s,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      // Tombol Masuk: 203 x 55
                      Positioned(
                        left: 104 * s,
                        top: 579 * s,
                        width: 203 * s,
                        height: 55 * s,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(27.5 * s),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x40000000),
                                blurRadius: 4 * s,
                                offset: Offset(0, 4 * s),
                              ),
                            ],
                          ),
                          child: Material(
                            color: AppColors.maroon,
                            borderRadius: BorderRadius.circular(27.5 * s),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(27.5 * s),
                              onTap: auth.loading ? null : _masuk,
                              child: auth.loading
                                  ? Center(
                                      child: SizedBox(
                                        width: 24 * s,
                                        height: 24 * s,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.expand(),
                            ),
                          ),
                        ),
                      ),
                      if (!auth.loading)
                        Positioned(
                          left: 104 * s,
                          width: 203 * s,
                          top: 0,
                          child: IgnorePointer(
                            child: Baseline(
                              baseline: 614 * s,
                              baselineType: TextBaseline.alphabetic,
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Masuk',
                                  textAlign: TextAlign.center,
                                  style: _poppins(
                                    20 * s,
                                    FontWeight.w600,
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Pesan error (tidak ada di desain, hanya muncul saat gagal)
                      if (pesanError != null)
                        Positioned(
                          left: 22 * s,
                          width: 367 * s,
                          top: 676 * s,
                          child: Text(
                            pesanError,
                            textAlign: TextAlign.center,
                            style: _poppins(
                              12 * s,
                              FontWeight.w500,
                              AppColors.maroon,
                            ).copyWith(height: 1.3),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}