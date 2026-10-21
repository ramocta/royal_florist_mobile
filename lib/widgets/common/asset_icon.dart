import 'package:flutter/material.dart';

/// Ikon dari assets/icons dengan fallback Material Icon
/// bila file belum ada (supaya aplikasi tidak error).
class AssetIcon extends StatelessWidget {
  const AssetIcon(
    this.path, {
    super.key,
    this.size = 24,
    this.color,
    this.fallback = Icons.circle_outlined,
  });

  final String path;
  final double size;
  final Color? color;
  final IconData fallback;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size,
      height: size,
      color: color,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(fallback, size: size, color: color),
    );
  }
}