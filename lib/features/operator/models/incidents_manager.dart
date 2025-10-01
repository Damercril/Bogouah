import 'package:flutter/material.dart';

/// Gestionnaire centralisé des incidents pour l'opérateur
class IncidentsManager extends ChangeNotifier {
  static final IncidentsManager _instance = IncidentsManager._internal();
  
  factory IncidentsManager() {
    return _instance;
  }
  
  IncidentsManager._internal();

  // Liste des incidents
  final List<Map<String, dynamic>> _incidents = [
    {
      'id': 'INC-001',
      'title': 'Erreur de paiement mobile money',
      'description': 'Impossible de finaliser le paiement via mobile money. L\'application affiche une erreur.',
      'status': 'En cours',
      'priority': 'Haute',
      'category': 'Paiement',
      'assignedTo': 'Sophie Martin',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      'affectedDrivers': [
        {
          'name': 'Mamadou Diallo',
          'phone': '+221 77 123 45 67',
          'avatar': 'MD',
          'calledAt': DateTime.now().subtract(const Duration(hours: 2)),
        },
        {
          'name': 'Fatou Sall',
          'phone': '+221 77 234 56 78',
          'avatar': 'FS',
          'calledAt': DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        },
        {
          'name': 'Moussa Kane',
          'phone': '+221 77 345 67 89',
          'avatar': 'MK',
          'calledAt': DateTime.now().subtract(const Duration(hours: 1)),
        },
        {
          'name': 'Aminata Ndiaye',
          'phone': '+221 77 456 78 90',
          'avatar': 'AN',
          'calledAt': DateTime.now().subtract(const Duration(minutes: 45)),
        },
      ],
    },
    {
      'id': 'INC-002',
      'title': 'Application se ferme au démarrage',
      'description': 'L\'application crash dès l\'ouverture sur certains appareils Android.',
      'status': 'Résolu',
      'priority': 'Urgente',
      'category': 'Technique',
      'assignedTo': 'Thomas Dubois',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'affectedDrivers': [
        {
          'name': 'Ibrahima Sarr',
          'phone': '+221 77 567 89 01',
          'avatar': 'IS',
          'calledAt': DateTime.now().subtract(const Duration(days: 1)),
        },
        {
          'name': 'Aissatou Diop',
          'phone': '+221 77 678 90 12',
          'avatar': 'AD',
          'calledAt': DateTime.now().subtract(const Duration(days: 1)),
        },
      ],
    },
    {
      'id': 'INC-003',
      'title': 'GPS ne se connecte pas',
      'description': 'Le GPS ne parvient pas à se connecter, impossible de démarrer une course.',
      'status': 'En attente',
      'priority': 'Moyenne',
      'category': 'GPS',
      'assignedTo': 'Lucas Bernard',
      'createdAt': DateTime.now().subtract(const Duration(hours: 5)),
      'affectedDrivers': [
        {
          'name': 'Cheikh Sy',
          'phone': '+221 77 789 01 23',
          'avatar': 'CS',
          'calledAt': DateTime.now().subtract(const Duration(hours: 5)),
        },
      ],
    },
    {
      'id': 'INC-004',
      'title': 'Notification de nouvelle course non reçue',
      'description': 'Les chauffeurs ne reçoivent pas les notifications de nouvelles courses.',
      'status': 'En cours',
      'priority': 'Haute',
      'category': 'Notifications',
      'assignedTo': 'Emma Leroy',
      'createdAt': DateTime.now().subtract(const Duration(hours: 3)),
      'affectedDrivers': [
        {
          'name': 'Ousmane Ba',
          'phone': '+221 77 890 12 34',
          'avatar': 'OB',
          'calledAt': DateTime.now().subtract(const Duration(hours: 3)),
        },
        {
          'name': 'Mariama Cisse',
          'phone': '+221 77 901 23 45',
          'avatar': 'MC',
          'calledAt': DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
        },
      ],
    },
  ];

  List<Map<String, dynamic>> get incidents => _incidents;

  /// Ajouter un nouvel incident
  void addIncident(Map<String, dynamic> incident) {
    _incidents.insert(0, incident);
    notifyListeners();
  }

  /// Ajouter un chauffeur à un incident
  void addDriverToIncident(String incidentId, Map<String, dynamic> driver) {
    final incident = _incidents.firstWhere((inc) => inc['id'] == incidentId);
    (incident['affectedDrivers'] as List).add(driver);
    notifyListeners();
  }

  /// Retirer un chauffeur d'un incident
  void removeDriverFromIncident(String incidentId, int driverIndex) {
    final incident = _incidents.firstWhere((inc) => inc['id'] == incidentId);
    (incident['affectedDrivers'] as List).removeAt(driverIndex);
    notifyListeners();
  }

  /// Mettre à jour le statut d'un incident
  void updateIncidentStatus(String incidentId, String newStatus) {
    final incident = _incidents.firstWhere((inc) => inc['id'] == incidentId);
    incident['status'] = newStatus;
    notifyListeners();
  }

  /// Obtenir un incident par son ID
  Map<String, dynamic>? getIncidentById(String incidentId) {
    try {
      return _incidents.firstWhere((inc) => inc['id'] == incidentId);
    } catch (e) {
      return null;
    }
  }

  /// Générer un nouvel ID d'incident
  String generateIncidentId() {
    final maxId = _incidents.isEmpty
        ? 0
        : _incidents
            .map((inc) => int.tryParse(inc['id'].toString().split('-').last) ?? 0)
            .reduce((a, b) => a > b ? a : b);
    return 'INC-${(maxId + 1).toString().padLeft(3, '0')}';
  }
}
