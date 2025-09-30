import 'package:flutter/material.dart';

class DashboardStat {
  final String title;
  final int value;
  final int previousValue;
  final String unit;
  final IconData icon;
  final Color color;

  DashboardStat({
    required this.title,
    required this.value,
    required this.previousValue,
    required this.unit,
    required this.icon,
    required this.color,
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

// Modèle pour les données de graphique
class ChartDataPoint {
  final DateTime date;
  final double value;

  ChartDataPoint({
    required this.date,
    required this.value,
  });
}

// Modèle pour les séries de données de graphique
class ChartSeries {
  final String name;
  final Color color;
  final List<ChartDataPoint> data;

  ChartSeries({
    required this.name,
    required this.color,
    required this.data,
  });
}

// Modèle pour les segments de chauffeurs
class DriverSegment {
  final String name;
  final int count;
  final double percentage;
  final Color color;

  DriverSegment({
    required this.name,
    required this.count,
    required this.percentage,
    required this.color,
  });
}

// Données fictives pour le dashboard
class DashboardData {
  // Statistiques principales
  static List<DashboardStat> getMainStats() {
    return [
      DashboardStat(
        title: 'Opérateurs actifs',
        value: 24,
        previousValue: 20,
        unit: 'opérateurs',
        icon: Icons.people,
        color: Colors.blue,
      ),
      DashboardStat(
        title: 'Tickets ouverts',
        value: 156,
        previousValue: 142,
        unit: 'tickets',
        icon: Icons.confirmation_number,
        color: Colors.orange,
      ),
      DashboardStat(
        title: 'Activités aujourd\'hui',
        value: 87,
        previousValue: 75,
        unit: 'activités',
        icon: Icons.trending_up,
        color: Colors.green,
      ),
      DashboardStat(
        title: 'Performance moyenne',
        value: 92,
        previousValue: 88,
        unit: '%',
        icon: Icons.speed,
        color: Colors.purple,
      ),
    ];
  }

  // Données de graphique d'activité
  static List<ChartSeries> getActivityChartData() {
    final now = DateTime.now();
    
    // Série pour les activités
    final activityData = List.generate(
      30,
      (index) => ChartDataPoint(
        date: DateTime(now.year, now.month, now.day - 29 + index),
        value: 50 + (index % 7) * 10 + (index % 3) * 5,
      ),
    );
    
    // Série pour les tickets
    final ticketsData = List.generate(
      30,
      (index) => ChartDataPoint(
        date: DateTime(now.year, now.month, now.day - 29 + index),
        value: 30 + (index % 5) * 8 + (index % 2) * 7,
      ),
    );
    
    return [
      ChartSeries(
        name: 'Activités',
        color: Colors.blue,
        data: activityData,
      ),
      ChartSeries(
        name: 'Tickets',
        color: Colors.orange,
        data: ticketsData,
      ),
    ];
  }

  // Données de segments de chauffeurs
  static List<DriverSegment> getDriverSegments() {
    return [
      DriverSegment(
        name: 'Segment A',
        count: 45,
        percentage: 45,
        color: Colors.blue,
      ),
      DriverSegment(
        name: 'Segment B',
        count: 30,
        percentage: 30,
        color: Colors.green,
      ),
      DriverSegment(
        name: 'Segment C',
        count: 15,
        percentage: 15,
        color: Colors.orange,
      ),
      DriverSegment(
        name: 'Segment D',
        count: 10,
        percentage: 10,
        color: Colors.purple,
      ),
    ];
  }

  // Données de performance des opérateurs
  static List<Map<String, dynamic>> getOperatorPerformance() {
    return [
      {
        'name': 'Sophie Martin',
        'performance': 95,
        'activities': 42,
        'tickets': 18,
        'avatar': 'assets/images/avatar1.png',
      },
      {
        'name': 'Thomas Dubois',
        'performance': 92,
        'activities': 38,
        'tickets': 15,
        'avatar': 'assets/images/avatar2.png',
      },
      {
        'name': 'Emma Bernard',
        'performance': 88,
        'activities': 35,
        'tickets': 20,
        'avatar': 'assets/images/avatar3.png',
      },
      {
        'name': 'Lucas Petit',
        'performance': 85,
        'activities': 32,
        'tickets': 12,
        'avatar': 'assets/images/avatar4.png',
      },
      {
        'name': 'Chloé Durand',
        'performance': 82,
        'activities': 30,
        'tickets': 14,
        'avatar': 'assets/images/avatar5.png',
      },
    ];
  }
}
