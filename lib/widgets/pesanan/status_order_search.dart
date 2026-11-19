import 'package:flutter/material.dart';

import 'status_order_style.dart';

class StatusOrderSearch extends StatelessWidget {
  const StatusOrderSearch({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: StatusOrderStyle.shadow,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13, color: StatusOrderStyle.maroon),
        decoration: const InputDecoration(
          hintText: 'Cari invoice atau nama pelanggan',
          hintStyle: TextStyle(color: StatusOrderStyle.muted, fontSize: 13),
          prefixIcon: Icon(Icons.search, color: StatusOrderStyle.maroon),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
