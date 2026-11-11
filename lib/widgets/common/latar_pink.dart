import 'package:flutter/material.dart';

import '../beranda/beranda_style.dart';

class LatarPink extends StatelessWidget {
  const LatarPink({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [BerandaStyle.latarAtas, BerandaStyle.latarBawah],
              ),
            ),
          ),
        ),
        const Positioned(top: -70, right: -50, child: _Cahaya(240)),
        const Positioned(bottom: 120, left: -90, child: _Cahaya(260)),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _Cahaya extends StatelessWidget {
  const _Cahaya(this.ukuran);

  final double ukuran;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: ukuran,
        height: ukuran,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              BerandaStyle.rose.withValues(alpha: 0.07),
              BerandaStyle.rose.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
