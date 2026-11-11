import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../beranda/beranda_style.dart';

class StokSearchBar extends StatelessWidget {
  const StokSearchBar({
    super.key,
    required this.onUbah,
    required this.onFilter,
    required this.filterAktif,
  });

  final ValueChanged<String> onUbah;
  final VoidCallback onFilter;
  final bool filterAktif;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BerandaStyle.kartu(radius: 18),
            child: TextField(
              onChanged: onUbah,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Cari Produk...',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: BerandaStyle.teksRedup,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: BerandaStyle.teksRedup,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onFilter,
          child: SizedBox(
            width: 52,
            height: 52,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BerandaStyle.kartu(radius: 18),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: AppColors.maroon,
                  ),
                ),
                if (filterAktif)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: BerandaStyle.rose,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
