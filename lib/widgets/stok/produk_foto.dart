import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProdukFoto extends StatelessWidget {
  const ProdukFoto({
    super.key,
    this.url,
    this.bytes,
    this.lebar = 92,
    this.tinggi,
    this.radius = 16,
  });

  final String? url;
  final Uint8List? bytes;
  final double lebar;
  final double? tinggi;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final t = tinggi ?? lebar;
    final Widget isi;
    if (bytes != null) {
      isi = Image.memory(bytes!, fit: BoxFit.cover);
    } else if (url != null) {
      isi = Image.network(
        url!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _kosong(),
      );
    } else {
      isi = _kosong();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(width: lebar, height: t, child: isi),
    );
  }

  Widget _kosong() => const DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFE1E9), Color(0xFFF7B7C8)],
      ),
    ),
    child: Center(
      child: Icon(Icons.local_florist_rounded, color: Colors.white, size: 32),
    ),
  );
}
