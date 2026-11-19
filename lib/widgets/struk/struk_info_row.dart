import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'struk_style.dart';

class StrukInfoRow extends StatelessWidget {
  const StrukInfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.poppins(fontSize: 12.5, color: StrukStyle.grey),
            ),
          ),
          Text(
            ': ',
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: StrukStyle.dark,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: StrukStyle.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
