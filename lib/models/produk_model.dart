import '../core/api/api_config.dart';

class SubKategori {
  const SubKategori({
    required this.id,
    required this.nama,
    required this.pakaiStok,
  });

  final int id;
  final String nama;
  final bool pakaiStok;

  factory SubKategori.fromJson(Map<String, dynamic> j) => SubKategori(
    id: (j['id'] as num).toInt(),
    nama: j['nama']?.toString() ?? '',
    pakaiStok: j['pakai_stok'] == true,
  );

  @override
  bool operator ==(Object other) => other is SubKategori && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class Kategori {
  const Kategori({
    required this.id,
    required this.nama,
    required this.subLabel,
    required this.subs,
  });

  final int id;
  final String nama;
  final String subLabel;
  final List<SubKategori> subs;

  factory Kategori.fromJson(Map<String, dynamic> j) => Kategori(
    id: (j['id'] as num).toInt(),
    nama: j['nama']?.toString() ?? '',
    subLabel: j['sub_label']?.toString() ?? 'Jenis',
    subs: ((j['subs'] as List?) ?? [])
        .map((e) => SubKategori.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
  );

  @override
  bool operator ==(Object other) => other is Kategori && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class Produk {
  const Produk({
    required this.id,
    required this.sku,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.idKategori,
    required this.kategori,
    required this.idSub,
    required this.sub,
    required this.pakaiStok,
    required this.stok,
    required this.tersedia,
    required this.aktif,
    required this.foto,
  });

  final int id;
  final String sku;
  final String nama;
  final String deskripsi;
  final int harga;
  final int idKategori;
  final String kategori;
  final int? idSub;
  final String? sub;
  final bool pakaiStok;
  final int stok;
  final bool tersedia;
  final bool aktif;
  final String? foto;

  bool get ada => pakaiStok ? stok > 0 : tersedia;

  String get status => !aktif ? 'Nonaktif' : (ada ? 'Tersedia' : 'Habis');

  String? get fotoUrl => ApiConfig.fotoUrl(id, foto);

  factory Produk.fromJson(Map<String, dynamic> j) => Produk(
    id: (j['id'] as num).toInt(),
    sku: j['sku']?.toString() ?? '',
    nama: j['nama']?.toString() ?? '',
    deskripsi: j['deskripsi']?.toString() ?? '',
    harga: (j['harga'] as num?)?.toInt() ?? 0,
    idKategori: (j['id_ctg'] as num).toInt(),
    kategori: j['kategori']?.toString() ?? '-',
    idSub: (j['id_subctg'] as num?)?.toInt(),
    sub: j['sub']?.toString(),
    pakaiStok: j['pakai_stok'] == true,
    stok: (j['stok'] as num?)?.toInt() ?? 0,
    tersedia: j['tersedia'] == true,
    aktif: j['is_active'] == true,
    foto: j['foto']?.toString(),
  );

  Produk copyWith({int? stok, bool? tersedia}) => Produk(
    id: id,
    sku: sku,
    nama: nama,
    deskripsi: deskripsi,
    harga: harga,
    idKategori: idKategori,
    kategori: kategori,
    idSub: idSub,
    sub: sub,
    pakaiStok: pakaiStok,
    stok: stok ?? this.stok,
    tersedia: tersedia ?? this.tersedia,
    aktif: aktif,
    foto: foto,
  );
}

class StokData {
  const StokData({required this.items, required this.kategori});

  final List<Produk> items;
  final List<Kategori> kategori;
}
