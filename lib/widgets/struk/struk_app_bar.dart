import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'struk_style.dart';

class StrukAppBar extends StatelessWidget {
  const StrukAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: StrukStyle.maroon,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Cetak Struk',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: StrukStyle.maroon,
            ),
          ),
        ],
      ),
    );
  }
}
