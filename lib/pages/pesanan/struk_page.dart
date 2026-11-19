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
      body: SafeArea(
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
              onKirimWa: () => _kirimWa(context),
            ),
          ],
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

  Future<void> _kirimWa(BuildContext context) async {
    try {
      final ok = await StrukService.kirimWhatsApp(struk);
      if (!ok) _snack(context, 'WhatsApp tidak bisa dibuka');
    } catch (e) {
      _snack(context, 'Gagal membuka WhatsApp: $e');
    }
  }
}
