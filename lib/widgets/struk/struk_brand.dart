import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'struk_style.dart';

class StrukBrand extends StatelessWidget {
  const StrukBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'ROYAL FLORIST',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: StrukStyle.dark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Fresh Flowers, Better Feelings',
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontStyle: FontStyle.italic,
            color: StrukStyle.grey,
          ),
        ),
      ],
    );
  }
}
