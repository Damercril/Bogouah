class StatsModel {
  final String title;
  final int value;
  final int previousValue;
  final String unit;
  final IconType iconType;

  StatsModel({
    required this.title,
    required this.value,
    required this.previousValue,
    required this.unit,
    required this.iconType,
  });

  // Calculer le pourcentage de changement
  double get changePercentage {
    if (previousValue == 0) return 0;
    return ((value - previousValue) / previousValue) * 100;
  }

  // Déterminer si le changement est positif
  bool get isPositiveChange {
    return value >= previousValue;
  }
}

// Types d'icônes pour les statistiques
enum IconType {
  operators,
  tickets,
  activity,
  performance,
  revenue,
  customers,
}

// Données de statistiques fictives pour l'écran d'accueil
List<StatsModel> homeStats = [
  StatsModel(
    title: 'Opérateurs actifs',
    value: 24,
    previousValue: 20,
    unit: 'opérateurs',
    iconType: IconType.operators,
  ),
  StatsModel(
    title: 'Tickets ouverts',
    value: 156,
    previousValue: 142,
    unit: 'tickets',
    iconType: IconType.tickets,
  ),
  StatsModel(
    title: 'Activités aujourd\'hui',
    value: 87,
    previousValue: 75,
    unit: 'activités',
    iconType: IconType.activity,
  ),
  StatsModel(
    title: 'Performance moyenne',
    value: 92,
    previousValue: 88,
    unit: '%',
    iconType: IconType.performance,
  ),
];

// Modèle pour les données de graphique
class ChartData {
  final String label;
  final double value;

  ChartData({
    required this.label,
    required this.value,
  });
}

// Données de graphique fictives pour l'écran d'accueil
List<ChartData> weeklyActivityData = [
  ChartData(label: 'Lun', value: 65),
  ChartData(label: 'Mar', value: 72),
  ChartData(label: 'Mer', value: 83),
  ChartData(label: 'Jeu', value: 78),
  ChartData(label: 'Ven', value: 87),
  ChartData(label: 'Sam', value: 45),
  ChartData(label: 'Dim', value: 32),
];

// Modèle pour les notifications récentes
class NotificationModel {
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;
  final bool isRead;

  NotificationModel({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

// Types de notifications
enum NotificationType {
  info,
  warning,
  success,
  error,
}

// Notifications fictives pour l'écran d'accueil
List<NotificationModel> recentNotifications = [
  NotificationModel(
    title: 'Nouveau ticket',
    message: 'Un nouveau ticket a été créé par l\'opérateur Ahmed',
    time: DateTime.now().subtract(const Duration(minutes: 15)),
    type: NotificationType.info,
  ),
  NotificationModel(
    title: 'Performance élevée',
    message: 'L\'opérateur Sophie a atteint 95% de performance aujourd\'hui',
    time: DateTime.now().subtract(const Duration(hours: 2)),
    type: NotificationType.success,
  ),
  NotificationModel(
    title: 'Alerte système',
    message: 'Le serveur principal nécessite une maintenance',
    time: DateTime.now().subtract(const Duration(hours: 5)),
    type: NotificationType.warning,
    isRead: true,
  ),
  NotificationModel(
    title: 'Ticket en retard',
    message: 'Le ticket #45678 est en attente depuis plus de 24 heures',
    time: DateTime.now().subtract(const Duration(days: 1)),
    type: NotificationType.error,
    isRead: true,
  ),
];
