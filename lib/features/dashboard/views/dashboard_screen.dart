import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../controllers/dashboard_controller.dart';
import '../models/dashboard_model.dart';
import '../../../core/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardController(),
      child: const _DashboardContent(),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<DashboardController>(
      builder: (context, controller, _) {
        return Column(
          children: [
            // En-tête avec titre et actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tableau de bord',
                    style: theme.textTheme.headlineMedium,
                  ),
                  Row(
                    children: [
                      // Sélecteur de période
                      DropdownButton<String>(
                        value: controller.selectedPeriod,
                        items: controller.periods.map((String period) {
                          return DropdownMenuItem<String>(
                            value: period,
                            child: Text(period),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.setPeriod(newValue);
                          }
                        },
                        underline: Container(),
                        icon: const Icon(Icons.arrow_drop_down),
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 16),
                      
                      // Bouton d'exportation
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.download),
                        tooltip: 'Exporter les données',
                        onSelected: (String format) async {
                          // Afficher un indicateur de chargement
                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text('Exportation en cours...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          
                          // Exporter les données
                          final success = await controller.exportData(format);
                          
                          // Afficher un message de confirmation
                          if (success) {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text('Données exportées en $format avec succès'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text('Erreur lors de l\'exportation en $format'),
                                backgroundColor: theme.colorScheme.error,
                              ),
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'PDF',
                            child: Text('Exporter en PDF'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Excel',
                            child: Text('Exporter en Excel'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'CSV',
                            child: Text('Exporter en CSV'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Contenu principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      'Aperçu des activités',
                      style: theme.textTheme.headlineMedium,
                    ).animate()
                      .fadeIn(duration: 500.ms)
                      .slideX(begin: -0.1, end: 0, duration: 500.ms),
                    
                    const SizedBox(height: 8),
                    
                    // Sous-titre
                    Text(
                      'Statistiques pour ${controller.selectedPeriod.toLowerCase()}',
                      style: theme.textTheme.bodyLarge,
                    ).animate()
                      .fadeIn(delay: 200.ms, duration: 500.ms),
                    
                    const SizedBox(height: 24),
                    
                    // Cartes de statistiques principales
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: controller.mainStats.length,
                      itemBuilder: (context, index) {
                        return _buildStatCard(
                          context,
                          controller.mainStats[index],
                          index,
                        );
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Graphique d'activité
                    _buildActivityChart(context, controller),
                    
                    const SizedBox(height: 32),
                    
                    // Segments de chauffeurs et performance des opérateurs
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Segments de chauffeurs
                        _buildDriverSegments(context, controller),
                        
                        const SizedBox(height: 40),
                        
                        // Performance des opérateurs
                        _buildOperatorPerformance(context, controller),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildStatCard(BuildContext context, DashboardStat stat, int index) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre et icône
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  stat.title,
                  style: theme.textTheme.titleLarge,
                ),
                Icon(
                  stat.icon,
                  color: stat.color,
                  size: 24,
                ),
              ],
            ),
            
            const Spacer(),
            
            // Valeur
            Text(
              '${stat.value} ${stat.unit}',
              style: theme.textTheme.headlineMedium,
            ),
            
            const SizedBox(height: 8),
            
            // Pourcentage de changement
            Row(
              children: [
                Icon(
                  stat.isPositiveChange ? Icons.arrow_upward : Icons.arrow_downward,
                  color: stat.isPositiveChange ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${stat.changePercentage.abs().toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: stat.isPositiveChange ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'vs période précédente',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: 200 * index), duration: 500.ms)
      .slideY(begin: 0.2, end: 0, delay: Duration(milliseconds: 200 * index), duration: 500.ms);
  }
  
  Widget _buildActivityChart(BuildContext context, DashboardController controller) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activité sur 30 jours',
              style: theme.textTheme.titleLarge,
            ),
            
            const SizedBox(height: 16),
            
            // Légende
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: controller.chartData.map((series) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: series.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        series.name,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // Graphique
            SizedBox(
              height: 350,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: theme.colorScheme.surface,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final series = controller.chartData[barSpot.barIndex];
                          final date = series.data[barSpot.x.toInt()].date;
                          final formattedDate = DateFormat('dd/MM').format(date);
                          
                          return LineTooltipItem(
                            '${series.name}: ${barSpot.y.toInt()}\n$formattedDate',
                            TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: theme.dividerColor,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          if (value % 5 != 0) return const SizedBox();
                          
                          final series = controller.chartData.first;
                          if (value >= series.data.length || value < 0) {
                            return const SizedBox();
                          }
                          
                          final date = series.data[value.toInt()].date;
                          final formattedDate = DateFormat('dd/MM').format(date);
                          
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              formattedDate,
                              style: theme.textTheme.bodySmall,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: theme.textTheme.bodySmall,
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.dividerColor,
                        width: 1,
                      ),
                      left: BorderSide(
                        color: theme.dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  minX: 0,
                  maxX: controller.chartData.first.data.length.toDouble() - 1,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: controller.chartData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final series = entry.value;
                    
                    return LineChartBarData(
                      spots: series.data.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value.value);
                      }).toList(),
                      isCurved: true,
                      color: series.color,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: series.color.withOpacity(0.2),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: 600.ms, duration: 800.ms)
      .slideY(begin: 0.2, end: 0, delay: 600.ms, duration: 800.ms);
  }
  
  Widget _buildDriverSegments(BuildContext context, DashboardController controller) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Segments de chauffeurs',
              style: theme.textTheme.titleLarge,
            ),
            
            const SizedBox(height: 24),
            
            // Graphique en camembert
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                  sections: controller.driverSegments.map((segment) {
                    return PieChartSectionData(
                      color: segment.color,
                      value: segment.percentage,
                      title: '${segment.percentage.toInt()}%',
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Légende
            Column(
              children: controller.driverSegments.map((segment) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: segment.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        segment.name,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Text(
                        '${segment.count}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: 800.ms, duration: 800.ms)
      .slideY(begin: 0.2, end: 0, delay: 800.ms, duration: 800.ms);
  }
  
  Widget _buildOperatorPerformance(BuildContext context, DashboardController controller) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance des opérateurs',
              style: theme.textTheme.titleLarge,
            ),
            
            const SizedBox(height: 16),
            
            // En-tête du tableau
            Row(
              children: [
                const SizedBox(width: 48),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Opérateur',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Performance',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Activités',
                    style: theme.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Tickets',
                    style: theme.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            
            const Divider(height: 32),
            
            // Liste des opérateurs
            ...controller.operatorPerformance.asMap().entries.map((entry) {
              final index = entry.key;
              final operator = entry.value;
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                      child: Text(
                        operator['name'][0].toUpperCase(),
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    
                    // Nom
                    Expanded(
                      flex: 2,
                      child: Text(
                        operator['name'],
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    
                    // Barre de performance
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: operator['performance'] / 100,
                                    backgroundColor: theme.colorScheme.surfaceVariant,
                                    color: _getPerformanceColor(operator['performance']),
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${operator['performance']}%',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Activités
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${operator['activities']}',
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    // Tickets
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${operator['tickets']}',
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ).animate()
                .fadeIn(delay: Duration(milliseconds: 200 * index + 1000), duration: 500.ms)
                .slideX(begin: 0.2, end: 0, delay: Duration(milliseconds: 200 * index + 1000), duration: 500.ms);
            }),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: 800.ms, duration: 800.ms)
      .slideY(begin: 0.2, end: 0, delay: 800.ms, duration: 800.ms);
  }
  
  Color _getPerformanceColor(int performance) {
    if (performance >= 90) {
      return Colors.green;
    } else if (performance >= 80) {
      return Colors.lightGreen;
    } else if (performance >= 70) {
      return Colors.amber;
    } else if (performance >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
