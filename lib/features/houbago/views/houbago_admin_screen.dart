import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/new_app_theme.dart';
import '../../../core/utils/responsive_helper.dart';

/// Interface administrateur Houbago avec statistiques du programme de parrainage
class HoubagoAdminScreen extends StatefulWidget {
  const HoubagoAdminScreen({Key? key}) : super(key: key);

  @override
  State<HoubagoAdminScreen> createState() => _HoubagoAdminScreenState();
}

class _HoubagoAdminScreenState extends State<HoubagoAdminScreen> {
  int _selectedPeriodIndex = 1; // 0: Jour, 1: Semaine, 2: Mois, 3: Année
  final List<String> _periods = ['Jour', 'Semaine', 'Mois', 'Année'];

  // Statistiques globales du programme
  final Map<int, Map<String, dynamic>> _globalStats = {
    0: { // Jour
      'totalParrains': 245,
      'nouveauxParrains': 8,
      'totalAffiliés': 1240,
      'nouveauxAffiliés': 32,
      'chauffeursActifs': 156,
      'nombreRechargements': 342,
      'chauffeurs': 156,
      'propriétaires': 89,
      'caGenere': 2450000,
      'commissionsPayees': 245000,
      'tauxConversion': 68,
      'parrainsMoyenParJour': 8,
    },
    1: { // Semaine
      'totalParrains': 245,
      'nouveauxParrains': 42,
      'totalAffiliés': 1240,
      'nouveauxAffiliés': 185,
      'chauffeursActifs': 156,
      'nombreRechargements': 2458,
      'chauffeurs': 156,
      'propriétaires': 89,
      'caGenere': 15800000,
      'commissionsPayees': 1580000,
      'tauxConversion': 72,
      'parrainsMoyenParJour': 6,
    },
    2: { // Mois
      'totalParrains': 245,
      'nouveauxParrains': 168,
      'totalAffiliés': 1240,
      'nouveauxAffiliés': 742,
      'chauffeursActifs': 156,
      'nombreRechargements': 10850,
      'chauffeurs': 156,
      'propriétaires': 89,
      'caGenere': 68500000,
      'commissionsPayees': 6850000,
      'tauxConversion': 75,
      'parrainsMoyenParJour': 5.6,
    },
    3: { // Année
      'totalParrains': 245,
      'nouveauxParrains': 245,
      'totalAffiliés': 1240,
      'nouveauxAffiliés': 1240,
      'chauffeursActifs': 156,
      'nombreRechargements': 128450,
      'chauffeurs': 156,
      'propriétaires': 89,
      'caGenere': 825000000,
      'commissionsPayees': 82500000,
      'tauxConversion': 78,
      'parrainsMoyenParJour': 0.67,
    },
  };

  // Top parrains
  final List<Map<String, dynamic>> _topParrains = [
    {
      'name': 'Jean Dupont',
      'avatar': 'JD',
      'affilies': 45,
      'caGenere': 12500000,
      'commissions': 1250000,
      'chauffeurs': 28,
      'proprietaires': 17,
      'badge': '🏆',
    },
    {
      'name': 'Marie Martin',
      'avatar': 'MM',
      'affilies': 38,
      'caGenere': 9800000,
      'commissions': 980000,
      'chauffeurs': 22,
      'proprietaires': 16,
      'badge': '🥈',
    },
    {
      'name': 'Pierre Durand',
      'avatar': 'PD',
      'affilies': 32,
      'caGenere': 8200000,
      'commissions': 820000,
      'chauffeurs': 19,
      'proprietaires': 13,
      'badge': '🥉',
    },
  ];

  // Données pour le graphique d'évolution
  final List<Map<String, dynamic>> _evolutionData = [
    {'month': 'Jan', 'parrains': 45, 'affilies': 180},
    {'month': 'Fév', 'parrains': 52, 'affilies': 210},
    {'month': 'Mar', 'parrains': 68, 'affilies': 285},
    {'month': 'Avr', 'parrains': 82, 'affilies': 340},
    {'month': 'Mai', 'parrains': 95, 'affilies': 425},
    {'month': 'Juin', 'parrains': 118, 'affilies': 520},
    {'month': 'Juil', 'parrains': 145, 'affilies': 680},
    {'month': 'Août', 'parrains': 178, 'affilies': 850},
    {'month': 'Sep', 'parrains': 205, 'affilies': 1020},
    {'month': 'Oct', 'parrains': 225, 'affilies': 1150},
    {'month': 'Nov', 'parrains': 238, 'affilies': 1210},
    {'month': 'Déc', 'parrains': 245, 'affilies': 1240},
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final stats = _globalStats[_selectedPeriodIndex]!;
    
    return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.getHorizontalPadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              
              // En-tête
              _buildHeader(isDarkMode, stats),
              
              const SizedBox(height: 24),
              
              // Sélecteur de période
              _buildPeriodSelector(isDarkMode),
              
              const SizedBox(height: 24),
              
              // KPIs MAJEURS (les 3 plus importants)
              _buildMajorKPIs(isDarkMode, stats),
              
              const SizedBox(height: 24),
              
              // KPIs principaux (autres)
              _buildMainKPIs(isDarkMode, stats),
              
              const SizedBox(height: 32),
              
              // Statistiques détaillées
              _buildDetailedStats(isDarkMode, stats),
              
              const SizedBox(height: 32),
              
              // Graphiques et statistiques détaillées
              ResponsiveHelper.isDesktop(context)
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Graphique d'évolution
                        Expanded(
                          flex: 2,
                          child: _buildEvolutionChart(isDarkMode),
                        ),
                        const SizedBox(width: 24),
                        // Répartition chauffeurs/propriétaires
                        Expanded(
                          child: _buildDistributionChart(isDarkMode, stats),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildEvolutionChart(isDarkMode),
                        const SizedBox(height: 24),
                        _buildDistributionChart(isDarkMode, stats),
                      ],
                    ),
              
              const SizedBox(height: 32),
              
              // Statistiques par période
              _buildPeriodStats(isDarkMode, stats),
              
              const SizedBox(height: 32),
              
              // Performance du programme
              _buildProgramPerformance(isDarkMode, stats),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
    );
  }

  Widget _buildHeader(bool isDarkMode, Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple,
            Colors.deepPurple,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.people_alt,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Programme Houbago',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${stats['totalParrains'] ?? 0} parrains actifs • ${stats['totalAffiliés'] ?? 0} affiliés',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  'Impact CA',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${((stats['caGenere'] ?? 0) / 1000000).toStringAsFixed(1)}M',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildPeriodSelector(bool isDarkMode) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: List.generate(
          _periods.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriodIndex = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedPeriodIndex == index
                      ? Colors.purple
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    _periods[index],
                    style: TextStyle(
                      color: _selectedPeriodIndex == index
                          ? Colors.white
                          : (isDarkMode ? Colors.white60 : Colors.black54),
                      fontWeight: _selectedPeriodIndex == index
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildMajorKPIs(bool isDarkMode, Map<String, dynamic> stats) {
    final isDesktopOrTablet = ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isTablet(context);
    
    if (isDesktopOrTablet) {
      return Row(
        children: [
          Expanded(
            child: _buildMajorKPICard(
              'Rechargements',
              '${stats['nombreRechargements'] ?? 0}',
              Icons.credit_card,
              Colors.blue,
              isDarkMode,
              'Total des rechargements',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildMajorKPICard(
              'Chauffeurs Actifs',
              '${stats['chauffeursActifs'] ?? 0}',
              Icons.local_taxi,
              Colors.green,
              isDarkMode,
              'Chauffeurs en activité',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildMajorKPICard(
              'CA Généré',
              '${((stats['caGenere'] ?? 0) / 1000000).toStringAsFixed(1)}M',
              Icons.attach_money,
              Colors.purple,
              isDarkMode,
              'Chiffre d\'affaires FCFA',
            ),
          ),
        ],
      );
    }
    
    return Column(
      children: [
        _buildMajorKPICard(
          'Rechargements',
          '${stats['nombreRechargements'] ?? 0}',
          Icons.credit_card,
          Colors.blue,
          isDarkMode,
          'Total des rechargements',
        ),
        const SizedBox(height: 16),
        _buildMajorKPICard(
          'Chauffeurs Actifs',
          '${stats['chauffeursActifs'] ?? 0}',
          Icons.local_taxi,
          Colors.green,
          isDarkMode,
          'Chauffeurs en activité',
        ),
        const SizedBox(height: 16),
        _buildMajorKPICard(
          'CA Généré',
          '${((stats['caGenere'] ?? 0) / 1000000).toStringAsFixed(1)}M',
          Icons.attach_money,
          Colors.purple,
          isDarkMode,
          'Chiffre d\'affaires FCFA',
        ),
      ],
    );
  }

  Widget _buildMajorKPICard(String title, String value, IconData icon, Color color, bool isDarkMode, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }

  Widget _buildMainKPIs(bool isDarkMode, Map<String, dynamic> stats) {
    final kpis = [
      {
        'title': 'Nouveaux parrains',
        'value': stats['nouveauxParrains'] ?? 0,
        'icon': Icons.person_add,
        'color': Colors.blue,
        'subtitle': 'Total: ${stats['totalParrains'] ?? 0}',
      },
      {
        'title': 'Nouveaux affiliés',
        'value': stats['nouveauxAffiliés'] ?? 0,
        'icon': Icons.group_add,
        'color': Colors.green,
        'subtitle': 'Total: ${stats['totalAffiliés'] ?? 0}',
      },
      {
        'title': 'Chauffeurs recrutés',
        'value': stats['chauffeurs'] ?? 0,
        'icon': Icons.drive_eta,
        'color': Colors.orange,
        'subtitle': 'Via parrainage',
      },
      {
        'title': 'Propriétaires recrutés',
        'value': stats['proprietaires'] ?? 0,
        'icon': Icons.business,
        'color': Colors.purple,
        'subtitle': 'Via parrainage',
      },
      {
        'title': 'CA généré',
        'value': '${((stats['caGenere'] ?? 0) / 1000000).toStringAsFixed(1)}M',
        'icon': Icons.attach_money,
        'color': Colors.teal,
        'subtitle': 'FCFA',
      },
      {
        'title': 'Commissions payées',
        'value': '${((stats['commissionsPayees'] ?? 0) / 1000000).toStringAsFixed(1)}M',
        'icon': Icons.payments,
        'color': Colors.pink,
        'subtitle': 'FCFA',
      },
      {
        'title': 'Taux de conversion',
        'value': '${stats['tauxConversion'] ?? 0}%',
        'icon': Icons.trending_up,
        'color': Colors.indigo,
        'subtitle': 'Affiliés actifs',
      },
      {
        'title': 'Moy. affiliés/parrain',
        'value': ((stats['totalParrains'] ?? 0) > 0 ? ((stats['totalAffiliés'] ?? 0) / (stats['totalParrains'] ?? 1)).toStringAsFixed(1) : '0.0'),
        'icon': Icons.analytics,
        'color': Colors.amber,
        'subtitle': 'Performance',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        return _buildKPICard(kpi, isDarkMode, index);
      },
    );
  }

  Widget _buildKPICard(Map<String, dynamic> kpi, bool isDarkMode, int index) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (kpi['color'] as Color).withOpacity(0.3),
          width: 2,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (kpi['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  kpi['icon'] as IconData,
                  color: kpi['color'] as Color,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  kpi['value'].toString(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: kpi['color'] as Color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  kpi['title'],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  kpi['subtitle'],
                  style: TextStyle(
                    fontSize: 11,
                    color: isDarkMode ? Colors.white38 : Colors.black38,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (200 + index * 50).ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  Widget _buildEvolutionChart(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.show_chart, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Évolution du programme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 200,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDarkMode ? Colors.white10 : Colors.grey.shade200,
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
                            fontSize: 10,
                            color: isDarkMode ? Colors.white60 : Colors.black54,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < _evolutionData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _evolutionData[value.toInt()]['month'],
                              style: TextStyle(
                                fontSize: 10,
                                color: isDarkMode ? Colors.white60 : Colors.black54,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Ligne des parrains
                  LineChartBarData(
                    spots: _evolutionData.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(), 
                        (entry.value['parrains'] as num).toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.purple,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.purple.withOpacity(0.1),
                    ),
                  ),
                  // Ligne des affiliés
                  LineChartBarData(
                    spots: _evolutionData.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(), 
                        (entry.value['affilies'] as num).toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.purple, 'Parrains', isDarkMode),
              const SizedBox(width: 24),
              _buildLegendItem(Colors.green, 'Affiliés', isDarkMode),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildDistributionChart(bool isDarkMode, Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.pie_chart, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Répartition',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: [
                  PieChartSectionData(
                    value: (stats['chauffeurs'] ?? 0).toDouble(),
                    title: '${stats['chauffeurs'] ?? 0}',
                    color: Colors.orange,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: (stats['proprietaires'] ?? 0).toDouble(),
                    title: '${stats['proprietaires'] ?? 0}',
                    color: Colors.purple,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              _buildLegendItem(Colors.orange, 'Chauffeurs', isDarkMode),
              const SizedBox(height: 8),
              _buildLegendItem(Colors.purple, 'Propriétaires', isDarkMode),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 500.ms);
  }

  Widget _buildDetailedStats(bool isDarkMode, Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.analytics, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Statistiques détaillées du programme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard('Parrains actifs', '${stats['totalParrains'] ?? 0}', Icons.people, Colors.purple, isDarkMode),
              _buildStatCard('Affiliés totaux', '${stats['totalAffiliés'] ?? 0}', Icons.group, Colors.blue, isDarkMode),
              _buildStatCard('Nouveaux ce mois', '+${stats['nouveauxAffiliés'] ?? 0}', Icons.trending_up, Colors.green, isDarkMode),
              _buildStatCard('Chauffeurs recrutés', '${stats['chauffeurs'] ?? 0}', Icons.drive_eta, Colors.orange, isDarkMode),
              _buildStatCard('Propriétaires recrutés', '${stats['proprietaires'] ?? 0}', Icons.business, Colors.teal, isDarkMode),
              _buildStatCard('Taux conversion', '${stats['tauxConversion'] ?? 0}%', Icons.percent, Colors.pink, isDarkMode),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 300.ms);
  }

  Widget _buildPeriodStats(bool isDarkMode, Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.lightBlue],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.calendar_today, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Performance par période',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildPeriodStatCard(
                  'Croissance parrains',
                  '+${stats['nouveauxParrains'] ?? 0}',
                  'nouveaux parrains',
                  Colors.purple,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPeriodStatCard(
                  'Croissance affiliés',
                  '+${stats['nouveauxAffiliés'] ?? 0}',
                  'nouveaux affiliés',
                  Colors.blue,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPeriodStatCard(
                  'Moyenne par parrain',
                  '${((stats['totalParrains'] ?? 0) > 0 ? ((stats['totalAffiliés'] ?? 0) / (stats['totalParrains'] ?? 1)).toStringAsFixed(1) : '0.0')}',
                  'affiliés/parrain',
                  Colors.green,
                  isDarkMode,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 500.ms);
  }

  Widget _buildProgramPerformance(bool isDarkMode, Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.lightGreen],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.insights, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Impact financier du programme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildFinancialMetric(
                      'Chiffre d\'affaires généré',
                      '${((stats['caGenere'] ?? 0) / 1000000).toStringAsFixed(1)}M FCFA',
                      Icons.attach_money,
                      Colors.green,
                      isDarkMode,
                    ),
                    const SizedBox(height: 16),
                    _buildFinancialMetric(
                      'Commissions versées',
                      '${((stats['commissionsPayees'] ?? 0) / 1000000).toStringAsFixed(1)}M FCFA',
                      Icons.payments,
                      Colors.orange,
                      isDarkMode,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.withOpacity(0.1), Colors.blue.withOpacity(0.1)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.purple.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'ROI Programme',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${((stats['commissionsPayees'] ?? 0) > 0 ? (((stats['caGenere'] ?? 0) - (stats['commissionsPayees'] ?? 0)) / (stats['commissionsPayees'] ?? 1) * 100).toStringAsFixed(0) : '0')}%',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Retour sur investissement',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode ? Colors.white60 : Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 600.ms);
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodStatCard(String title, String value, String subtitle, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: isDarkMode ? Colors.white60 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialMetric(String title, String value, IconData icon, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text, bool isDarkMode) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
          text,
          style: TextStyle(
            fontSize: 13,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }
}
