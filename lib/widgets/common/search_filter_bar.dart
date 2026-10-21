// Kolom cari + chip filter

import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

/// Kolom pencarian + chip filter. Chip yang punya sub-kategori
/// menampilkan dropdown (mis. Bucket -> Bucket Satin, Bucket Uang, ...).
class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onSearch,
    this.selectedOption,
    this.allLabel = 'Semua',
    this.hint = 'Cari Produk...',
  });

  /// label chip -> daftar sub-kategori
  final Map<String, List<String>> filters;
  final String selectedFilter;
  final String? selectedOption;
  final String allLabel;
  final String hint;
  final void Function(String filter, String? option) onFilterSelected;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.white,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: TextField(
            onChanged: onSearch,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.mauve),
              prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.mauve),
              isDense: true,
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.maroon),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              _chip(
                label: allLabel,
                active: selectedFilter == allLabel,
                onTap: () => onFilterSelected(allLabel, null),
              ),
              for (final entry in filters.entries)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: PopupMenuButton<String>(
                    offset: const Offset(0, 40),
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (o) => onFilterSelected(entry.key, o),
                    itemBuilder: (_) => [
                      for (final o in entry.value)
                        PopupMenuItem<String>(
                          value: o,
                          height: 40,
                          child: Text(
                            o,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: o == selectedOption ? FontWeight.w600 : FontWeight.w400,
                              color: o == selectedOption ? AppColors.maroon : AppColors.ink,
                            ),
                          ),
                        ),
                    ],
                    child: _chip(
                      label: entry.key,
                      active: selectedFilter == entry.key,
                      withArrow: true,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip({
    required String label,
    required bool active,
    bool withArrow = false,
    VoidCallback? onTap,
  }) {
    final fg = active ? AppColors.white : AppColors.maroon;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.maroon : AppColors.pinkSoft,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: fg)),
            if (withArrow) Icon(Icons.keyboard_arrow_down, size: 16, color: fg),
          ],
        ),
      ),
    );
  }
}