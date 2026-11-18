import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

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

  /// 0812... -> 62812...
  static String normalisasiNomor(String input) {
    var n = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (n.startsWith('0')) n = '62${n.substring(1)}';
    return n;
  }

  // ---------------------------------------------------------------
  // CETAK (printer atau simpan PDF)
  // ---------------------------------------------------------------
  static Future<Uint8List> buatPdf(StrukModel s) async {
    final doc = pw.Document();

    pw.Widget baris(String kiri, String kanan, {bool bold = false}) {
      final style = pw.TextStyle(
        fontSize: 9,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      );
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [pw.Text(kiri, style: style), pw.Text(kanan, style: style)],
      );
    }

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
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Center(
              child: pw.Text('Fresh Flowers, Better Feelings',
                  style: const pw.TextStyle(fontSize: 8)),
            ),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text('STRUK PESANAN',
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 8),
            baris('No. Invoice', s.invoice),
            baris('Tanggal', s.tanggal),
            baris('Pelanggan', s.pelanggan),
            baris('Alamat', s.alamat),
            pw.Divider(),
            for (final e in s.items) ...[
              pw.Text(e.nama, style: const pw.TextStyle(fontSize: 9)),
              baris('${e.qty} x ${rp(e.harga)}', rp(e.subtotal)),
              pw.SizedBox(height: 4),
            ],
            pw.Divider(),
            baris('TOTAL', rp(s.total), bold: true),
            pw.SizedBox(height: 12),
            pw.Center(
              child: pw.Text('Terima kasih telah mempercayai Royal Florist',
                  style: const pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.center),
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

  // ---------------------------------------------------------------
  // WHATSAPP
  // ---------------------------------------------------------------
  static String teksStruk(StrukModel s) {
    final sb = StringBuffer()
      ..writeln('*ROYAL FLORIST*')
      ..writeln('_Fresh Flowers, Better Feelings_')
      ..writeln()
      ..writeln('*STRUK PESANAN*')
      ..writeln('No. Invoice : ${s.invoice}')
      ..writeln('Tanggal     : ${s.tanggal}')
      ..writeln('Pelanggan   : ${s.pelanggan}')
      ..writeln()
      ..writeln('*Rincian:*');
    for (final e in s.items) {
      sb.writeln('- ${e.nama} (${e.qty} x ${rp(e.harga)}) = ${rp(e.subtotal)}');
    }
    sb
      ..writeln()
      ..writeln('*Total: ${rp(s.total)}*')
      ..writeln()
      ..writeln('Terima kasih telah mempercayai Royal Florist 🌸');
    return sb.toString();
  }

  /// Membuka WhatsApp ke nomor pelanggan dengan isi struk sudah terisi.
  static Future<bool> kirimWhatsApp(StrukModel s) async {
    final nomor = normalisasiNomor(s.noWa);
    final uri = Uri.parse(
      'https://wa.me/$nomor?text=${Uri.encodeComponent(teksStruk(s))}',
    );
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
