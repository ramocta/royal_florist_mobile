import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';

class BerandaStyle {
  BerandaStyle._();

  static const Color rose = Color(0xFFC8365F);
  static const Color roseSoft = Color(0xFFF2A3B8);
  static const Color latarAtas = Color(0xFFFCF0F3);
  static const Color latarBawah = Color(0xFFFFFBFC);
  static const Color teksGelap = Color(0xFF2B0F18);
  static const Color teksRedup = Color(0xFF8A5A68);
  static const Color judul = AppColors.maroon;

  static BoxDecoration kartu({double radius = 20}) => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.94),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: rose.withValues(alpha: 0.08)),
    boxShadow: [
      BoxShadow(
        color: rose.withValues(alpha: 0.12),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}
