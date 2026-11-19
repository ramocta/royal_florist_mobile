import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/struk_model.dart';
import '../../services/struk_service.dart';
import 'struk_style.dart';

/// Tabel daftar produk pada struk.
class StrukTable extends StatelessWidget {
  const StrukTable({super.key, required this.struk});

  final StrukModel struk;

  static String _rp(int v) => StrukService.rp(v);

  @override
  Widget build(BuildContext context) {
    final headStyle = GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: StrukStyle.dark,
    );
    final cellStyle = GoogleFonts.poppins(
      fontSize: 12,
      color: StrukStyle.grey,
    );
    final boldStyle = GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: StrukStyle.dark,
    );

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: StrukStyle.tableHeader,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(flex: 30, child: Text('Produk', style: headStyle)),
              Expanded(
                flex: 17,
                child: Text(
                  'Jumlah',
                  textAlign: TextAlign.center,
                  style: headStyle,
                ),
              ),
              Expanded(
                flex: 20,
                child: Text(
                  'Harga',
                  textAlign: TextAlign.right,
                  style: headStyle,
                ),
              ),
              Expanded(
                flex: 22,
                child: Text(
                  'Subtotal',
                  textAlign: TextAlign.right,
                  style: headStyle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        ...struk.items.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 30,
                  child: Text(
                    e.nama,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: StrukStyle.dark,
                    ),
                  ),
                ),
                Expanded(
                  flex: 17,
                  child: Text(
                    '${e.qty}',
                    textAlign: TextAlign.center,
                    style: cellStyle,
                  ),
                ),
                Expanded(
                  flex: 20,
                  child: Text(
                    _rp(e.harga),
                    textAlign: TextAlign.right,
                    style: cellStyle,
                  ),
                ),
                Expanded(
                  flex: 22,
                  child: Text(
                    _rp(e.subtotal),
                    textAlign: TextAlign.right,
                    style: boldStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
