import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';

void tampilkanInfo(BuildContext context, String pesan, {bool galat = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(pesan),
        behavior: SnackBarBehavior.floating,
        backgroundColor: galat ? const Color(0xFFB3261E) : AppColors.maroon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
}
