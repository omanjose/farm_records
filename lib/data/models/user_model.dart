class UserModel {
  final int? id;
  final String username;
  final String passwordHash;
  final String fullName;
  final String role;
  final String? email;
  final String createdAt;

  const UserModel({
    this.id,
    required this.username,
    required this.passwordHash,
    required this.fullName,
    required this.role,
    this.email,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
        id: m['id'] as int?,
        username: m['username'] as String,
        passwordHash: m['password_hash'] as String,
        fullName: m['full_name'] as String,
        role: m['role'] as String,
        email: m['email'] as String?,
        createdAt: m['created_at'] as String,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'username': username,
        'password_hash': passwordHash,
        'full_name': fullName,
        'role': role,
        if (email != null) 'email': email,
        'created_at': createdAt,
      };

  bool get isAdmin => role == 'admin';
  bool get isManager => role == 'manager' || role == 'admin';

  @override
  String toString() => 'UserModel($username, $role)';
}
