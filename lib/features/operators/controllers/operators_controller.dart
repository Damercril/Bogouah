import 'package:flutter/material.dart';
import '../models/operator_model.dart';

class OperatorsController with ChangeNotifier {
  // Liste des opérateurs
  List<OperatorModel> _operators = [];
  
  // Opérateurs filtrés (après recherche ou filtrage)
  List<OperatorModel> _filteredOperators = [];
  
  // Statut de chargement
  bool _isLoading = false;
  
  // Erreur éventuelle
  String? _error;
  
  // Filtre de statut actuel
  OperatorStatus? _statusFilter;
  
  // Terme de recherche actuel
  String _searchTerm = '';
  
  // Tri actuel
  String _sortBy = 'name';
  bool _sortAscending = true;
  
  // Getters
  List<OperatorModel> get operators => _operators;
  List<OperatorModel> get filteredOperators => _filteredOperators;
  bool get isLoading => _isLoading;
  String? get error => _error;
  OperatorStatus? get statusFilter => _statusFilter;
  String get searchTerm => _searchTerm;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;
  
  // Constructeur
  OperatorsController() {
    _fetchOperators();
  }
  
  // Méthode pour récupérer les opérateurs
  Future<void> _fetchOperators() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Dans une application réelle, cette méthode ferait un appel API
      // Pour l'instant, nous utilisons des données fictives
      await Future.delayed(const Duration(seconds: 1)); // Simuler un délai réseau
      
      _operators = OperatorData.getSampleOperators();
      _applyFiltersAndSort();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Erreur lors de la récupération des opérateurs: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Méthode pour rafraîchir les données
  Future<void> refreshOperators() async {
    await _fetchOperators();
  }
  
  // Méthode pour définir le filtre de statut
  void setStatusFilter(OperatorStatus? status) {
    _statusFilter = status;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Méthode pour définir le terme de recherche
  void setSearchTerm(String term) {
    _searchTerm = term.toLowerCase();
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Méthode pour définir le tri
  void setSorting(String field, bool ascending) {
    _sortBy = field;
    _sortAscending = ascending;
    _applyFiltersAndSort();
    notifyListeners();
  }
  
  // Méthode pour appliquer les filtres et le tri
  void _applyFiltersAndSort() {
    // Appliquer les filtres
    _filteredOperators = _operators.where((operator) {
      // Filtre de statut
      if (_statusFilter != null && operator.status != _statusFilter) {
        return false;
      }
      
      // Filtre de recherche
      if (_searchTerm.isNotEmpty) {
        return operator.name.toLowerCase().contains(_searchTerm) ||
               operator.email.toLowerCase().contains(_searchTerm) ||
               operator.phone.toLowerCase().contains(_searchTerm);
      }
      
      return true;
    }).toList();
    
    // Appliquer le tri
    _filteredOperators.sort((a, b) {
      int compareResult;
      
      switch (_sortBy) {
        case 'name':
          compareResult = a.name.compareTo(b.name);
          break;
        case 'status':
          compareResult = a.status.toString().compareTo(b.status.toString());
          break;
        case 'joinDate':
          compareResult = a.joinDate.compareTo(b.joinDate);
          break;
        case 'completedTickets':
          compareResult = a.completedTickets.compareTo(b.completedTickets);
          break;
        case 'pendingTickets':
          compareResult = a.pendingTickets.compareTo(b.pendingTickets);
          break;
        case 'performanceScore':
          compareResult = a.performanceScore.compareTo(b.performanceScore);
          break;
        default:
          compareResult = a.name.compareTo(b.name);
      }
      
      return _sortAscending ? compareResult : -compareResult;
    });
  }
  
  // Méthode pour obtenir un opérateur par son ID
  OperatorModel? getOperatorById(String id) {
    try {
      return _operators.firstWhere((operator) => operator.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Méthode pour ajouter un opérateur
  Future<void> addOperator(OperatorModel operator) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Dans une application réelle, cette méthode ferait un appel API
      await Future.delayed(const Duration(seconds: 1)); // Simuler un délai réseau
      
      _operators.add(operator);
      _applyFiltersAndSort();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Erreur lors de l\'ajout de l\'opérateur: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Méthode pour mettre à jour un opérateur
  Future<void> updateOperator(OperatorModel updatedOperator) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Dans une application réelle, cette méthode ferait un appel API
      await Future.delayed(const Duration(seconds: 1)); // Simuler un délai réseau
      
      final index = _operators.indexWhere((op) => op.id == updatedOperator.id);
      if (index != -1) {
        _operators[index] = updatedOperator;
        _applyFiltersAndSort();
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Erreur lors de la mise à jour de l\'opérateur: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Méthode pour supprimer un opérateur
  Future<void> deleteOperator(String id) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Dans une application réelle, cette méthode ferait un appel API
      await Future.delayed(const Duration(seconds: 1)); // Simuler un délai réseau
      
      _operators.removeWhere((op) => op.id == id);
      _applyFiltersAndSort();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Erreur lors de la suppression de l\'opérateur: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Méthode pour changer le statut d'un opérateur
  Future<void> changeOperatorStatus(String id, OperatorStatus newStatus) async {
    final operator = getOperatorById(id);
    if (operator != null) {
      final updatedOperator = operator.copyWith(status: newStatus);
      await updateOperator(updatedOperator);
    }
  }
  
  // Méthode pour obtenir des statistiques sur les opérateurs
  Map<String, dynamic> getOperatorStats() {
    if (_operators.isEmpty) {
      return {
        'totalOperators': 0,
        'activeOperators': 0,
        'inactiveOperators': 0,
        'onLeaveOperators': 0,
        'suspendedOperators': 0,
        'averagePerformance': 0.0,
        'totalCompletedTickets': 0,
        'totalPendingTickets': 0,
      };
    }
    
    int activeCount = 0;
    int inactiveCount = 0;
    int onLeaveCount = 0;
    int suspendedCount = 0;
    int totalCompletedTickets = 0;
    int totalPendingTickets = 0;
    double totalPerformance = 0;
    
    for (final operator in _operators) {
      switch (operator.status) {
        case OperatorStatus.active:
          activeCount++;
          break;
        case OperatorStatus.inactive:
          inactiveCount++;
          break;
        case OperatorStatus.onLeave:
          onLeaveCount++;
          break;
        case OperatorStatus.suspended:
          suspendedCount++;
          break;
      }
      
      totalCompletedTickets += operator.completedTickets;
      totalPendingTickets += operator.pendingTickets;
      totalPerformance += operator.performanceScore;
    }
    
    return {
      'totalOperators': _operators.length,
      'activeOperators': activeCount,
      'inactiveOperators': inactiveCount,
      'onLeaveOperators': onLeaveCount,
      'suspendedOperators': suspendedCount,
      'averagePerformance': totalPerformance / _operators.length,
      'totalCompletedTickets': totalCompletedTickets,
      'totalPendingTickets': totalPendingTickets,
    };
  }
}
