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

  const StrukModel({
    required this.invoice,
    required this.tanggal,
    required this.pelanggan,
    required this.noWa,
    required this.alamat,
    required this.items,
  });

  int get total => items.fold(0, (sum, e) => sum + e.subtotal);

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
