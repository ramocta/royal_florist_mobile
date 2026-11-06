// Figma: Halaman login karyawan
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/shared/app_colors.dart';
import 'auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Lebar frame desain Figma. Semua ukuran di bawah dikali skala layar.
  static const double _designWidth = 420;

  static const Color _cardColor = Color(0xFFFFACAC);
  static const Color _cardBorder = Color(0xFF727272);

  static const String _img = 'assets/login';

  final _usernameC = TextEditingController();
  final _passwordC = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _usernameC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final auth = context.read<AuthProvider>();

    final username = _usernameC.text.trim();
    final password = _passwordC.text;

    if (username.isEmpty || password.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Username dan password harus diisi')),
      );
      return;
    }

    final berhasil = await auth.login(username, password);
    if (!mounted) return;

    if (berhasil) {
      navigator.pushReplacementNamed('/beranda');
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Login gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s =
        (MediaQuery.sizeOf(context).width / _designWidth).clamp(0.8, 1.4).toDouble();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Hiasan bunga di empat sudut
          Positioned(
            left: 0,
            top: 0,
            child: _Flower('$_img/bunga_kiri_atas.png', width: 207 * s),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: _Flower('$_img/bunga_kanan_atas.png', width: 205 * s),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: _Flower('$_img/bunga_kiri_bawah.png', width: 170 * s),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: _Flower('$_img/bunga_kanan_bawah.png', width: 187 * s),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: [
                      SizedBox(height: 82 * s),
                      Image.asset(
                        '$_img/logo_royal_florist.png',
                        width: 88 * s,
                        height: 107 * s,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.local_florist,
                          size: 88 * s,
                          color: AppColors.maroon,
                        ),
                      ),
                      SizedBox(height: 34 * s),
                      Text(
                        'ROYAL FLORIST',
                        style: TextStyle(
                          fontFamily: 'CormorantGaramond',
                          fontWeight: FontWeight.w700,
                          fontSize: 35.5 * s,
                          height: 1.0,
                          color: AppColors.maroon,
                        ),
                      ),
                      SizedBox(height: 9 * s),
                      Text(
                        'Selamat Datang di Royal Florist',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 15.5 * s,
                          color: AppColors.maroon,
                        ),
                      ),
                      SizedBox(height: 38 * s),
                      _buildCard(s),
                      SizedBox(height: 40 * s),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(double s) {
    final loading = context.watch<AuthProvider>().isLoading;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26 * s),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(31 * s, 29 * s, 31 * s, 30 * s),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _cardBorder, width: 3),
        ),
        child: Column(
          children: [
            _FieldLabel('Masukan Username Anda', s: s),
            SizedBox(height: 4 * s),
            _InputField(
              controller: _usernameC,
              hint: 'Masukan Username',
              s: s,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16 * s),
            _FieldLabel('Masukkan Password Anda', s: s),
            SizedBox(height: 4 * s),
            _InputField(
              controller: _passwordC,
              hint: 'Masukkan Password',
              s: s,
              obscure: _obscure,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _login(),
              suffix: IconButton(
                splashRadius: 20,
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 24,
                  color: AppColors.black,
                ),
              ),
            ),
            SizedBox(height: 36 * s),
            SizedBox(
              width: 203 * s,
              height: 55 * s,
              child: ElevatedButton(
                onPressed: loading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  disabledBackgroundColor: AppColors.maroon.withValues(alpha: 0.7),
                  foregroundColor: AppColors.white,
                  elevation: 6,
                  shadowColor: Colors.black.withValues(alpha: 0.45),
                  shape: const StadiumBorder(),
                ),
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.white,
                        ),
                      )
                    : const Text(
                        'Masuk',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          color: AppColors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gambar hiasan bunga; kalau file belum ada, tidak menampilkan apa-apa.
class _Flower extends StatelessWidget {
  const _Flower(this.path, {required this.width});

  final String path;
  final double width;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Image.asset(
        path,
        width: width,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {required this.s});

  final String text;
  final double s;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 14 * s),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    required this.s,
    this.obscure = false,
    this.suffix,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final double s;
  final bool obscure;
  final Widget? suffix;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  static const TextStyle _style = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: Color(0xFF111111),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51 * s,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26 * s),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 26 * s),
              child: TextField(
                controller: controller,
                obscureText: obscure,
                textInputAction: textInputAction,
                onSubmitted: onSubmitted,
                style: _style,
                cursorColor: AppColors.maroon,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: _style,
                  isCollapsed: true,
                  // Font Poppins tampak sedikit turun; digeser naik agar pas di tengah.
                  contentPadding: EdgeInsets.only(bottom: 5 * s),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          if (suffix != null) Padding(
            padding: const EdgeInsets.only(right: 8),
            child: suffix,
          ),
        ],
      ),
    );
  }
}