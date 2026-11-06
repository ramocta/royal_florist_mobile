// Model data balasan dari API login

/// Data pengguna (sesuai tabel `users` di database florist).
class UserModel {
  final int id;
  final String nama;
  final String email;
  final String role; // pelanggan | admin | karyawan

  const UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse('${json['id_user'] ?? json['id'] ?? 0}') ?? 0,
      nama: '${json['nama'] ?? ''}',
      email: '${json['email'] ?? ''}',
      role: '${json['role'] ?? ''}',
    );
  }

  Map<String, dynamic> toJson() => {
        'id_user': id,
        'nama': nama,
        'email': email,
        'role': role,
      };
}

/// Balasan login: token + data pengguna.
/// Mendukung format {"token":..., "user":{...}}
/// maupun {"data":{"token":..., "user":{...}}}.
class LoginResponse {
  final String token;
  final UserModel user;

  const LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final userJson = data['user'] is Map<String, dynamic>
        ? data['user'] as Map<String, dynamic>
        : <String, dynamic>{};

    return LoginResponse(
      token: '${data['token'] ?? ''}',
      user: UserModel.fromJson(userJson),
    );
  }
}// Bentuk balasan login: token + data karyawan

