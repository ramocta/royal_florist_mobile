import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'struk_style.dart';

/// Tombol aksi di bawah struk: Cetak dan Kirim ke WhatsApp.
class StrukButtons extends StatelessWidget {
  const StrukButtons({
    super.key,
    required this.onCetak,
    required this.onKirimWa,
  });

  final VoidCallback onCetak;
  final VoidCallback onKirimWa;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tombol Cetak (sesuai desain)
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              onPressed: onCetak,
              icon: const Icon(Icons.print_rounded),
              label: Text(
                'Cetak',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: StrukStyle.maroon,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Tombol Kirim WhatsApp
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              onPressed: onKirimWa,
              icon: const Icon(Icons.chat_rounded),
              label: Text(
                'Kirim ke WhatsApp',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: StrukStyle.maroon,
                side: const BorderSide(color: StrukStyle.maroon, width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
