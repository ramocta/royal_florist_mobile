import 'package:flutter/material.dart';

import '../../models/produk_model.dart';

Future<bool> konfirmasiHapus(BuildContext context, Produk produk) async {
  final ya = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Hapus produk?'),
      content: Text(
        '${produk.nama} akan dihapus dari sistem, web admin, dan katalog pelanggan.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Batal'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFB3261E),
          ),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );
  return ya == true;
}
