import 'package:flutter/material.dart';

/// Warna & gaya bersama untuk halaman Status Order
/// (disamakan dengan Beranda).
class StatusOrderStyle {
  StatusOrderStyle._();

  static const Color maroon = Color(0xFF800020);
  static const Color rose = Color(0xFFB8305F);
  static const Color roseDark = Color(0xFF9E1B4C);
  static const Color blush = Color(0xFFFBE3EA);
  static const Color muted = Color(0xFF85606C);
  static const Color line = Color(0xFFF6DCE3);

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: 20);

  static List<BoxShadow> get shadow => [
        BoxShadow(
          color: maroon.withValues(alpha: 0.08),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];
}
