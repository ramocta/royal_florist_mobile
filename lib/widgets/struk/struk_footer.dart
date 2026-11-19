import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'struk_style.dart';

class StrukFooter extends StatelessWidget {
  const StrukFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Terima kasih telah mempercayai',
          style: GoogleFonts.poppins(fontSize: 12, color: StrukStyle.grey),
        ),
        const SizedBox(height: 4),
        Text(
          'Royal Florist',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: StrukStyle.dark,
          ),
        ),
        const SizedBox(height: 10),
        const Icon(Icons.favorite_rounded, color: Color(0xFFE0345A), size: 18),
      ],
    );
  }
}
