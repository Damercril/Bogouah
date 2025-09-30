import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../core/theme/new_app_theme.dart';
import '../models/operator_stats.dart';
import '../models/modification_history.dart';

class OperatorDetailScreen extends StatefulWidget {
  final Map<String, dynamic> operator;
  final OperatorStats operatorStats;

  const OperatorDetailScreen({
    Key? key,
    required this.operator,
    required this.operatorStats,
  }) : super(key: key);

  @override
  State<OperatorDetailScreen> createState() => _OperatorDetailScreenState();
}

class _OperatorDetailScreenState extends State<OperatorDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late OperatorStats _operatorStats;
  late ModificationHistory _modificationHistory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Utiliser les statistiques fournies
    _operatorStats = widget.operatorStats;
    // Générer des données fictives pour l'historique des modifications
    _modificationHistory = ModificationHistory.generateMockDataForOperator(widget.operator['id'] ?? widget.operator['name']);
    // Initialiser les données de localisation pour le français
    initializeDateFormatting('fr_FR', null);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'opérateur'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // En-tête avec informations de l'opérateur
          _buildOperatorHeader(isDarkMode),
          
          // Résumé des performances
          _buildPerformanceSummary(isDarkMode),
          
          // Onglets pour les différents graphiques
          Container(
            color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
            child: TabBar(
              controller: _tabController,
              labelColor: NewAppTheme.primaryColor,
              unselectedLabelColor: isDarkMode ? NewAppTheme.white.withOpacity(0.7) : NewAppTheme.darkGrey.withOpacity(0.7),
              indicatorColor: NewAppTheme.primaryColor,
              tabs: [
                Tab(text: 'Appels'),
                Tab(text: 'Revenus'),
                Tab(text: 'Satisfaction'),
                Tab(text: 'Historique des modifications'),
              ],
            ),
          ),
          
          // Contenu des onglets
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCallsTab(isDarkMode),
                _buildRevenueTab(isDarkMode),
                _buildSatisfactionTab(isDarkMode),
                _buildModificationHistoryTab(isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperatorHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: NewAppTheme.primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.operator['avatar'],
                style: TextStyle(
                  color: NewAppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Informations
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.operator['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.operator['role'],
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode
                        ? NewAppTheme.white.withOpacity(0.7)
                        : NewAppTheme.darkGrey.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: widget.operator['statusColor'],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.operator['status'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: widget.operator['statusColor'],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: isDarkMode
                          ? NewAppTheme.white.withOpacity(0.5)
                          : NewAppTheme.darkGrey.withOpacity(0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Actif ${widget.operator['lastActive']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? NewAppTheme.white.withOpacity(0.5)
                            : NewAppTheme.darkGrey.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildPerformanceSummary(bool isDarkMode) {
    final summary = _operatorStats.performanceSummary;
    final formatter = NumberFormat('#,###', 'fr_FR');
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Résumé des performances (ce mois)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSummaryCard(
                  icon: Icons.call,
                  title: '${summary.totalCallsThisMonth}',
                  subtitle: 'Appels',
                  color: NewAppTheme.primaryColor,
                  isDarkMode: isDarkMode,
                ),
                _buildSummaryCard(
                  icon: Icons.attach_money,
                  title: '${formatter.format(summary.totalRevenueThisMonth / 1000000)} M',
                  subtitle: 'FCFA',
                  color: NewAppTheme.accentColor,
                  isDarkMode: isDarkMode,
                ),
                _buildSummaryCard(
                  icon: Icons.thumb_up,
                  title: '${summary.averageSatisfactionRate.toStringAsFixed(1)}%',
                  subtitle: 'Satisfaction',
                  color: NewAppTheme.secondaryColor,
                  isDarkMode: isDarkMode,
                ),
                _buildSummaryCard(
                  icon: Icons.check_circle,
                  title: '${summary.callCompletionRate.toStringAsFixed(1)}%',
                  subtitle: 'Complétion',
                  color: Colors.green,
                  isDarkMode: isDarkMode,
                ),
                _buildSummaryCard(
                  icon: Icons.timer,
                  title: '${summary.averageCallDuration} min',
                  subtitle: 'Durée moy.',
                  color: Colors.orange,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDarkMode,
  }) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue.withOpacity(0.3) : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? color.withOpacity(0.3) : color.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode
                  ? NewAppTheme.white.withOpacity(0.7)
                  : NewAppTheme.darkGrey.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallsTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques d\'appels (7 derniers jours)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxCallValue() * 1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final callStats = _operatorStats.callStats[groupIndex];
                      String tooltipText = '';
                      if (rodIndex == 0) {
                        tooltipText = 'Appels terminés: ${callStats.completedCalls}';
                      } else if (rodIndex == 1) {
                        tooltipText = 'Appels manqués: ${callStats.missedCalls}';
                      }
                      return BarTooltipItem(
                        tooltipText,
                        TextStyle(
                          color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < _operatorStats.callStats.length) {
                          final date = _operatorStats.callStats[index].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('E', 'fr_FR').format(date),
                              style: TextStyle(
                                color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: isDarkMode ? NewAppTheme.white.withOpacity(0.7) : NewAppTheme.darkGrey.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDarkMode
                          ? NewAppTheme.white.withOpacity(0.1)
                          : NewAppTheme.darkGrey.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                barGroups: _getCallBarGroups(isDarkMode),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildCallsLegend(isDarkMode),
          const SizedBox(height: 24),
          _buildCallsAnalysis(isDarkMode),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  List<BarChartGroupData> _getCallBarGroups(bool isDarkMode) {
    return List.generate(_operatorStats.callStats.length, (index) {
      final callStats = _operatorStats.callStats[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: callStats.completedCalls.toDouble(),
            color: NewAppTheme.primaryColor,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: callStats.missedCalls.toDouble(),
            color: NewAppTheme.errorColor,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }

  double _getMaxCallValue() {
    double maxValue = 0;
    for (var stat in _operatorStats.callStats) {
      final total = stat.totalCalls.toDouble();
      if (total > maxValue) maxValue = total;
    }
    return maxValue;
  }

  Widget _buildCallsLegend(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          color: NewAppTheme.primaryColor,
          label: 'Appels terminés',
          isDarkMode: isDarkMode,
        ),
        const SizedBox(width: 24),
        _buildLegendItem(
          color: NewAppTheme.errorColor,
          label: 'Appels manqués',
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildCallsAnalysis(bool isDarkMode) {
    // Calculer le taux de complétion moyen
    double completionRate = 0;
    int totalCalls = 0;
    int completedCalls = 0;
    
    for (var stat in _operatorStats.callStats) {
      totalCalls += stat.totalCalls;
      completedCalls += stat.completedCalls;
    }
    
    if (totalCalls > 0) {
      completionRate = (completedCalls / totalCalls) * 100;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analyse des appels',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnalysisItem(
                  icon: Icons.call,
                  value: '$totalCalls',
                  label: 'Total des appels',
                  isDarkMode: isDarkMode,
                ),
              ),
              Expanded(
                child: _buildAnalysisItem(
                  icon: Icons.check_circle,
                  value: '${completionRate.toStringAsFixed(1)}%',
                  label: 'Taux de complétion',
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'L\'opérateur a traité $totalCalls appels au cours des 7 derniers jours avec un taux de complétion de ${completionRate.toStringAsFixed(1)}%.',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? NewAppTheme.white.withOpacity(0.7) : NewAppTheme.darkGrey.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisItem({
    required IconData icon,
    required String value,
    required String label,
    required bool isDarkMode,
  }) {
    return Column(
      children: [
        Icon(icon, color: NewAppTheme.primaryColor, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode
                ? NewAppTheme.white.withOpacity(0.7)
                : NewAppTheme.darkGrey.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueTab(bool isDarkMode) {
    final formatter = NumberFormat('#,###', 'fr_FR');
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques de revenus (7 derniers jours)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: _operatorStats.revenueStats.length - 1.0,
                minY: 0,
                maxY: _getMaxRevenueValue() * 1.2,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        if (index >= 0 && index < _operatorStats.revenueStats.length) {
                          final revenue = _operatorStats.revenueStats[index].totalRevenue;
                          return LineTooltipItem(
                            '${formatter.format(revenue)} FCFA',
                            TextStyle(
                              color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          );
                        }
                        return null;
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _getMaxRevenueValue() / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDarkMode
                          ? NewAppTheme.white.withOpacity(0.1)
                          : NewAppTheme.darkGrey.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < _operatorStats.revenueStats.length) {
                          final date = _operatorStats.revenueStats[index].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('E', 'fr_FR').format(date),
                              style: TextStyle(
                                color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '${formatter.format(value / 1000)}k',
                            style: TextStyle(
                              color: isDarkMode ? NewAppTheme.white.withOpacity(0.7) : NewAppTheme.darkGrey.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getRevenueSpots(),
                    isCurved: true,
                    color: NewAppTheme.accentColor,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: NewAppTheme.accentColor.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildRevenueLegend(isDarkMode),
          const SizedBox(height: 24),
          _buildRevenueAnalysis(isDarkMode),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  List<FlSpot> _getRevenueSpots() {
    return List.generate(_operatorStats.revenueStats.length, (index) {
      final revenue = _operatorStats.revenueStats[index].totalRevenue;
      return FlSpot(index.toDouble(), revenue);
    });
  }

  double _getMaxRevenueValue() {
    double maxValue = 0;
    for (var stat in _operatorStats.revenueStats) {
      if (stat.totalRevenue > maxValue) maxValue = stat.totalRevenue;
    }
    return maxValue;
  }

  Widget _buildRevenueLegend(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          color: NewAppTheme.accentColor,
          label: 'Revenus (FCFA)',
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildRevenueAnalysis(bool isDarkMode) {
    final formatter = NumberFormat('#,###', 'fr_FR');
    
    // Calculer le revenu total et moyen
    double totalRevenue = 0;
    double averageRevenue = 0;
    
    for (var stat in _operatorStats.revenueStats) {
      totalRevenue += stat.totalRevenue;
    }
    
    if (_operatorStats.revenueStats.isNotEmpty) {
      averageRevenue = totalRevenue / _operatorStats.revenueStats.length;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analyse des revenus',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnalysisItem(
                  icon: Icons.attach_money,
                  value: '${formatter.format(totalRevenue)} FCFA',
                  label: 'Revenu total',
                  isDarkMode: isDarkMode,
                ),
              ),
              Expanded(
                child: _buildAnalysisItem(
                  icon: Icons.trending_up,
                  value: '${formatter.format(averageRevenue)} FCFA',
                  label: 'Revenu moyen/jour',
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'L\'opérateur a généré un revenu total de ${formatter.format(totalRevenue)} FCFA au cours des 7 derniers jours, avec une moyenne de ${formatter.format(averageRevenue)} FCFA par jour.',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? NewAppTheme.white.withOpacity(0.7) : NewAppTheme.darkGrey.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSatisfactionTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Satisfaction client (6 derniers mois)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: _operatorStats.satisfactionStats.length - 1.0,
                minY: 70,
                maxY: 100,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        if (index >= 0 && index < _operatorStats.satisfactionStats.length) {
                          final satisfaction = _operatorStats.satisfactionStats[index];
                          return LineTooltipItem(
                            '${satisfaction.satisfactionRate.toStringAsFixed(1)}% (${satisfaction.totalRatings} avis)',
                            TextStyle(
                              color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          );
                        }
                        return null;
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDarkMode
                          ? NewAppTheme.white.withOpacity(0.1)
                          : NewAppTheme.darkGrey.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < _operatorStats.satisfactionStats.length) {
                          final date = _operatorStats.satisfactionStats[index].month;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('MMM', 'fr_FR').format(date),
                              style: TextStyle(
                                color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '${value.toInt()}%',
                            style: TextStyle(
                              color: isDarkMode ? NewAppTheme.white.withOpacity(0.7) : NewAppTheme.darkGrey.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getSatisfactionSpots(),
                    isCurved: true,
                    color: NewAppTheme.secondaryColor,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: NewAppTheme.secondaryColor.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSatisfactionLegend(isDarkMode),
          const SizedBox(height: 24),
          _buildSatisfactionAnalysis(isDarkMode),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  List<FlSpot> _getSatisfactionSpots() {
    return List.generate(_operatorStats.satisfactionStats.length, (index) {
      final satisfaction = _operatorStats.satisfactionStats[index].satisfactionRate;
      return FlSpot(index.toDouble(), satisfaction);
    });
  }

  Widget _buildSatisfactionLegend(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          color: NewAppTheme.secondaryColor,
          label: 'Taux de satisfaction (%)',
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildSatisfactionAnalysis(bool isDarkMode) {
    // Calculer la satisfaction moyenne et le total des avis
    double averageSatisfaction = 0;
    int totalRatings = 0;
    
    for (var stat in _operatorStats.satisfactionStats) {
      averageSatisfaction += stat.satisfactionRate;
      totalRatings += stat.totalRatings;
    }
    
    if (_operatorStats.satisfactionStats.isNotEmpty) {
      averageSatisfaction /= _operatorStats.satisfactionStats.length;
    }
    
    // Tendance (en hausse ou en baisse)
    String trend = 'stable';
    if (_operatorStats.satisfactionStats.length >= 2) {
      final lastMonth = _operatorStats.satisfactionStats.last.satisfactionRate;
      final previousMonth = _operatorStats.satisfactionStats[_operatorStats.satisfactionStats.length - 2].satisfactionRate;
      if (lastMonth > previousMonth) {
        trend = 'en hausse';
      } else if (lastMonth < previousMonth) {
        trend = 'en baisse';
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analyse de la satisfaction',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnalysisItem(
                  icon: Icons.thumb_up,
                  value: '${averageSatisfaction.toStringAsFixed(1)}%',
                  label: 'Satisfaction moyenne',
                  isDarkMode: isDarkMode,
                ),
              ),
              Expanded(
                child: _buildAnalysisItem(
                  icon: Icons.people,
                  value: '$totalRatings',
                  label: 'Total des avis',
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'La satisfaction client pour cet opérateur est de ${averageSatisfaction.toStringAsFixed(1)}% en moyenne sur les 6 derniers mois, avec une tendance $trend. Un total de $totalRatings avis ont été recueillis.',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? NewAppTheme.white.withOpacity(0.7) : NewAppTheme.darkGrey.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModificationHistoryTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Historique des modifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._modificationHistory.entries.map((entry) => _buildModificationEntryCard(entry, isDarkMode)).toList(),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildModificationEntryCard(ModificationEntry entry, bool isDarkMode) {
    // Déterminer l'icône en fonction du type de modification
    IconData icon;
    Color iconColor;
    
    switch (entry.modificationType) {
      case ModificationType.statusChange:
        icon = Icons.toggle_on;
        iconColor = Colors.green;
        break;
      case ModificationType.roleChange:
        icon = Icons.badge;
        iconColor = NewAppTheme.primaryColor;
        break;
      case ModificationType.infoChange:
        icon = Icons.edit;
        iconColor = Colors.blue;
        break;
      case ModificationType.teamChange:
        icon = Icons.group;
        iconColor = NewAppTheme.accentColor;
        break;
      case ModificationType.accountCreation:
        icon = Icons.person_add;
        iconColor = NewAppTheme.secondaryColor;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec date et auteur
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? NewAppTheme.darkBlue.withOpacity(0.3) : NewAppTheme.primaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('dd MMMM yyyy à HH:mm', 'fr_FR').format(entry.date),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Par ${entry.modifiedBy}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? NewAppTheme.white.withOpacity(0.7) : NewAppTheme.darkGrey.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Contenu de la modification
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Raison de la modification
                Text(
                  entry.modificationReason,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Champ modifié
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Champ modifié: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? NewAppTheme.white.withOpacity(0.7) : NewAppTheme.darkGrey.withOpacity(0.7),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.fieldName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Valeurs avant/après
                Row(
                  children: [
                    Expanded(
                      child: _buildValueBox(
                        'Ancienne valeur',
                        entry.oldValue,
                        Colors.red.withOpacity(0.1),
                        Colors.red,
                        isDarkMode,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.arrow_forward,
                      color: isDarkMode ? NewAppTheme.white.withOpacity(0.5) : NewAppTheme.darkGrey.withOpacity(0.5),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildValueBox(
                        'Nouvelle valeur',
                        entry.newValue,
                        Colors.green.withOpacity(0.1),
                        Colors.green,
                        isDarkMode,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }

  Widget _buildValueBox(String label, String value, Color bgColor, Color textColor, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue.withOpacity(0.3) : bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkMode ? textColor.withOpacity(0.3) : textColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? textColor.withOpacity(0.8) : textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}
