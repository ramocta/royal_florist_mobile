import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/struk_model.dart';

class StrukService {
  StrukService._();

  // ---------------------------------------------------------------
  // Util
  // ---------------------------------------------------------------
  static String rp(int v) {
    final s = v.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (m) => '${m[1]}.',
        );
    return 'Rp$s';
  }

  // ---------------------------------------------------------------
  // CETAK (printer atau simpan PDF)
  // ---------------------------------------------------------------
  static Future<Uint8List> buatPdf(StrukModel s) async {
    final doc = pw.Document();

    pw.Widget baris(String kiri, String kanan, {bool boldKanan = false}) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(kiri, style: const pw.TextStyle(fontSize: 9)),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(
                kanan,
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight:
                      boldKanan ? pw.FontWeight.bold : pw.FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget garis() => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 6),
          child: pw.Divider(
            height: 1,
            thickness: 0.6,
            borderStyle: pw.BorderStyle.dashed,
          ),
        );

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(12),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Center(
              child: pw.Text('ROYAL FLORIST',
                  style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 1.5)),
            ),
            pw.Center(
              child: pw.Text('Fresh Flowers, Better Feelings',
                  style: pw.TextStyle(
                      fontSize: 8, fontStyle: pw.FontStyle.italic)),
            ),
            garis(),
            pw.Center(
              child: pw.Text('STRUK PESANAN',
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 6),
            baris('No. Invoice', s.invoice, boldKanan: true),
            baris('Tanggal', s.tanggal, boldKanan: true),
            baris('Pelanggan', s.pelanggan, boldKanan: true),
            baris('Alamat', s.alamat, boldKanan: true),
            garis(),
            for (final e in s.items) ...[
              pw.Text(e.nama,
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
              baris('${e.qty} x ${rp(e.harga)}', rp(e.subtotal)),
              pw.SizedBox(height: 4),
            ],
            garis(),
            baris('Subtotal Produk', rp(s.subtotal)),
            baris('Ongkos Kirim', rp(s.ongkir)),
            garis(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('TOTAL',
                    style: pw.TextStyle(
                        fontSize: 12, fontWeight: pw.FontWeight.bold)),
                pw.Text(rp(s.total),
                    style: pw.TextStyle(
                        fontSize: 12, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            garis(),
            pw.SizedBox(height: 4),
            pw.Center(
              child: pw.Text(
                'Terima kasih telah mempercayai\nRoyal Florist',
                style: const pw.TextStyle(fontSize: 8),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );

    return doc.save();
  }

  /// Membuka dialog cetak. Di dalamnya bisa pilih printer,
  /// atau pilih "Save as PDF" untuk menyimpan sebagai file PDF.
  static Future<void> cetak(StrukModel s) async {
    await Printing.layoutPdf(
      name: s.invoice,
      onLayout: (_) => buatPdf(s),
    );
  }
}