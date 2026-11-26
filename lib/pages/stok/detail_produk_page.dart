import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/shared/app_colors.dart';
import '../../models/produk_draft.dart';
import '../../models/produk_model.dart';
import '../../providers/stok_provider.dart';
import '../../widgets/beranda/beranda_style.dart';
import '../../widgets/common/latar_pink.dart';
import '../../widgets/stok/form_produk.dart';
import '../../widgets/stok/konfirmasi_hapus.dart';

class DetailProdukPage extends StatefulWidget {
  const DetailProdukPage({super.key, required this.produk});

  final Produk produk;

  @override
  State<DetailProdukPage> createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {
  late final ProdukDraft _draft;
  bool _menyimpan = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _draft = ProdukDraft.dariProduk(
      widget.produk,
      context.read<StokProvider>().kategori,
    );
  }

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    final salah = _draft.validasi();
    if (salah != null) {
      setState(() => _error = salah);
      return;
    }
    setState(() {
      _menyimpan = true;
      _error = null;
    });
    final err = await context.read<StokProvider>().ubahProduk(
      widget.produk.id,
      _draft.toMap(),
      _draft.foto,
    );
    if (!mounted) return;
    if (err == null) {
      Navigator.pop(context, 'Produk berhasil diperbarui');
    } else {
      setState(() {
        _menyimpan = false;
        _error = err;
      });
    }
  }

  Future<void> _hapus() async {
    if (!await konfirmasiHapus(context, widget.produk) || !mounted) return;
    setState(() {
      _menyimpan = true;
      _error = null;
    });
    final err = await context.read<StokProvider>().hapus(widget.produk);
    if (!mounted) return;
    if (err == null) {
      Navigator.pop(context, '${widget.produk.nama} dihapus');
    } else {
      setState(() {
        _menyimpan = false;
        _error = err;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final kategori = context.watch<StokProvider>().kategori;

    return Scaffold(
      backgroundColor: BerandaStyle.latarBawah,
      body: LatarPink(
        child: SafeArea(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BerandaStyle.kartu(radius: 22),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.maroon,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Edit Produk',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.maroon,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              FormProduk(
                draft: _draft,
                kategori: kategori,
                terkunci: _menyimpan,
                onUbah: () => setState(() {}),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFB3261E),
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: _menyimpan ? null : _simpan,
                child: _menyimpan
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Simpan perubahan'),
              ),
              TextButton(
                onPressed: _menyimpan ? null : _hapus,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFB3261E),
                ),
                child: const Text('Hapus produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
