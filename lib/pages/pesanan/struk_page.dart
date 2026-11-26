// Figma: Struk
import 'package:flutter/material.dart';

import '../../models/struk_model.dart';
import '../../services/struk_service.dart';
import '../../widgets/struk/struk_app_bar.dart';
import '../../widgets/struk/struk_buttons.dart';
import '../../widgets/struk/struk_receipt_card.dart';
import '../../widgets/struk/struk_style.dart';

class StrukPage extends StatelessWidget {
  final StrukModel struk;

  const StrukPage({super.key, this.struk = StrukModel.contoh});

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: StrukStyle.bg,
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFCE4EA),
            Color(0xFFFFF0F3),
            Color(0xFFFFFAFA),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const StrukAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 16),
                child: StrukReceiptCard(struk: struk),
              ),
            ),
            StrukButtons(
              onCetak: () => _cetak(context),
            ),
          ],
        ),
      ),
    ),
  );
}

  // =================================================================
  // AKSI
  // =================================================================
  void _snack(BuildContext context, String pesan) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  Future<void> _cetak(BuildContext context) async {
    try {
      await StrukService.cetak(struk);
    } catch (e) {
      _snack(context, 'Gagal mencetak: $e');
    }
  }
}
