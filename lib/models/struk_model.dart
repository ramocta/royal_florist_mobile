class StrukItem {
  final String nama;
  final int qty;
  final int harga;

  const StrukItem(this.nama, this.qty, this.harga);

  int get subtotal => qty * harga;
}

class StrukModel {
  final String invoice;
  final String tanggal;
  final String pelanggan;
  final String noWa; // boleh format 08xx atau 628xx
  final String alamat;
  final List<StrukItem> items;

  /// Total dari server (total_harga). Dipakai kalau rincian produk kosong.
  final int? totalServer;
  final int ongkir;

  const StrukModel({
    required this.invoice,
    required this.tanggal,
    required this.pelanggan,
    required this.noWa,
    required this.alamat,
    required this.items,
    this.totalServer,
    this.ongkir = 0,
  });

  int get subtotal =>
    items.fold(0, (sum, e) => sum + e.subtotal);

int get total => totalServer ?? (subtotal + ongkir);
  /// Membuat struk dari data pesanan (hasil GET /orders/{id}).
  factory StrukModel.fromOrder(Map<String, dynamic> m) {
    String teks(List<String> kunci, {String bawaan = '-'}) {
      for (final k in kunci) {
        final v = m[k];
        if (v != null && v.toString().trim().isNotEmpty) return v.toString();
      }
      return bawaan;
    }

    int? angka(Map data, List<String> kunci) {
      for (final k in kunci) {
        final n = num.tryParse(data[k]?.toString() ?? '');
        if (n != null) return n.toInt();
      }
      return null;
    }

    String tanggal() {
      final raw = teks(['dibuat_pada', 'created_at', 'tanggal'], bawaan: '');
      final d = DateTime.tryParse(raw);
      if (d == null) return raw.isEmpty ? '-' : raw;
      final l = d.toLocal();
      const bulan = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      String dua(int n) => n.toString().padLeft(2, '0');
      return '${dua(l.day)} ${bulan[l.month - 1]} ${l.year} '
          '${dua(l.hour)}.${dua(l.minute)}';
    }

    dynamic daftar;
    for (final k in [
      'items',
      'detail_pesanan',
      'detail',
      'produk',
      'order_items'
    ]) {
      if (m[k] is List) {
        daftar = m[k];
        break;
      }
    }

    final items = <StrukItem>[];
    if (daftar is List) {
      for (final e in daftar.whereType<Map>()) {
        final produk = e['produk'];
        final nama = (e['nama_produk'] ??
                e['nama'] ??
                (produk is Map ? produk['nama'] : null) ??
                '-')
            .toString();
        final qty = angka(e, ['jumlah', 'qty', 'kuantitas']) ?? 0;
        final harga =
            angka(e, ['harga', 'harga_satuan', 'harga_produk']) ?? 0;
        items.add(StrukItem(nama, qty, harga));
      }
    }

        final jenisPengambilan = teks(['jenis_pengambilan'], bawaan: '');
    final ongkir = jenisPengambilan == 'dikirim' ? 20000 : 0;

    return StrukModel(
      invoice: teks(['no_invoice', 'invoice']),
      tanggal: tanggal(),
      pelanggan: teks(['nama_pelanggan', 'nama']),
      noWa: teks(['no_hp', 'no_telepon', 'telepon', 'phone'], bawaan: ''),
      alamat: teks(['alamat_pengiriman', 'alamat']),
      items: items,
      totalServer: angka(m, ['total_harga', 'total']),
      ongkir: ongkir,
    );
  }

  /// Data contoh, dipakai selama belum terhubung ke data asli.
  static const contoh = StrukModel(
    invoice: 'INV-20261004-001',
    tanggal: '04 Okt 2026 14.32',
    pelanggan: 'Siti Maisyarah',
    noWa: '085232603435',
    alamat: 'Jl. Melati No. 12, Nganjuk',
    items: [
      StrukItem('Buket Mawar', 5, 10000),
      StrukItem('Buket Lily', 2, 8000),
      StrukItem('Kartu Ucapan', 1, 9000),
    ],
  );
}