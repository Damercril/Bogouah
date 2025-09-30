import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';

class DashboardController with ChangeNotifier {
  // Période sélectionnée pour les statistiques
  String _selectedPeriod = 'Aujourd\'hui';
  List<String> periods = ['Aujourd\'hui', '7 jours', '14 jours', '30 jours', 'Cette année'];
  
  // Statistiques principales
  List<DashboardStat> _mainStats = DashboardData.getMainStats();
  
  // Données de graphique
  List<ChartSeries> _chartData = DashboardData.getActivityChartData();
  
  // Segments de chauffeurs
  List<DriverSegment> _driverSegments = DashboardData.getDriverSegments();
  
  // Performance des opérateurs
  List<Map<String, dynamic>> _operatorPerformance = DashboardData.getOperatorPerformance();
  
  // Getters
  String get selectedPeriod => _selectedPeriod;
  List<DashboardStat> get mainStats => _mainStats;
  List<ChartSeries> get chartData => _chartData;
  List<DriverSegment> get driverSegments => _driverSegments;
  List<Map<String, dynamic>> get operatorPerformance => _operatorPerformance;
  
  // Setter pour la période
  void setPeriod(String period) {
    if (periods.contains(period)) {
      _selectedPeriod = period;
      _fetchDashboardData();
      notifyListeners();
    }
  }
  
  // Méthode pour récupérer les données du dashboard
  void _fetchDashboardData() {
    // Dans une application réelle, cette méthode ferait un appel API
    // Pour l'instant, nous utilisons des données fictives
    
    // Simuler des données différentes selon la période sélectionnée
    switch (_selectedPeriod) {
      case '7 jours':
        _mainStats = [
          DashboardStat(
            title: 'Opérateurs actifs',
            value: 26,
            previousValue: 22,
            unit: 'opérateurs',
            icon: Icons.people,
            color: Colors.blue,
          ),
          DashboardStat(
            title: 'Tickets ouverts',
            value: 245,
            previousValue: 210,
            unit: 'tickets',
            icon: Icons.confirmation_number,
            color: Colors.orange,
          ),
          DashboardStat(
            title: 'Activités',
            value: 432,
            previousValue: 385,
            unit: 'activités',
            icon: Icons.trending_up,
            color: Colors.green,
          ),
          DashboardStat(
            title: 'Performance moyenne',
            value: 88,
            previousValue: 85,
            unit: '%',
            icon: Icons.speed,
            color: Colors.purple,
          ),
        ];
        break;
      case '14 jours':
        _mainStats = [
          DashboardStat(
            title: 'Opérateurs actifs',
            value: 27,
            previousValue: 24,
            unit: 'opérateurs',
            icon: Icons.people,
            color: Colors.blue,
          ),
          DashboardStat(
            title: 'Tickets ouverts',
            value: 520,
            previousValue: 480,
            unit: 'tickets',
            icon: Icons.confirmation_number,
            color: Colors.orange,
          ),
          DashboardStat(
            title: 'Activités',
            value: 876,
            previousValue: 790,
            unit: 'activités',
            icon: Icons.trending_up,
            color: Colors.green,
          ),
          DashboardStat(
            title: 'Performance moyenne',
            value: 87,
            previousValue: 84,
            unit: '%',
            icon: Icons.speed,
            color: Colors.purple,
          ),
        ];
        break;
      case '30 jours':
        _mainStats = [
          DashboardStat(
            title: 'Opérateurs actifs',
            value: 28,
            previousValue: 25,
            unit: 'opérateurs',
            icon: Icons.people,
            color: Colors.blue,
          ),
          DashboardStat(
            title: 'Tickets ouverts',
            value: 876,
            previousValue: 790,
            unit: 'tickets',
            icon: Icons.confirmation_number,
            color: Colors.orange,
          ),
          DashboardStat(
            title: 'Activités',
            value: 1245,
            previousValue: 1100,
            unit: 'activités',
            icon: Icons.trending_up,
            color: Colors.green,
          ),
          DashboardStat(
            title: 'Performance moyenne',
            value: 86,
            previousValue: 82,
            unit: '%',
            icon: Icons.speed,
            color: Colors.purple,
          ),
        ];
        break;
      case 'Cette année':
        _mainStats = [
          DashboardStat(
            title: 'Opérateurs actifs',
            value: 32,
            previousValue: 24,
            unit: 'opérateurs',
            icon: Icons.people,
            color: Colors.blue,
          ),
          DashboardStat(
            title: 'Tickets ouverts',
            value: 5432,
            previousValue: 4800,
            unit: 'tickets',
            icon: Icons.confirmation_number,
            color: Colors.orange,
          ),
          DashboardStat(
            title: 'Activités',
            value: 12450,
            previousValue: 10200,
            unit: 'activités',
            icon: Icons.trending_up,
            color: Colors.green,
          ),
          DashboardStat(
            title: 'Performance moyenne',
            value: 84,
            previousValue: 80,
            unit: '%',
            icon: Icons.speed,
            color: Colors.purple,
          ),
        ];
        break;
      default: // Aujourd'hui
        _mainStats = DashboardData.getMainStats();
    }
    
    // Dans une application réelle, nous mettrions également à jour les autres données
    // en fonction de la période sélectionnée
  }
  
  // Méthode pour exporter les données
  Future<bool> exportData(String format) async {
    // Dans une application réelle, cette méthode exporterait les données
    // dans le format spécifié (PDF, Excel, etc.)
    
    // Simuler un délai pour l'exportation
    await Future.delayed(const Duration(seconds: 2));
    
    // Retourner true pour indiquer que l'exportation a réussi
    return true;
  }
}
