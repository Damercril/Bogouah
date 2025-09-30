import 'package:flutter/material.dart';

enum TicketStatus {
  open,
  inProgress,
  resolved,
  closed
}

extension TicketStatusExtension on TicketStatus {
  String get label {
    switch (this) {
      case TicketStatus.open:
        return 'Ouvert';
      case TicketStatus.inProgress:
        return 'En cours';
      case TicketStatus.resolved:
        return 'Résolu';
      case TicketStatus.closed:
        return 'Fermé';
    }
  }
  
  Color get color {
    switch (this) {
      case TicketStatus.open:
        return Colors.red;
      case TicketStatus.inProgress:
        return Colors.amber;
      case TicketStatus.resolved:
        return Colors.green;
      case TicketStatus.closed:
        return Colors.grey;
    }
  }
}

enum TicketPriority {
  low,
  medium,
  high,
  critical
}

extension TicketPriorityExtension on TicketPriority {
  String get label {
    switch (this) {
      case TicketPriority.low:
        return 'Basse';
      case TicketPriority.medium:
        return 'Moyenne';
      case TicketPriority.high:
        return 'Haute';
      case TicketPriority.critical:
        return 'Critique';
    }
  }
  
  Color get color {
    switch (this) {
      case TicketPriority.low:
        return Colors.blue;
      case TicketPriority.medium:
        return Colors.amber;
      case TicketPriority.high:
        return Colors.red;
      case TicketPriority.critical:
        return Colors.purple;
    }
  }
}

class TicketModel {
  final String id;
  final String title;
  final String description;
  final TicketStatus status;
  final TicketPriority priority;
  final String category;
  final String? assignedTo;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int commentsCount;
  final int attachmentsCount;

  TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.category,
    this.assignedTo,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.commentsCount = 0,
    this.attachmentsCount = 0,
  });

  // Méthode pour créer une copie modifiée du ticket
  TicketModel copyWith({
    String? id,
    String? title,
    String? description,
    TicketStatus? status,
    TicketPriority? priority,
    String? category,
    String? assignedTo,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? commentsCount,
    int? attachmentsCount,
  }) {
    return TicketModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      assignedTo: assignedTo ?? this.assignedTo,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      commentsCount: commentsCount ?? this.commentsCount,
      attachmentsCount: attachmentsCount ?? this.attachmentsCount,
    );
  }

  // Méthode pour convertir le ticket en Map (pour Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'category': category,
      'assignedTo': assignedTo,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'commentsCount': commentsCount,
      'attachmentsCount': attachmentsCount,
    };
  }

  // Méthode pour créer un ticket à partir d'un Map (depuis Firestore)
  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: _parseStatus(map['status']),
      priority: _parsePriority(map['priority']),
      category: map['category'] ?? '',
      assignedTo: map['assignedTo'],
      createdBy: map['createdBy'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      commentsCount: map['commentsCount'] ?? 0,
      attachmentsCount: map['attachmentsCount'] ?? 0,
    );
  }

  // Méthode pour analyser le statut à partir d'une chaîne
  static TicketStatus _parseStatus(String? statusString) {
    if (statusString == 'open') return TicketStatus.open;
    if (statusString == 'inProgress') return TicketStatus.inProgress;
    if (statusString == 'resolved') return TicketStatus.resolved;
    if (statusString == 'closed') return TicketStatus.closed;
    return TicketStatus.open; // Valeur par défaut
  }

  // Méthode pour analyser la priorité à partir d'une chaîne
  static TicketPriority _parsePriority(String? priorityString) {
    if (priorityString == 'low') return TicketPriority.low;
    if (priorityString == 'medium') return TicketPriority.medium;
    if (priorityString == 'high') return TicketPriority.high;
    if (priorityString == 'critical') return TicketPriority.critical;
    return TicketPriority.medium; // Valeur par défaut
  }
}

// Données fictives pour les tickets
class TicketData {
  static List<TicketModel> getSampleTickets() {
    final now = DateTime.now();
    
    return [
      TicketModel(
        id: 'TK-2023-001',
        title: 'Problème de connexion au réseau',
        description: 'Impossible de se connecter au réseau wifi de l\'entreprise depuis ce matin.',
        status: TicketStatus.open,
        priority: TicketPriority.high,
        category: 'Réseau',
        assignedTo: 'Sophie Martin',
        createdBy: 'Jean Dupont',
        createdAt: now,
        updatedAt: now,
        commentsCount: 2,
        attachmentsCount: 1,
      ),
      TicketModel(
        id: 'TK-2023-002',
        title: 'Mise à jour du système',
        description: 'Besoin d\'une mise à jour du système d\'exploitation sur tous les postes du service comptabilité.',
        status: TicketStatus.inProgress,
        priority: TicketPriority.medium,
        category: 'Logiciel',
        assignedTo: 'Thomas Dubois',
        createdBy: 'Marie Lambert',
        createdAt: now.subtract(Duration(hours: 2)),
        updatedAt: now.subtract(Duration(minutes: 30)),
        commentsCount: 5,
        attachmentsCount: 0,
      ),
      TicketModel(
        id: 'TK-2023-003',
        title: 'Problème d\'imprimante',
        description: 'L\'imprimante du 3ème étage ne fonctionne plus et affiche une erreur de cartouche.',
        status: TicketStatus.resolved,
        priority: TicketPriority.low,
        category: 'Matériel',
        assignedTo: 'Lucas Bernard',
        createdBy: 'Paul Durand',
        createdAt: now.subtract(Duration(days: 1)),
        updatedAt: now.subtract(Duration(hours: 4)),
        commentsCount: 3,
        attachmentsCount: 2,
      ),
      TicketModel(
        id: 'TK-2023-004',
        title: 'Accès à la base de données',
        description: 'Besoin d\'un accès à la base de données clients pour le nouveau membre de l\'équipe marketing.',
        status: TicketStatus.inProgress,
        priority: TicketPriority.high,
        category: 'Accès',
        assignedTo: 'Emma Leroy',
        createdBy: 'Sophie Petit',
        createdAt: now.subtract(Duration(days: 1)),
        updatedAt: now.subtract(Duration(hours: 1)),
        commentsCount: 4,
        attachmentsCount: 0,
      ),
      TicketModel(
        id: 'TK-2023-005',
        title: 'Installation de logiciel',
        description: 'Installation de la suite Adobe sur le poste du nouveau designer.',
        status: TicketStatus.closed,
        priority: TicketPriority.medium,
        category: 'Logiciel',
        assignedTo: 'Thomas Dubois',
        createdBy: 'Claire Martin',
        createdAt: now.subtract(Duration(days: 5)),
        updatedAt: now.subtract(Duration(days: 4)),
        commentsCount: 6,
        attachmentsCount: 1,
      ),
      TicketModel(
        id: 'TK-2023-006',
        title: 'Problème de serveur mail',
        description: 'Le serveur mail est inaccessible pour toute l\'entreprise depuis 30 minutes.',
        status: TicketStatus.open,
        priority: TicketPriority.critical,
        category: 'Serveur',
        assignedTo: null,
        createdBy: 'Directeur IT',
        createdAt: now.subtract(Duration(hours: 3)),
        updatedAt: now.subtract(Duration(hours: 3)),
        commentsCount: 0,
        attachmentsCount: 0,
      ),
    ];
  }
}
