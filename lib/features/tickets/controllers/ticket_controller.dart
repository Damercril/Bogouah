import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../models/ticket_assignment_model.dart';

/// Contrôleur pour gérer les tickets et les notifications
class TicketController extends ChangeNotifier {
  List<TicketModel> _tickets = [];
  List<TicketNotification> _notifications = [];
  
  List<TicketModel> get tickets => _tickets;
  List<TicketNotification> get notifications => _notifications;
  List<TicketNotification> get unreadNotifications => 
      _notifications.where((n) => !n.isRead).toList();
  int get unreadCount => unreadNotifications.length;

  // Liste des opérateurs disponibles pour l'assignation
  final List<Map<String, String>> _availableOperators = [
    {'id': 'op1', 'name': 'Sophie Martin', 'avatar': 'SM'},
    {'id': 'op2', 'name': 'Thomas Dubois', 'avatar': 'TD'},
    {'id': 'op3', 'name': 'Emma Bernard', 'avatar': 'EB'},
    {'id': 'op4', 'name': 'Lucas Petit', 'avatar': 'LP'},
    {'id': 'op5', 'name': 'Léa Moreau', 'avatar': 'LM'},
  ];

  List<Map<String, String>> get availableOperators => _availableOperators;

  TicketController() {
    _loadMockData();
  }

  void _loadMockData() {
    // Charger des tickets fictifs
    _tickets = [
      TicketModel(
        id: 'TK-001',
        title: 'Problème de connexion',
        description: 'Le client ne peut pas se connecter à l\'application',
        status: 'En attente',
        priority: 'Haute',
        category: 'Technique',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        customerName: 'Jean Dupont',
        customerPhone: '+33 6 12 34 56 78',
        assignedTo: 'Sophie Martin',
      ),
      TicketModel(
        id: 'TK-002',
        title: 'Erreur de paiement',
        description: 'Transaction échouée lors du paiement',
        status: 'En cours',
        priority: 'Moyenne',
        category: 'Paiement',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        customerName: 'Marie Martin',
        customerPhone: '+33 6 23 45 67 89',
        assignedTo: 'Thomas Dubois',
      ),
    ];

    // Charger des notifications fictives
    _notifications = [
      TicketNotification(
        id: 'notif1',
        ticketId: 'TK-001',
        title: 'Nouveau ticket assigné',
        message: 'Le ticket TK-001 vous a été assigné',
        type: 'assigned',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
    ];

    notifyListeners();
  }

  /// Créer un nouveau ticket
  Future<TicketModel> createTicket({
    required String title,
    required String description,
    required String priority,
    required String category,
    required String customerName,
    required String customerPhone,
    String? customerEmail,
    String? assignedTo,
  }) async {
    final ticket = TicketModel(
      id: 'TK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: title,
      description: description,
      status: 'En attente',
      priority: priority,
      category: category,
      createdAt: DateTime.now(),
      customerName: customerName,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      assignedTo: assignedTo,
    );

    _tickets.insert(0, ticket);

    // Créer une notification si le ticket est assigné
    if (assignedTo != null) {
      _createNotification(
        ticketId: ticket.id,
        title: 'Nouveau ticket assigné',
        message: 'Le ticket ${ticket.id} vous a été assigné : ${ticket.title}',
        type: 'assigned',
      );
    }

    notifyListeners();
    return ticket;
  }

  /// Assigner un ticket à un opérateur
  Future<void> assignTicket({
    required String ticketId,
    required String operatorName,
    required String assignedBy,
  }) async {
    final ticketIndex = _tickets.indexWhere((t) => t.id == ticketId);
    if (ticketIndex == -1) return;

    final ticket = _tickets[ticketIndex];
    final updatedTicket = ticket.copyWith(
      assignedTo: operatorName,
      status: 'En cours',
    );

    _tickets[ticketIndex] = updatedTicket;

    // Créer une notification
    _createNotification(
      ticketId: ticketId,
      title: 'Ticket assigné',
      message: 'Le ticket $ticketId vous a été assigné par $assignedBy',
      type: 'assigned',
    );

    notifyListeners();
  }

  /// Réassigner un ticket à un autre opérateur
  Future<void> reassignTicket({
    required String ticketId,
    required String newOperatorName,
    required String reassignedBy,
    String? reason,
  }) async {
    final ticketIndex = _tickets.indexWhere((t) => t.id == ticketId);
    if (ticketIndex == -1) return;

    final ticket = _tickets[ticketIndex];
    final previousAssignee = ticket.assignedTo;

    final updatedTicket = ticket.copyWith(
      assignedTo: newOperatorName,
    );

    _tickets[ticketIndex] = updatedTicket;

    // Créer une notification pour le nouvel opérateur
    _createNotification(
      ticketId: ticketId,
      title: 'Ticket réassigné',
      message: 'Le ticket $ticketId vous a été réassigné${reason != null ? " : $reason" : ""}',
      type: 'reassigned',
    );

    // Notification pour l'ancien opérateur
    if (previousAssignee != null) {
      _createNotification(
        ticketId: ticketId,
        title: 'Ticket réassigné',
        message: 'Le ticket $ticketId a été réassigné à $newOperatorName',
        type: 'reassigned',
      );
    }

    notifyListeners();
  }

  /// Mettre à jour le statut d'un ticket
  Future<void> updateTicketStatus({
    required String ticketId,
    required String newStatus,
  }) async {
    final ticketIndex = _tickets.indexWhere((t) => t.id == ticketId);
    if (ticketIndex == -1) return;

    final ticket = _tickets[ticketIndex];
    final updatedTicket = ticket.copyWith(status: newStatus);

    _tickets[ticketIndex] = updatedTicket;

    // Créer une notification
    _createNotification(
      ticketId: ticketId,
      title: 'Statut du ticket mis à jour',
      message: 'Le ticket $ticketId est maintenant : $newStatus',
      type: 'updated',
    );

    notifyListeners();
  }

  /// Supprimer un ticket
  Future<void> deleteTicket(String ticketId) async {
    _tickets.removeWhere((t) => t.id == ticketId);
    _notifications.removeWhere((n) => n.ticketId == ticketId);
    notifyListeners();
  }

  /// Créer une notification
  void _createNotification({
    required String ticketId,
    required String title,
    required String message,
    required String type,
  }) {
    final notification = TicketNotification(
      id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
      ticketId: ticketId,
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.now(),
      isRead: false,
    );

    _notifications.insert(0, notification);
  }

  /// Marquer une notification comme lue
  void markNotificationAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  /// Marquer toutes les notifications comme lues
  void markAllNotificationsAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  /// Supprimer une notification
  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }

  /// Obtenir un ticket par ID
  TicketModel? getTicketById(String ticketId) {
    try {
      return _tickets.firstWhere((t) => t.id == ticketId);
    } catch (e) {
      return null;
    }
  }

  /// Obtenir les tickets assignés à un opérateur
  List<TicketModel> getTicketsByOperator(String operatorName) {
    return _tickets.where((t) => t.assignedTo == operatorName).toList();
  }

  /// Obtenir les tickets par statut
  List<TicketModel> getTicketsByStatus(String status) {
    return _tickets.where((t) => t.status == status).toList();
  }
}
