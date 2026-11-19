import 'package:flutter/material.dart';

import 'status_order_style.dart';

class StatusOrderHeader extends StatelessWidget {
  const StatusOrderHeader({
    super.key,
    required this.onBack,
    required this.onRefresh,
  });

  final VoidCallback onBack;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          _RoundButton(
            icon: Icons.arrow_back_ios_new_rounded,
            size: 18,
            tooltip: 'Kembali',
            onTap: onBack,
          ),
          const Expanded(
            child: Column(
              children: [
                Text(
                  'Status Order',
                  style: TextStyle(
                    color: StatusOrderStyle.maroon,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Royal Florist',
                  style: TextStyle(color: StatusOrderStyle.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          _RoundButton(
            icon: Icons.refresh_rounded,
            tooltip: 'Muat ulang',
            onTap: onRefresh,
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.size = 22,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: StatusOrderStyle.shadow,
      ),
      child: IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        onPressed: onTap,
        icon: Icon(icon, size: size, color: StatusOrderStyle.maroon),
      ),
    );
  }
}
