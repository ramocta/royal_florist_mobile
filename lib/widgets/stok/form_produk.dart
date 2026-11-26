import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/produk_draft.dart';
import '../../models/produk_model.dart';
import '../beranda/beranda_style.dart';
import 'produk_foto.dart';

/// Isian satu produk. Dipakai oleh halaman tambah (banyak) dan edit.
class FormProduk extends StatelessWidget {
  const FormProduk({
    super.key,
    required this.draft,
    required this.kategori,
    required this.onUbah,
    this.terkunci = false,
  });

  final ProdukDraft draft;
  final List<Kategori> kategori;
  final VoidCallback onUbah;
  final bool terkunci;

  Future<void> _pilihFoto(BuildContext context) async {
    final sumber = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galeri'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (sumber == null) return;
    final f = await ImagePicker().pickImage(
      source: sumber,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (f == null) return;
    draft
      ..foto = f
      ..fotoBytes = await f.readAsBytes();
    onUbah();
  }

  InputDecoration _dekor(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  );

  Widget _pilihan<T>({
    required String label,
    required T? nilai,
    required List<DropdownMenuItem<T>> item,
    required ValueChanged<T?> onPilih,
  }) {
    return InputDecorator(
      decoration: _dekor(label)
          .copyWith(contentPadding: const EdgeInsets.fromLTRB(16, 6, 12, 6)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: item.any((i) => i.value == nilai) ? nilai : null,
          isExpanded: true,
          hint: Text('Pilih ${label.toLowerCase()}'),
          items: item,
          onChanged: terkunci ? null : onPilih,
        ),
      ),
    );
  }

  Widget _segmen(String teks, bool aktif, Color warna, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: terkunci ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: aktif ? warna : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              teks,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: aktif ? Colors.white : BerandaStyle.teksRedup,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final k = draft.kategori;
    final angka = [FilteringTextInputFormatter.digitsOnly];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: terkunci ? null : () => _pilihFoto(context),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              ProdukFoto(
                url: draft.fotoLama,
                bytes: draft.fotoBytes,
                lebar: double.infinity,
                tinggi: 160,
                radius: 20,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: BerandaStyle.rose,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_camera_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _pilihan<Kategori>(
          label: 'Kategori',
          nilai: draft.kategori,
          item: [
            for (final c in kategori)
              DropdownMenuItem(value: c, child: Text(c.nama)),
          ],
          onPilih: (v) {
            draft
              ..kategori = v
              ..sub = null;
            onUbah();
          },
        ),
        if (k != null && k.subs.isNotEmpty) ...[
          const SizedBox(height: 12),
          _pilihan<SubKategori>(
            label: k.subLabel,
            nilai: draft.sub,
            item: [
              for (final s in k.subs)
                DropdownMenuItem(value: s, child: Text(s.nama)),
            ],
            onPilih: (v) {
              draft.sub = v;
              onUbah();
            },
          ),
        ],
        const SizedBox(height: 12),
        if (draft.namaOtomatis)
          InputDecorator(
            decoration: _dekor('Nama produk (otomatis dari jenis)'),
            child: Text(
              draft.teksNamaOtomatis,
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
          )
        else
          TextField(
            controller: draft.nama,
            enabled: !terkunci,
            maxLength: 100,
            onChanged: (_) => onUbah(),
            decoration: _dekor(
              draft.pakaiStok
                  ? 'Nama bunga (mis. Aster, Mawar)'
                  : 'Nama produk',
            ).copyWith(counterText: ''),
          ),
        const SizedBox(height: 12),
        TextField(
          controller: draft.harga,
          enabled: !terkunci,
          keyboardType: TextInputType.number,
          inputFormatters: angka,
          decoration: _dekor('Harga jual (Rp)'),
        ),
        const SizedBox(height: 12),
        if (draft.pakaiStok)
          TextField(
            controller: draft.stok,
            enabled: !terkunci,
            keyboardType: TextInputType.number,
            inputFormatters: angka,
            decoration: _dekor('Stok (${draft.satuan})'),
          )
        else
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BerandaStyle.kartu(radius: 16),
            child: Row(
              children: [
                _segmen(
                  'Tersedia',
                  draft.tersedia,
                  const Color(0xFF1E7A34),
                  () {
                    draft.tersedia = true;
                    onUbah();
                  },
                ),
                const SizedBox(width: 6),
                _segmen(
                  'Tidak tersedia',
                  !draft.tersedia,
                  const Color(0xFFB3261E),
                  () {
                    draft.tersedia = false;
                    onUbah();
                  },
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        TextField(
          controller: draft.deskripsi,
          enabled: !terkunci,
          minLines: 2,
          maxLines: 4,
          decoration: _dekor('Deskripsi (opsional)'),
        ),
        SwitchListTile(
          value: draft.aktif,
          activeThumbColor: BerandaStyle.rose,
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Tampilkan di katalog (aktif)',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
          ),
          onChanged: terkunci
              ? null
              : (v) {
                  draft.aktif = v;
                  onUbah();
                },
        ),
        if (draft.error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              draft.error!,
              style: const TextStyle(color: Color(0xFFB3261E), fontSize: 12),
            ),
          ),
      ],
    );
  }
}
