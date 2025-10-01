/// Modèle pour l'assignation et la réassignation de tickets
class TicketAssignment {
  final String ticketId;
  final String assignedTo;
  final String assignedBy;
  final DateTime assignedAt;
  final String? previousAssignee;
  final String? reassignmentReason;

  TicketAssignment({
    required this.ticketId,
    required this.assignedTo,
    required this.assignedBy,
    required this.assignedAt,
    this.previousAssignee,
    this.reassignmentReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'assignedTo': assignedTo,
      'assignedBy': assignedBy,
      'assignedAt': assignedAt.toIso8601String(),
      'previousAssignee': previousAssignee,
      'reassignmentReason': reassignmentReason,
    };
  }

  factory TicketAssignment.fromJson(Map<String, dynamic> json) {
    return TicketAssignment(
      ticketId: json['ticketId'],
      assignedTo: json['assignedTo'],
      assignedBy: json['assignedBy'],
      assignedAt: DateTime.parse(json['assignedAt']),
      previousAssignee: json['previousAssignee'],
      reassignmentReason: json['reassignmentReason'],
    );
  }
}

/// Modèle de notification de ticket
class TicketNotification {
  final String id;
  final String ticketId;
  final String title;
  final String message;
  final String type; // 'new', 'assigned', 'reassigned', 'updated', 'resolved'
  final DateTime createdAt;
  final bool isRead;
  final String? actionUrl;

  TicketNotification({
    required this.id,
    required this.ticketId,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.actionUrl,
  });

  TicketNotification copyWith({
    String? id,
    String? ticketId,
    String? title,
    String? message,
    String? type,
    DateTime? createdAt,
    bool? isRead,
    String? actionUrl,
  }) {
    return TicketNotification(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketId': ticketId,
      'title': title,
      'message': message,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'actionUrl': actionUrl,
    };
  }

  factory TicketNotification.fromJson(Map<String, dynamic> json) {
    return TicketNotification(
      id: json['id'],
      ticketId: json['ticketId'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
      actionUrl: json['actionUrl'],
    );
  }
}
