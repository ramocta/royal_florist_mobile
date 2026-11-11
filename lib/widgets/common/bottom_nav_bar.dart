import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.currentIndex, this.onTap});

  final int currentIndex;
  final ValueChanged<int>? onTap;

  static const routes = [
    '/beranda',
    '/update-stok',
    '/status-order',
    '/ringkasan',
    '/profil',
  ];

  static const _items = [
    _NavItem('Beranda', Icons.home_outlined, Icons.home_rounded),
    _NavItem(
      'Update Stok',
      Icons.inventory_2_outlined,
      Icons.inventory_2_rounded,
    ),
    _NavItem(
      'Status Order',
      Icons.receipt_long_outlined,
      Icons.receipt_long_rounded,
    ),
    _NavItem('Ringkasan', Icons.bar_chart_outlined, Icons.bar_chart_rounded),
    _NavItem('Profil', Icons.person_outline_rounded, Icons.person_rounded),
  ];

  void _pilih(BuildContext context, int i) {
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.maroon.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            children: [
              for (int i = 0; i < _items.length; i++)
                Expanded(
                  child: _Menu(
                    item: _items[i],
                    aktif: i == currentIndex,
                    onTap: () => _pilih(context, i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu({required this.item, required this.aktif, required this.onTap});

  final _NavItem item;
  final bool aktif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final warna = aktif ? AppColors.maroon : Colors.black54;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 30,
              decoration: BoxDecoration(
                color: aktif
                    ? AppColors.maroon.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                aktif ? item.ikonAktif : item.ikon,
                size: 24,
                color: warna,
              ),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item.label,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: aktif ? FontWeight.w600 : FontWeight.w500,
                    color: warna,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.ikon, this.ikonAktif);

  final String label;
  final IconData ikon;
  final IconData ikonAktif;
}
