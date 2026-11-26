class ProfilModel {
  final String nama;
  final String email;
  final String telepon;
  final String alamat;
  final String? jenisKelamin;
  final int? umur;
  final String? fotoUrl;

  const ProfilModel({
    required this.nama,
    required this.email,
    this.telepon = '',
    this.alamat = '',
    this.jenisKelamin,
    this.umur,
    this.fotoUrl,
  });

  factory ProfilModel.fromJson(Map<String, dynamic> j) => ProfilModel(
        nama: (j['nama'] ?? '').toString(),
        email: (j['email'] ?? '').toString(),
        telepon: (j['telepon'] ?? '').toString(),
        alamat: (j['alamat'] ?? '').toString(),
        jenisKelamin: j['jenis_kelamin'] as String?,
        umur: j['umur'] is int
            ? j['umur'] as int
            : int.tryParse('${j['umur'] ?? ''}'),
        fotoUrl: j['foto_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'email': email,
        'telepon': telepon,
        'alamat': alamat,
        'jenis_kelamin': jenisKelamin,
        'umur': umur,
      };
}