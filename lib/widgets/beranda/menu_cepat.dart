import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../common/asset_icon.dart';
import 'beranda_style.dart';

class MenuCepat extends StatelessWidget {
  const MenuCepat({
    super.key,
    required this.onUpdateStok,
    required this.onStatusOrder,
    required this.onProfil,
  });

  final VoidCallback onUpdateStok;
  final VoidCallback onStatusOrder;
  final VoidCallback onProfil;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _item(
            'assets/icons/stok-icon.png',
            Icons.inventory_2_outlined,
            'Update Stok',
            onUpdateStok,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _item(
            'assets/icons/order-icon.png',
            Icons.receipt_long_outlined,
            'Status Order',
            onStatusOrder,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _item(
            'assets/icons/profil.png',
            Icons.person_outline,
            'Profil',
            onProfil,
          ),
        ),
      ],
    );
  }

  Widget _item(
    String asset,
    IconData fallback,
    String label,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BerandaStyle.kartu(radius: 22),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          splashColor: BerandaStyle.rose.withValues(alpha: 0.12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                AssetIcon(
                  asset,
                  size: 34,
                  color: AppColors.maroon,
                  fallback: fallback,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.maroon,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
