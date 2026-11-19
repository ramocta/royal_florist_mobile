import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/struk_model.dart';
import '../../services/struk_service.dart';
import 'struk_brand.dart';
import 'struk_footer.dart';
import 'struk_info_row.dart';
import 'struk_style.dart';
import 'struk_table.dart';

/// Kartu struk berisi brand, info pesanan, tabel produk, total, dan footer.
class StrukReceiptCard extends StatelessWidget {
  const StrukReceiptCard({super.key, required this.struk});

  final StrukModel struk;

  static String _rp(int v) => StrukService.rp(v);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 36, 22, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: const Color(0xFFF3DDE0), width: 1),
            boxShadow: [
              BoxShadow(
                color: StrukStyle.maroon.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const StrukBrand(),
              const SizedBox(height: 26),
              Center(
                child: Text(
                  'STRUK PESANAN',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: StrukStyle.dark,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              StrukInfoRow(label: 'No. Invoice', value: struk.invoice),
              StrukInfoRow(label: 'Tanggal', value: struk.tanggal),
              StrukInfoRow(label: 'Pelanggan', value: struk.pelanggan),
              StrukInfoRow(label: 'Alamat', value: struk.alamat),
              const SizedBox(height: 10),
              const Divider(color: StrukStyle.line, height: 1),
              const SizedBox(height: 32),
              StrukTable(struk: struk),
              const SizedBox(height: 16),
              const Divider(color: StrukStyle.line, height: 1),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: StrukStyle.dark,
                    ),
                  ),
                  Text(
                    _rp(struk.total),
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: StrukStyle.dark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Divider(color: StrukStyle.line, height: 1),
              const SizedBox(height: 28),
              const StrukFooter(),
            ],
          ),
        ),
        Positioned(
          top: -16,
          child: Container(
            width: 38,
            height: 32,
            decoration: BoxDecoration(
              color: StrukStyle.dark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.photo_camera_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}
