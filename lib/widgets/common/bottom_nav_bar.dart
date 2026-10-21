// Navigasi bawah 5 menu

import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'asset_icon.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.currentIndex, this.onTap});

  final int currentIndex;

  /// Kalau null, pindah halaman lewat named route di [routes].
  final ValueChanged<int>? onTap;

  // TODO: samakan dengan nama route di core/app_router.dart
  static const routes = [
    '/beranda',
    '/update-stok',
    '/status-order',
    '/ringkasan',
    '/profil',
  ];

  static const _items = [
    _NavItem('Beranda', 'assets/icons/home.png', Icons.home_rounded),
    _NavItem('Update Stok', 'assets/icons/stok-icon.png', Icons.inventory_2_outlined),
    _NavItem('Status Order', 'assets/icons/order-icon.png', Icons.receipt_long_outlined),
    _NavItem('Ringkasan', 'assets/icons/ringkasan.png', Icons.bar_chart_rounded),
    _NavItem('Profil', 'assets/icons/profil.png', Icons.person_outline),
  ];

  void _handleTap(BuildContext context, int i) {
    if (i == currentIndex) return;
    if (onTap != null) {
      onTap!(i);
    } else {
      Navigator.of(context).pushReplacementNamed(routes[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final active = i == currentIndex;
              final color = active ? AppColors.maroon : AppColors.black;
              return Expanded(
                child: InkWell(
                  onTap: () => _handleTap(context, i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AssetIcon(item.asset, size: 24, color: color, fallback: item.fallback),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.asset, this.fallback);
  final String label;
  final String asset;
  final IconData fallback;
}