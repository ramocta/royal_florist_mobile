import 'package:flutter/material.dart';

class Muncul extends StatelessWidget {
  const Muncul({super.key, required this.child, this.urutan = 0});

  final Widget child;
  final int urutan;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + urutan * 110),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, v, c) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 22 * (1 - v)), child: c),
      ),
    );
  }
}
