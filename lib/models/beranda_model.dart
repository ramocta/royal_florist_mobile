class PenjualanHarian {
  final String label;
  final String tanggal;
  final int total;
  PenjualanHarian({
    required this.label,
    required this.tanggal,
    required this.total,
  });

  factory PenjualanHarian.fromJson(Map<String, dynamic> j) => PenjualanHarian(
    label: j['label']?.toString() ?? '',
    tanggal: j['tanggal']?.toString() ?? '',
    total: (j['total'] as num?)?.toInt() ?? 0,
  );
}

class PesananBaruItem {
  final int id;
  final String kode;
  final String pelanggan;
  PesananBaruItem({
    required this.id,
    required this.kode,
    required this.pelanggan,
  });

  factory PesananBaruItem.fromJson(Map<String, dynamic> j) => PesananBaruItem(
    id: (j['id'] as num?)?.toInt() ?? 0,
    kode: j['kode']?.toString() ?? '-',
    pelanggan: j['pelanggan']?.toString() ?? '-',
  );
}

class BerandaModel {
  final String namaUser;
  final DateTime? tanggal;
  final int totalPesananHariIni;
  final int pendapatanHariIni;
  final List<PesananBaruItem> pesananBaru;
  final List<PenjualanHarian> grafik;

  BerandaModel({
    this.namaUser = '',
    this.tanggal,
    required this.totalPesananHariIni,
    required this.pendapatanHariIni,
    required this.pesananBaru,
    required this.grafik,
  });

  factory BerandaModel.empty() => BerandaModel(
    totalPesananHariIni: 0,
    pendapatanHariIni: 0,
    pesananBaru: [],
    grafik: [],
  );

  factory BerandaModel.fromJson(Map<String, dynamic> j) => BerandaModel(
    namaUser: j['nama']?.toString() ?? '',
    tanggal: DateTime.tryParse(j['tanggal']?.toString() ?? ''),
    totalPesananHariIni: (j['total_pesanan'] as num?)?.toInt() ?? 0,
    pendapatanHariIni: (j['pendapatan_hari_ini'] as num?)?.toInt() ?? 0,
    pesananBaru: ((j['pesanan_baru'] as List?) ?? [])
        .map(
          (e) => PesananBaruItem.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList(),
    grafik: ((j['grafik'] as List?) ?? [])
        .map(
          (e) => PenjualanHarian.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList(),
  );

  /// 50000 -> "Rp 50.000"
  static String rupiah(int v) {
    final s = v.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
    return 'Rp $s';
  }
}
