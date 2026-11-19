import 'package:flutter/material.dart';

import '../beranda/beranda_style.dart';

/// Warna & ikon khusus halaman Ringkasan, dipusatkan di sini
/// supaya perubahan tampilan cukup di satu file.
class RingkasanTema {
  RingkasanTema._();

  static const Color hijau = Color(0xFF2E7D32);
  static const Color merah = Color(0xFFC62828);
  static const Color amber = Color(0xFFD98A00);
  static const Color biru = Color(0xFF1E6FB8);

  // ---------- Kartu statistik (key dari API) ----------
  static Color aksenCard(String key) {
    switch (key) {
      case 'pesanan_masuk':
        return BerandaStyle.rose;
      case 'dalam_proses':
        return amber;
      case 'selesai':
        return hijau;
      case 'dibatalkan':
        return merah;
      default:
        return BerandaStyle.teksRedup;
    }
  }

  static IconData ikonCard(String key) {
    switch (key) {
      case 'pesanan_masuk':
        return Icons.shopping_bag_outlined;
      case 'dalam_proses':
        return Icons.hourglass_top_rounded;
      case 'selesai':
        return Icons.check_circle_outline_rounded;
      case 'dibatalkan':
        return Icons.cancel_outlined;
      default:
        return Icons.bar_chart_rounded;
    }
  }

  /// Hijau = kabar baik, merah = kabar buruk.
  /// Khusus "dibatalkan", kenaikan justru dianggap buruk.
  static Color warnaTrend(String key, String trend) {
    if (trend == 'flat') return BerandaStyle.teksRedup;
    final naikBagus = key != 'dibatalkan';
    final bagus = (trend == 'up') == naikBagus;
    return bagus ? hijau : merah;
  }

  static IconData ikonTrend(String trend) {
    switch (trend) {
      case 'up':
        return Icons.trending_up_rounded;
      case 'down':
        return Icons.trending_down_rounded;
      default:
        return Icons.trending_flat_rounded;
    }
  }

  // ---------- Status pesanan ----------
  static Color warnaStatus(String status) {
    switch (status) {
      case 'dikonfirmasi':
        return BerandaStyle.rose;
      case 'diproses':
        return amber;
      case 'dikirim':
        return biru;
      case 'selesai':
        return hijau;
      case 'dibatalkan':
        return merah;
      default:
        return BerandaStyle.teksRedup;
    }
  }

  static IconData ikonStatus(String status) {
    switch (status) {
      case 'dikonfirmasi':
        return Icons.receipt_long_rounded;
      case 'diproses':
        return Icons.local_florist_rounded;
      case 'dikirim':
        return Icons.local_shipping_rounded;
      case 'selesai':
        return Icons.check_circle_rounded;
      case 'dibatalkan':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}