class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final String profileImageUrl;
  final String parkId;
  final String apiKey;
  final String secretKey;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime lastLogin;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.profileImageUrl,
    required this.parkId,
    required this.apiKey,
    required this.secretKey,
    required this.isVerified,
    required this.createdAt,
    required this.lastLogin,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? 'user',
      profileImageUrl: json['profileImageUrl'] ?? '',
      parkId: json['parkId'] ?? '',
      apiKey: json['apiKey'] ?? '',
      secretKey: json['secretKey'] ?? '',
      isVerified: json['isVerified'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'parkId': parkId,
      'apiKey': apiKey,
      'secretKey': secretKey,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? role,
    String? profileImageUrl,
    String? parkId,
    String? apiKey,
    String? secretKey,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      parkId: parkId ?? this.parkId,
      apiKey: apiKey ?? this.apiKey,
      secretKey: secretKey ?? this.secretKey,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
