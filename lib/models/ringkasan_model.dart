class RingkasanCardItem {
  final String key; // pesanan_masuk | dalam_proses | selesai | dibatalkan
  final String label;
  final int jumlah;
  final int persen;
  final String trend; // up | down | flat
  final String perubahanLabel; // "+12% dari minggu lalu"

  RingkasanCardItem({
    required this.key,
    required this.label,
    required this.jumlah,
    required this.persen,
    required this.trend,
    required this.perubahanLabel,
  });

  bool get isUp => trend == 'up';
  bool get isDown => trend == 'down';

  factory RingkasanCardItem.fromJson(Map<String, dynamic> j) {
    final p = Map<String, dynamic>.from((j['perubahan'] as Map?) ?? {});
    return RingkasanCardItem(
      key: j['key']?.toString() ?? '',
      label: j['label']?.toString() ?? '',
      jumlah: (j['jumlah'] as num?)?.toInt() ?? 0,
      persen: (p['persen'] as num?)?.toInt() ?? 0,
      trend: p['trend']?.toString() ?? 'flat',
      perubahanLabel: p['label']?.toString() ?? '',
    );
  }
}

class PesananTerbaruItem {
  final int id;
  final String noInvoice;
  final String pelanggan;
  final String jam;
  final String status; // dikonfirmasi | diproses | dikirim | selesai | dibatalkan
  final String statusLabel;

  PesananTerbaruItem({
    required this.id,
    required this.noInvoice,
    required this.pelanggan,
    required this.jam,
    required this.status,
    required this.statusLabel,
  });

  factory PesananTerbaruItem.fromJson(Map<String, dynamic> j) =>
      PesananTerbaruItem(
        id: (j['id_order'] as num?)?.toInt() ?? 0,
        noInvoice: j['no_invoice']?.toString() ?? '-',
        pelanggan: j['pelanggan']?.toString() ?? '-',
        jam: j['jam']?.toString() ?? '-',
        status: j['status']?.toString() ?? '',
        statusLabel: j['status_label']?.toString() ?? '-',
      );
}

/// Data dari GET /api/ringkasan  (kirim isi field "data", bukan seluruh response)
class RingkasanModel {
  final String namaUser;
  final String role;
  final String periodeLabel; // "28 Sep – 04 Okt 2026"
  final DateTime? tanggalMulai;
  final DateTime? tanggalSelesai;
  final bool isMingguIni;
  final List<RingkasanCardItem> cards;
  final List<PesananTerbaruItem> pesananTerbaru;

  RingkasanModel({
    this.namaUser = '',
    this.role = 'Staff Florist',
    this.periodeLabel = '',
    this.tanggalMulai,
    this.tanggalSelesai,
    this.isMingguIni = true,
    required this.cards,
    required this.pesananTerbaru,
  });

  factory RingkasanModel.empty() =>
      RingkasanModel(cards: [], pesananTerbaru: []);

  factory RingkasanModel.fromJson(Map<String, dynamic> j) {
    final user = Map<String, dynamic>.from((j['user'] as Map?) ?? {});
    final ringkasan = Map<String, dynamic>.from(
      (j['ringkasan_minggu_ini'] as Map?) ?? {},
    );
    final periode = Map<String, dynamic>.from(
      (ringkasan['periode'] as Map?) ?? {},
    );

    return RingkasanModel(
      namaUser: user['nama']?.toString() ?? '',
      role: user['role']?.toString() ?? 'Staff Florist',
      periodeLabel: periode['label']?.toString() ?? '',
      tanggalMulai: DateTime.tryParse(periode['tanggal_mulai']?.toString() ?? ''),
      tanggalSelesai: DateTime.tryParse(
        periode['tanggal_selesai']?.toString() ?? '',
      ),
      isMingguIni: periode['is_minggu_ini'] == true,
      cards: ((ringkasan['cards'] as List?) ?? [])
          .map(
            (e) => RingkasanCardItem.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      pesananTerbaru: ((j['pesanan_terbaru'] as List?) ?? [])
          .map(
            (e) => PesananTerbaruItem.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
    );
  }

  /// Ambil kartu berdasarkan key, misal card('selesai')
  RingkasanCardItem? card(String key) {
    for (final c in cards) {
      if (c.key == key) return c;
    }
    return null;
  }
}

/// Response GET /api/ringkasan/pesanan ("Lihat Semua", paginasi)
class PesananListModel {
  final List<PesananTerbaruItem> data;
  final int currentPage;
  final int lastPage;
  final int total;

  PesananListModel({
    required this.data,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
  });

  bool get hasMore => currentPage < lastPage;

  factory PesananListModel.empty() => PesananListModel(data: []);

  factory PesananListModel.fromJson(Map<String, dynamic> j) {
    final meta = Map<String, dynamic>.from((j['meta'] as Map?) ?? {});
    return PesananListModel(
      data: ((j['data'] as List?) ?? [])
          .map(
            (e) => PesananTerbaruItem.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
      currentPage: (meta['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (meta['last_page'] as num?)?.toInt() ?? 1,
      total: (meta['total'] as num?)?.toInt() ?? 0,
    );
  }
}