import 'package:flutter/material.dart';

import 'status_order_style.dart';

/// Baris chip filter status dengan badge jumlah pesanan.
class StatusOrderFilters extends StatelessWidget {
  const StatusOrderFilters({
    super.key,
    required this.filters,
    required this.selected,
    required this.countOf,
    required this.onSelected,
  });

  final List<String> filters;
  final String selected;
  final int Function(String filter) countOf;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: StatusOrderStyle.pagePadding,
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = filters[index];
          final aktif = selected == item;

          return Material(
            color: aktif ? StatusOrderStyle.maroon : Colors.white,
            shape: StadiumBorder(
              side: BorderSide(
                color: aktif
                    ? StatusOrderStyle.maroon
                    : const Color(0xFFF0C9D3),
              ),
            ),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => onSelected(item),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 8, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: aktif ? Colors.white : const Color(0xFF5E1A2E),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 22,
                      constraints: const BoxConstraints(minWidth: 22),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: aktif
                            ? Colors.white.withValues(alpha: 0.22)
                            : StatusOrderStyle.blush,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        '${countOf(item)}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: aktif
                              ? Colors.white
                              : StatusOrderStyle.maroon,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
