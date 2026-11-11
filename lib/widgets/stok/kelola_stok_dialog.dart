import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/shared/app_colors.dart';
import '../../models/produk_model.dart';
import '../../providers/stok_provider.dart';
import '../beranda/beranda_style.dart';
import 'dialog_kelola.dart';

class KelolaStokDialog extends StatefulWidget {
  const KelolaStokDialog({super.key, required this.produk});

  final Produk produk;

  @override
  State<KelolaStokDialog> createState() => _KelolaStokDialogState();
}

class _KelolaStokDialogState extends State<KelolaStokDialog> {
  late final TextEditingController _c = TextEditingController(
    text: '${widget.produk.stok}',
  );
  bool _menyimpan = false;
  String? _error;

  int get _nilai => int.tryParse(_c.text) ?? 0;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _ubah(int selisih) {
    final baru = (_nilai + selisih).clamp(0, 999999).toInt();
    setState(() => _c.text = '$baru');
  }

  Future<void> _simpan() async {
    setState(() {
      _menyimpan = true;
      _error = null;
    });
    final err = await context.read<StokProvider>().simpanStok(
      widget.produk,
      _nilai,
    );
    if (!mounted) return;
    if (err == null) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _menyimpan = false;
        _error = err;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogKelola(
      judul: 'Kelola Stok',
      subjudul: widget.produk.nama,
      info: 'Stok akan diperbarui secara real-time di seluruh sistem.',
      menyimpan: _menyimpan,
      error: _error,
      onSimpan: _simpan,
      isi: [
        RingkasanProduk(
          produk: widget.produk,
          label: 'Stok Saat Ini',
          nilai: TextSpan(
            text: '${widget.produk.stok}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: BerandaStyle.rose,
            ),
            children: const [
              TextSpan(
                text: ' Tangkai',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BerandaStyle.kartu(radius: 20),
          child: Column(
            children: [
              const Text(
                'Atur Jumlah',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _Tombol(Icons.remove_rounded, () => _ubah(-1)),
                  Expanded(
                    child: TextField(
                      controller: _c,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.maroon,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  _Tombol(Icons.add_rounded, () => _ubah(1)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tombol extends StatelessWidget {
  const _Tombol(this.ikon, this.onTap);

  final IconData ikon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BerandaStyle.rose.withValues(alpha: 0.15),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(ikon, color: AppColors.maroon, size: 26),
        ),
      ),
    );
  }
}
