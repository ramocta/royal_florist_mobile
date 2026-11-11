import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _sembunyi = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _masuk() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_email.text, _password.text);
    if (ok && mounted) Navigator.pushReplacementNamed(context, '/beranda');
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    const maroon = Color(0xFF8B1A3A);

    return Scaffold(
      backgroundColor: const Color(0xFFFFEEEE),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  'Royal Florist',
                  style: TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: maroon,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Masuk sebagai karyawan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 28),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _dekor('Email'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _password,
                  obscureText: _sembunyi,
                  onSubmitted: (_) => _masuk(),
                  decoration: _dekor('Password').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _sembunyi ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _sembunyi = !_sembunyi),
                    ),
                  ),
                ),
                if (auth.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      auth.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: maroon),
                    onPressed: auth.loading ? null : _masuk,
                    child: auth.loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Masuk',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _dekor(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}
