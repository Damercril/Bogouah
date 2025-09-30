import 'package:flutter/material.dart';
import '../models/stats_model.dart';

class HomeController with ChangeNotifier {
  // Période sélectionnée pour les statistiques
  String _selectedPeriod = 'Aujourd\'hui';
  List<String> periods = ['Aujourd\'hui', '7 jours', '30 jours', 'Cette année'];
  
  // Getters
  String get selectedPeriod => _selectedPeriod;
  
  // Setter pour la période
  void setPeriod(String period) {
    if (periods.contains(period)) {
      _selectedPeriod = period;
      _fetchStats();
      notifyListeners();
    }
  }
  
  // Statistiques actuelles
  List<StatsModel> _stats = homeStats;
  List<StatsModel> get stats => _stats;
  
  // Données du graphique
  List<ChartData> _chartData = weeklyActivityData;
  List<ChartData> get chartData => _chartData;
  
  // Notifications
  List<NotificationModel> _notifications = recentNotifications;
  List<NotificationModel> get notifications => _notifications;
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;
  
  // Méthode pour récupérer les statistiques selon la période
  void _fetchStats() {
    // Dans une application réelle, cette méthode ferait un appel API
    // Pour l'instant, nous utilisons des données fictives
    
    // Simuler des données différentes selon la période sélectionnée
    switch (_selectedPeriod) {
      case '7 jours':
        _stats = [
          StatsModel(
            title: 'Opérateurs actifs',
            value: 26,
            previousValue: 22,
            unit: 'opérateurs',
            iconType: IconType.operators,
          ),
          StatsModel(
            title: 'Tickets ouverts',
            value: 245,
            previousValue: 210,
            unit: 'tickets',
            iconType: IconType.tickets,
          ),
          StatsModel(
            title: 'Activités',
            value: 432,
            previousValue: 385,
            unit: 'activités',
            iconType: IconType.activity,
          ),
          StatsModel(
            title: 'Performance moyenne',
            value: 88,
            previousValue: 85,
            unit: '%',
            iconType: IconType.performance,
          ),
        ];
        break;
      case '30 jours':
        _stats = [
          StatsModel(
            title: 'Opérateurs actifs',
            value: 28,
            previousValue: 25,
            unit: 'opérateurs',
            iconType: IconType.operators,
          ),
          StatsModel(
            title: 'Tickets ouverts',
            value: 876,
            previousValue: 790,
            unit: 'tickets',
            iconType: IconType.tickets,
          ),
          StatsModel(
            title: 'Activités',
            value: 1245,
            previousValue: 1100,
            unit: 'activités',
            iconType: IconType.activity,
          ),
          StatsModel(
            title: 'Performance moyenne',
            value: 86,
            previousValue: 82,
            unit: '%',
            iconType: IconType.performance,
          ),
        ];
        break;
      case 'Cette année':
        _stats = [
          StatsModel(
            title: 'Opérateurs actifs',
            value: 32,
            previousValue: 24,
            unit: 'opérateurs',
            iconType: IconType.operators,
          ),
          StatsModel(
            title: 'Tickets ouverts',
            value: 5432,
            previousValue: 4800,
            unit: 'tickets',
            iconType: IconType.tickets,
          ),
          StatsModel(
            title: 'Activités',
            value: 12450,
            previousValue: 10200,
            unit: 'activités',
            iconType: IconType.activity,
          ),
          StatsModel(
            title: 'Performance moyenne',
            value: 84,
            previousValue: 80,
            unit: '%',
            iconType: IconType.performance,
          ),
        ];
        break;
      default: // Aujourd'hui
        _stats = homeStats;
    }
  }
  
  // Marquer une notification comme lue
  void markNotificationAsRead(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications[index] = NotificationModel(
        title: _notifications[index].title,
        message: _notifications[index].message,
        time: _notifications[index].time,
        type: _notifications[index].type,
        isRead: true,
      );
      notifyListeners();
    }
  }
  
  // Marquer toutes les notifications comme lues
  void markAllNotificationsAsRead() {
    _notifications = _notifications.map((notification) => 
      NotificationModel(
        title: notification.title,
        message: notification.message,
        time: notification.time,
        type: notification.type,
        isRead: true,
      )
    ).toList();
    notifyListeners();
  }
}
