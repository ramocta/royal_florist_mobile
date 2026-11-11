class UserLogin {
  final int id;
  final String nama;
  final String email;
  final String role;
  final String? nmrTelepon;
  final String? alamat;

  UserLogin({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    this.nmrTelepon,
    this.alamat,
  });

  factory UserLogin.fromJson(Map<String, dynamic> j) => UserLogin(
    id: (j['id_user'] as num?)?.toInt() ?? 0,
    nama: j['nama']?.toString() ?? '',
    email: j['email']?.toString() ?? '',
    role: j['role']?.toString() ?? '',
    nmrTelepon: j['nmr_telepon']?.toString(),
    alamat: j['alamat']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'id_user': id,
    'nama': nama,
    'email': email,
    'role': role,
    'nmr_telepon': nmrTelepon,
    'alamat': alamat,
  };
}

class LoginResponseModel {
  final String token;
  final UserLogin user;
  LoginResponseModel({required this.token, required this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> j) =>
      LoginResponseModel(
        token: j['token']?.toString() ?? '',
        user: UserLogin.fromJson(Map<String, dynamic>.from(j['user'] as Map)),
      );
}
