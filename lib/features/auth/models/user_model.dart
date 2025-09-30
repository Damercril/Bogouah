class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String role;
  final DateTime createdAt;
  final DateTime lastLogin;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.role,
    required this.createdAt,
    required this.lastLogin,
  });

  // Convertir un document en UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      role: map['role'] ?? 'user',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      lastLogin: map['lastLogin'] != null
          ? DateTime.parse(map['lastLogin'])
          : DateTime.now(),
    );
  }

  // Convertir UserModel en Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
    };
  }
}

// Classe pour gérer les données d'authentification
class AuthData {
  final String email;
  final String password;

  AuthData({
    required this.email,
    required this.password,
  });
}
