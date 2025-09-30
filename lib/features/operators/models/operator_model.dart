import 'package:flutter/material.dart';

enum OperatorStatus {
  active,
  inactive,
  onLeave,
  suspended
}

extension OperatorStatusExtension on OperatorStatus {
  String get label {
    switch (this) {
      case OperatorStatus.active:
        return 'Actif';
      case OperatorStatus.inactive:
        return 'Inactif';
      case OperatorStatus.onLeave:
        return 'En congé';
      case OperatorStatus.suspended:
        return 'Suspendu';
    }
  }
  
  Color get color {
    switch (this) {
      case OperatorStatus.active:
        return Colors.green;
      case OperatorStatus.inactive:
        return Colors.grey;
      case OperatorStatus.onLeave:
        return Colors.orange;
      case OperatorStatus.suspended:
        return Colors.red;
    }
  }
}

class OperatorModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final OperatorStatus status;
  final DateTime joinDate;
  final int completedTickets;
  final int pendingTickets;
  final double performanceScore;
  final Map<String, dynamic> additionalInfo;

  OperatorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.status,
    required this.joinDate,
    required this.completedTickets,
    required this.pendingTickets,
    required this.performanceScore,
    this.additionalInfo = const {},
  });

  // Méthode pour créer une copie modifiée de l'opérateur
  OperatorModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    OperatorStatus? status,
    DateTime? joinDate,
    int? completedTickets,
    int? pendingTickets,
    double? performanceScore,
    Map<String, dynamic>? additionalInfo,
  }) {
    return OperatorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      joinDate: joinDate ?? this.joinDate,
      completedTickets: completedTickets ?? this.completedTickets,
      pendingTickets: pendingTickets ?? this.pendingTickets,
      performanceScore: performanceScore ?? this.performanceScore,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  // Méthode pour convertir l'opérateur en Map (pour Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'status': status.toString().split('.').last,
      'joinDate': joinDate.toIso8601String(),
      'completedTickets': completedTickets,
      'pendingTickets': pendingTickets,
      'performanceScore': performanceScore,
      'additionalInfo': additionalInfo,
    };
  }

  // Méthode pour créer un opérateur à partir d'un Map (depuis Firestore)
  factory OperatorModel.fromMap(Map<String, dynamic> map) {
    return OperatorModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      status: _parseStatus(map['status']),
      joinDate: DateTime.parse(map['joinDate']),
      completedTickets: map['completedTickets'] ?? 0,
      pendingTickets: map['pendingTickets'] ?? 0,
      performanceScore: map['performanceScore']?.toDouble() ?? 0.0,
      additionalInfo: map['additionalInfo'] ?? {},
    );
  }

  // Méthode pour analyser le statut à partir d'une chaîne
  static OperatorStatus _parseStatus(String? statusString) {
    if (statusString == 'active') return OperatorStatus.active;
    if (statusString == 'inactive') return OperatorStatus.inactive;
    if (statusString == 'onLeave') return OperatorStatus.onLeave;
    if (statusString == 'suspended') return OperatorStatus.suspended;
    return OperatorStatus.inactive; // Valeur par défaut
  }
}

// Données fictives pour les opérateurs
class OperatorData {
  static List<OperatorModel> getSampleOperators() {
    return [
      OperatorModel(
        id: '1',
        name: 'Sophie Martin',
        email: 'sophie.martin@example.com',
        phone: '+33 6 12 34 56 78',
        avatarUrl: 'assets/images/avatar1.png',
        status: OperatorStatus.active,
        joinDate: DateTime(2023, 3, 15),
        completedTickets: 145,
        pendingTickets: 12,
        performanceScore: 95.2,
        additionalInfo: {
          'address': '15 Rue de Paris, 75001 Paris',
          'specialization': 'Support technique',
          'languages': ['Français', 'Anglais'],
        },
      ),
      OperatorModel(
        id: '2',
        name: 'Thomas Dubois',
        email: 'thomas.dubois@example.com',
        phone: '+33 6 23 45 67 89',
        avatarUrl: 'assets/images/avatar2.png',
        status: OperatorStatus.active,
        joinDate: DateTime(2023, 5, 22),
        completedTickets: 98,
        pendingTickets: 8,
        performanceScore: 92.7,
        additionalInfo: {
          'address': '25 Avenue Victor Hugo, 69002 Lyon',
          'specialization': 'Service client',
          'languages': ['Français', 'Espagnol'],
        },
      ),
      OperatorModel(
        id: '3',
        name: 'Emma Bernard',
        email: 'emma.bernard@example.com',
        phone: '+33 6 34 56 78 90',
        avatarUrl: 'assets/images/avatar3.png',
        status: OperatorStatus.onLeave,
        joinDate: DateTime(2023, 2, 10),
        completedTickets: 120,
        pendingTickets: 0,
        performanceScore: 88.5,
        additionalInfo: {
          'address': '8 Rue de la République, 13001 Marseille',
          'specialization': 'Logistique',
          'languages': ['Français', 'Italien'],
          'leaveUntil': '2023-09-15',
        },
      ),
      OperatorModel(
        id: '4',
        name: 'Lucas Petit',
        email: 'lucas.petit@example.com',
        phone: '+33 6 45 67 89 01',
        avatarUrl: 'assets/images/avatar4.png',
        status: OperatorStatus.inactive,
        joinDate: DateTime(2023, 7, 5),
        completedTickets: 45,
        pendingTickets: 5,
        performanceScore: 78.3,
        additionalInfo: {
          'address': '12 Boulevard Gambetta, 33000 Bordeaux',
          'specialization': 'Maintenance',
          'languages': ['Français'],
        },
      ),
      OperatorModel(
        id: '5',
        name: 'Chloé Durand',
        email: 'chloe.durand@example.com',
        phone: '+33 6 56 78 90 12',
        avatarUrl: 'assets/images/avatar5.png',
        status: OperatorStatus.suspended,
        joinDate: DateTime(2023, 4, 18),
        completedTickets: 67,
        pendingTickets: 0,
        performanceScore: 65.8,
        additionalInfo: {
          'address': '5 Rue des Fleurs, 59000 Lille',
          'specialization': 'Support technique',
          'languages': ['Français', 'Allemand'],
          'suspensionReason': 'Violation des règles de l\'entreprise',
          'suspensionUntil': '2023-10-01',
        },
      ),
      OperatorModel(
        id: '6',
        name: 'Antoine Leroy',
        email: 'antoine.leroy@example.com',
        phone: '+33 6 67 89 01 23',
        avatarUrl: 'assets/images/avatar6.png',
        status: OperatorStatus.active,
        joinDate: DateTime(2023, 1, 8),
        completedTickets: 210,
        pendingTickets: 15,
        performanceScore: 91.4,
        additionalInfo: {
          'address': '18 Avenue Jean Jaurès, 44000 Nantes',
          'specialization': 'Service client',
          'languages': ['Français', 'Anglais', 'Portugais'],
        },
      ),
      OperatorModel(
        id: '7',
        name: 'Julie Moreau',
        email: 'julie.moreau@example.com',
        phone: '+33 6 78 90 12 34',
        avatarUrl: 'assets/images/avatar7.png',
        status: OperatorStatus.active,
        joinDate: DateTime(2023, 6, 12),
        completedTickets: 88,
        pendingTickets: 7,
        performanceScore: 87.9,
        additionalInfo: {
          'address': '3 Rue de la Liberté, 67000 Strasbourg',
          'specialization': 'Logistique',
          'languages': ['Français', 'Allemand'],
        },
      ),
      OperatorModel(
        id: '8',
        name: 'Maxime Fournier',
        email: 'maxime.fournier@example.com',
        phone: '+33 6 89 01 23 45',
        avatarUrl: 'assets/images/avatar8.png',
        status: OperatorStatus.onLeave,
        joinDate: DateTime(2023, 3, 28),
        completedTickets: 132,
        pendingTickets: 0,
        performanceScore: 90.1,
        additionalInfo: {
          'address': '22 Rue du Commerce, 37000 Tours',
          'specialization': 'Maintenance',
          'languages': ['Français'],
          'leaveUntil': '2023-09-10',
        },
      ),
    ];
  }
}
