class SupportMessage {
  final String id;
  final String userId;
  final String agentId;
  final String content;
  final DateTime timestamp;
  final bool isUserMessage;
  final bool isRead;
  final String? attachmentUrl;
  final MessageStatus status;

  SupportMessage({
    required this.id,
    required this.userId,
    required this.agentId,
    required this.content,
    required this.timestamp,
    required this.isUserMessage,
    required this.isRead,
    this.attachmentUrl,
    required this.status,
  });

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    return SupportMessage(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      agentId: json['agentId'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isUserMessage: json['isUserMessage'] ?? true,
      isRead: json['isRead'] ?? false,
      attachmentUrl: json['attachmentUrl'],
      status: MessageStatusExtension.fromString(json['status'] ?? 'sent'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'agentId': agentId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isUserMessage': isUserMessage,
      'isRead': isRead,
      'attachmentUrl': attachmentUrl,
      'status': status.toShortString(),
    };
  }

  SupportMessage copyWith({
    String? id,
    String? userId,
    String? agentId,
    String? content,
    DateTime? timestamp,
    bool? isUserMessage,
    bool? isRead,
    String? attachmentUrl,
    MessageStatus? status,
  }) {
    return SupportMessage(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      agentId: agentId ?? this.agentId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isUserMessage: isUserMessage ?? this.isUserMessage,
      isRead: isRead ?? this.isRead,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      status: status ?? this.status,
    );
  }
}

enum MessageStatus {
  sent,
  delivered,
  read,
  failed,
  pending,
}

extension MessageStatusExtension on MessageStatus {
  String toShortString() {
    return toString().split('.').last;
  }

  static MessageStatus fromString(String status) {
    switch (status) {
      case 'sent':
        return MessageStatus.sent;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'failed':
        return MessageStatus.failed;
      case 'pending':
        return MessageStatus.pending;
      default:
        return MessageStatus.sent;
    }
  }
}

class SupportTicket {
  final String id;
  final String userId;
  final String subject;
  final String description;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final TicketStatus status;
  final String? assignedAgentId;
  final List<SupportMessage> messages;

  SupportTicket({
    required this.id,
    required this.userId,
    required this.subject,
    required this.description,
    required this.createdAt,
    this.resolvedAt,
    required this.status,
    this.assignedAgentId,
    required this.messages,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'])
          : null,
      status: TicketStatusExtension.fromString(json['status'] ?? 'open'),
      assignedAgentId: json['assignedAgentId'],
      messages: (json['messages'] as List?)
              ?.map((m) => SupportMessage.fromJson(m))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'subject': subject,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'status': status.toShortString(),
      'assignedAgentId': assignedAgentId,
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }

  SupportTicket copyWith({
    String? id,
    String? userId,
    String? subject,
    String? description,
    DateTime? createdAt,
    DateTime? resolvedAt,
    TicketStatus? status,
    String? assignedAgentId,
    List<SupportMessage>? messages,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      status: status ?? this.status,
      assignedAgentId: assignedAgentId ?? this.assignedAgentId,
      messages: messages ?? this.messages,
    );
  }
}

enum TicketStatus {
  open,
  inProgress,
  resolved,
  closed,
  pending,
}

extension TicketStatusExtension on TicketStatus {
  String toShortString() {
    return toString().split('.').last;
  }

  static TicketStatus fromString(String status) {
    switch (status) {
      case 'open':
        return TicketStatus.open;
      case 'inProgress':
        return TicketStatus.inProgress;
      case 'resolved':
        return TicketStatus.resolved;
      case 'closed':
        return TicketStatus.closed;
      case 'pending':
        return TicketStatus.pending;
      default:
        return TicketStatus.open;
    }
  }
}
