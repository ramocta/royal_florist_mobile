import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../../models/produk_model.dart';
import '../beranda/beranda_style.dart';
import 'produk_foto.dart';

Future<void> tampilkanPeringatanStok(BuildContext context, List<Produk> habis) {
  return showDialog(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stok Habis',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.maroon,
              ),
            ),
            Text(
              habis.isEmpty
                  ? 'Semua produk aktif tersedia.'
                  : '${habis.length} produk perlu diperbarui',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: BerandaStyle.teksRedup,
              ),
            ),
            if (habis.isNotEmpty) ...[
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: habis.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: ProdukFoto(
                      url: habis[i].fotoUrl,
                      lebar: 42,
                      radius: 10,
                    ),
                    title: Text(
                      habis[i].nama,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      habis[i].pakaiStok ? 'Stok 0' : 'Tidak tersedia',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Color(0xFFB3261E),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
