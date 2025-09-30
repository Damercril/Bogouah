class OperatorStats {
  final String operatorId;
  final List<DailyCallStats> callStats;
  final List<DailyRevenueStats> revenueStats;
  final List<MonthlySatisfactionStats> satisfactionStats;
  final PerformanceSummary performanceSummary;

  OperatorStats({
    required this.operatorId,
    required this.callStats,
    required this.revenueStats,
    required this.satisfactionStats,
    required this.performanceSummary,
  });

  // Méthode pour générer des données fictives pour un opérateur
  static OperatorStats generateMockDataForOperator(String operatorId) {
    // Statistiques d'appels quotidiens sur 7 jours
    final callStats = List.generate(7, (index) {
      final date = DateTime.now().subtract(Duration(days: 6 - index));
      return DailyCallStats(
        date: date,
        totalCalls: 10 + (index * 2) + (index % 3 == 0 ? 5 : 0),
        completedCalls: 8 + (index * 2) + (index % 3 == 0 ? 3 : 0),
        missedCalls: 2 + (index % 2),
      );
    });

    // Statistiques de revenus quotidiens sur 7 jours (en FCFA)
    final revenueStats = List.generate(7, (index) {
      final date = DateTime.now().subtract(Duration(days: 6 - index));
      return DailyRevenueStats(
        date: date,
        totalRevenue: 50000 + (index * 10000) + (index % 3 == 0 ? 20000 : 0),
      );
    });

    // Statistiques de satisfaction mensuelles sur 6 mois
    final satisfactionStats = List.generate(6, (index) {
      final date = DateTime.now().subtract(Duration(days: 30 * (5 - index)));
      return MonthlySatisfactionStats(
        month: date,
        satisfactionRate: 80 + (index * 2) + (index % 2 == 0 ? 3 : 1),
        totalRatings: 20 + (index * 5),
      );
    });

    // Résumé des performances
    final performanceSummary = PerformanceSummary(
      totalCallsThisMonth: 120,
      totalRevenueThisMonth: 350000, // en FCFA
      averageSatisfactionRate: 92,
      callCompletionRate: 85,
      averageCallDuration: 15, // en minutes
    );

    return OperatorStats(
      operatorId: operatorId,
      callStats: callStats,
      revenueStats: revenueStats,
      satisfactionStats: satisfactionStats,
      performanceSummary: performanceSummary,
    );
  }
}

class DailyCallStats {
  final DateTime date;
  final int totalCalls;
  final int completedCalls;
  final int missedCalls;

  DailyCallStats({
    required this.date,
    required this.totalCalls,
    required this.completedCalls,
    required this.missedCalls,
  });
}

class DailyRevenueStats {
  final DateTime date;
  final double totalRevenue;

  DailyRevenueStats({
    required this.date,
    required this.totalRevenue,
  });
}

class MonthlySatisfactionStats {
  final DateTime month;
  final double satisfactionRate;
  final int totalRatings;

  MonthlySatisfactionStats({
    required this.month,
    required this.satisfactionRate,
    required this.totalRatings,
  });
}

class PerformanceSummary {
  final int totalCallsThisMonth;
  final double totalRevenueThisMonth;
  final double averageSatisfactionRate;
  final double callCompletionRate;
  final double averageCallDuration;

  PerformanceSummary({
    required this.totalCallsThisMonth,
    required this.totalRevenueThisMonth,
    required this.averageSatisfactionRate,
    required this.callCompletionRate,
    required this.averageCallDuration,
  });
}
