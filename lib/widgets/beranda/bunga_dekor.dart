import 'dart:math' as math;

import 'package:flutter/material.dart';

class BungaDekor extends StatelessWidget {
  const BungaDekor({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(painter: _BungaPainter(), size: Size.infinite);
  }
}

class _BungaPainter extends CustomPainter {
  const _BungaPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _mawar(
      canvas,
      Offset(size.width * .55, size.height * .30),
      size.width * .30,
      0.3,
    );
    _mawar(
      canvas,
      Offset(size.width * .22, size.height * .78),
      size.width * .26,
      0.9,
    );
    _mawar(
      canvas,
      Offset(size.width * .86, size.height * .80),
      size.width * .24,
      1.6,
    );
  }

  void _mawar(Canvas c, Offset o, double r, double putar) {
    c.drawCircle(
      o.translate(0, 3),
      r * .95,
      Paint()
        ..color = const Color(0x33C8365F)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    _kelopak(c, o, 7, r * .50, r * .56, const Color(0xFFF9C4D2), putar);
    _kelopak(c, o, 5, r * .42, r * .34, const Color(0xFFF3A0B8), putar + .5);
    _kelopak(c, o, 4, r * .32, r * .18, const Color(0xFFE8708F), putar + 1);
    c.drawCircle(o, r * .20, Paint()..color = const Color(0xFFC8365F));
    c.drawCircle(
      o.translate(-r * .05, -r * .05),
      r * .08,
      Paint()..color = Colors.white.withValues(alpha: .35),
    );
  }

  void _kelopak(
    Canvas c,
    Offset o,
    int n,
    double rKel,
    double jarak,
    Color warna,
    double putar,
  ) {
    final isi = Paint()..color = warna;
    final garis = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: .55);
    for (int i = 0; i < n; i++) {
      final a = putar + 2 * math.pi * i / n;
      final p = o + Offset(math.cos(a), math.sin(a)) * jarak;
      c.drawCircle(p, rKel, isi);
      c.drawCircle(p, rKel, garis);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
