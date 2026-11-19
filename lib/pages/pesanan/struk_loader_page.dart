import 'package:flutter/material.dart';

import '../../core/api/api_client.dart';
import '../../core/shared/app_colors.dart';
import '../../models/struk_model.dart';
import 'struk_page.dart';

/// Memuat data pesanan dari server (GET /orders/{id}),
/// lalu menampilkan StrukPage dengan data asli.
class StrukLoaderPage extends StatefulWidget {
  final dynamic idOrder;

  const StrukLoaderPage({super.key, required this.idOrder});

  @override
  State<StrukLoaderPage> createState() => _StrukLoaderPageState();
}

class _StrukLoaderPageState extends State<StrukLoaderPage> {
  StrukModel? _struk;
  String? _error;
  bool _memuat = true;

  @override
  void initState() {
    super.initState();
    _muat();
  }

  Future<void> _muat() async {
    setState(() {
      _memuat = true;
      _error = null;
    });

    try {
      dynamic res = await ApiClient.get('/orders/${widget.idOrder}');
      if (res is Map && res['data'] is Map) res = res['data'];

      if (res is! Map) {
        throw Exception('Data pesanan tidak valid');
      }

      final struk = StrukModel.fromOrder(Map<String, dynamic>.from(res));
      if (!mounted) return;
      setState(() {
        _struk = struk;
        _memuat = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _memuat = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_struk != null) return StrukPage(struk: _struk!);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.maroon),
        title: const Text(
          'Cetak Struk',
          style: TextStyle(
            color: AppColors.maroon,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: _memuat
            ? const CircularProgressIndicator(color: AppColors.maroon)
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 50, color: AppColors.red),
                    const SizedBox(height: 12),
                    const Text(
                      'Gagal memuat struk',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.maroon,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _muat,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}