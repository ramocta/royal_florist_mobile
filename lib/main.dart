import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/auth_provider.dart';
import 'auth/login_page.dart';
import 'core/app_theme.dart';
import 'pages/beranda/beranda_page.dart';
import 'pages/stok/update_stok_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Royal Florist',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/beranda': (_) => const BerandaPage(),
        '/update-stok': (_) => const UpdateStokPage(),
        // Halaman di bawah belum dibuat; diganti halaman sementara
        // supaya tombol navigasi bawah tidak membuat aplikasi error.
        '/status-order': (_) => const _SegeraPage('Status Order'),
        '/ringkasan': (_) => const _SegeraPage('Ringkasan'),
        '/profil': (_) => const _SegeraPage('Profil'),
      },
    );
  }
}

/// Halaman sementara untuk menu yang belum selesai dibuat.
class _SegeraPage extends StatelessWidget {
  const _SegeraPage(this.judul);

  final String judul;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Halaman $judul belum dibuat'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/beranda'),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }
}