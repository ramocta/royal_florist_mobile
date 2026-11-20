import 'package:flutter/material.dart';

/// Fungsi bantu untuk memformat data pesanan di halaman Status Order.
class StatusOrderHelper {
  StatusOrderHelper._();

  static String status(dynamic value) {
    final status = (value ?? '').toString().toLowerCase();

    switch (status) {
      case 'menunggu_pembayaran':
        return 'Menunggu Pembayaran';
      case 'menunggu_dikonfirmasi':
      case 'menunggu_konfirmasi':
        return 'Menunggu Konfirmasi';
      case 'dikonfirmasi':
      case 'diproses':
      case 'dalam_pengiriman':
        return 'Diproses';
      case 'siap_diambil':
        return 'Siap Diambil';
      case 'selesai':
        return 'Selesai';
      case 'dibatalkan':
        return 'Dibatalkan';
      default:
        return value?.toString() ?? 'Belum diketahui';
    }
  }

  static MaterialColor statusColor(String status) {
    switch (status) {
      case 'Menunggu Pembayaran':
      case 'Menunggu Konfirmasi':
        return Colors.orange;
      case 'Diproses':
        return Colors.blue;
      case 'Siap Diambil':
        return Colors.purple;
      case 'Selesai':
        return Colors.green;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Mencari nilai total: coba nama field umum dulu, lalu field apa pun
  /// yang namanya mengandung "total" / "harga" / "bayar".
  static dynamic ambilTotal(Map<String, dynamic> order) {
    const kunci = [
      'total_harga',
      'total_bayar',
      'total_pembayaran',
      'grand_total',
      'total',
      'jumlah_bayar',
      'harga_total',
    ];
    for (final k in kunci) {
      final v = order[k];
      if (v != null && v.toString().isNotEmpty) return v;
    }
    for (final e in order.entries) {
      final k = e.key.toLowerCase();
      if ((k.contains('total') || k.contains('harga') || k.contains('bayar')) &&
          num.tryParse(e.value?.toString() ?? '') != null) {
        return e.value;
      }
    }
    return null;
  }

  static String rupiah(dynamic value) {
    // num.tryParse supaya "250000.00" tidak menjadi 0
    final number = (num.tryParse(value?.toString() ?? '') ?? 0).toInt();
    final formatted = number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'Rp $formatted';
  }

  static String tanggal(dynamic value) {
    if (value == null) return '-';
    try {
      final date = DateTime.parse(value.toString());
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return value.toString();
    }
  }
}