import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../../providers/stok_provider.dart';
import '../beranda/beranda_style.dart';

Future<String?> tampilkanFilterStatus(BuildContext context, String terpilih) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Status',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.maroon,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in StokProvider.opsiStatus)
                ChoiceChip(
                  label: Text(s),
                  selected: s == terpilih,
                  showCheckmark: false,
                  selectedColor: BerandaStyle.rose,
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    color: s == terpilih ? Colors.white : AppColors.maroon,
                  ),
                  onSelected: (_) => Navigator.pop(ctx, s),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
