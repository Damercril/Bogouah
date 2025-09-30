import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/new_app_theme.dart';
import '../../../core/utils/responsive_helper.dart';

/// Écran des statistiques détaillées de l'opérateur
class OperatorStatsScreen extends StatefulWidget {
  const OperatorStatsScreen({Key? key}) : super(key: key);

  @override
  State<OperatorStatsScreen> createState() => _OperatorStatsScreenState();
}

class _OperatorStatsScreenState extends State<OperatorStatsScreen> {
  int _selectedPeriodIndex = 1; // 0: Jour, 1: Semaine, 2: Mois, 3: Année

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.getHorizontalPadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              
              // Titre
              Text(
                'Mes Statistiques',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Filtres de période
              _buildPeriodFilters(isDarkMode),
              
              const SizedBox(height: 24),
              
              // KPIs principaux
              _buildMainKPIs(isDarkMode),
              
              const SizedBox(height: 24),
              
              // Graphique d'évolution
              _buildEvolutionChart(isDarkMode),
              
              const SizedBox(height: 24),
              
              // Répartition par type
              _buildTypeDistribution(isDarkMode),
              
              const SizedBox(height: 24),
              
              // Temps de réponse
              _buildResponseTimeChart(isDarkMode),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodFilters(bool isDarkMode) {
    final periods = ['Jour', 'Semaine', 'Mois', 'Année'];
    
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: periods.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedPeriodIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedPeriodIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            NewAppTheme.primaryColor,
                            NewAppTheme.secondaryColor,
                          ],
                        )
                      : null,
                  color: isSelected ? null : (isDarkMode ? NewAppTheme.darkBlue : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: NewAppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    periods[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black87),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildMainKPIs(bool isDarkMode) {
    final kpis = [
      {'title': 'Tickets traités', 'value': '124', 'icon': Icons.check_circle, 'color': Colors.green},
      {'title': 'Temps moyen', 'value': '15min', 'icon': Icons.timer, 'color': Colors.blue},
      {'title': 'Chiffre d\'affaires', 'value': '18.5M FCFA', 'icon': Icons.euro, 'color': Colors.orange},
      {'title': 'Taux conversion', 'value': '92%', 'icon': Icons.trending_up, 'color': Colors.purple},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (kpi['color'] as Color).withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                kpi['icon'] as IconData,
                color: kpi['color'] as Color,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                kpi['value'] as String,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                kpi['title'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms, delay: (index * 100).ms).scale();
      },
    );
  }

  Widget _buildEvolutionChart(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
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
            'Évolution des tickets traités',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDarkMode ? Colors.white12 : Colors.grey[300]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white60 : Colors.black54,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: TextStyle(
                              color: isDarkMode ? Colors.white60 : Colors.black54,
                              fontSize: 12,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 15),
                      FlSpot(1, 18),
                      FlSpot(2, 22),
                      FlSpot(3, 19),
                      FlSpot(4, 25),
                      FlSpot(5, 23),
                      FlSpot(6, 28),
                    ],
                    isCurved: true,
                    color: NewAppTheme.primaryColor,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: NewAppTheme.primaryColor.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildTypeDistribution(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
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
            'Répartition par type de ticket',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 150,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          value: 40,
                          title: '40%',
                          color: Colors.blue,
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: 30,
                          title: '30%',
                          color: Colors.green,
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: 20,
                          title: '20%',
                          color: Colors.orange,
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: 10,
                          title: '10%',
                          color: Colors.red,
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegendItem('Technique', Colors.blue, isDarkMode),
                  const SizedBox(height: 8),
                  _buildLegendItem('Facturation', Colors.green, isDarkMode),
                  const SizedBox(height: 8),
                  _buildLegendItem('Support', Colors.orange, isDarkMode),
                  const SizedBox(height: 8),
                  _buildLegendItem('Autre', Colors.red, isDarkMode),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 300.ms);
  }

  Widget _buildLegendItem(String label, Color color, bool isDarkMode) {
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
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildResponseTimeChart(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
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
            'Temps de réponse moyen par jour',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 30,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}m',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white60 : Colors.black54,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: TextStyle(
                              color: isDarkMode ? Colors.white60 : Colors.black54,
                              fontSize: 12,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDarkMode ? Colors.white12 : Colors.grey[300]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 18, color: Colors.purple, width: 16)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 15, color: Colors.purple, width: 16)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 20, color: Colors.purple, width: 16)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 14, color: Colors.purple, width: 16)]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 16, color: Colors.purple, width: 16)]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 12, color: Colors.purple, width: 16)]),
                  BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 10, color: Colors.purple, width: 16)]),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }
}
