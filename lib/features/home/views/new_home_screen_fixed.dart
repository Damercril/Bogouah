import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/new_app_theme.dart';
import '../../auth/controllers/auth_controller.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  
  // Données fictives pour les statistiques
  final List<Map<String, dynamic>> _statsData = [
    {'title': 'Tickets', 'value': 124, 'change': 12, 'isPositive': true, 'icon': Icons.confirmation_number_outlined},
    {'title': 'Opérateurs', 'value': 38, 'change': -3, 'isPositive': false, 'icon': Icons.people_outline},
    {'title': 'Taux de résolution', 'value': 87, 'change': 5, 'isPositive': true, 'icon': Icons.check_circle_outline, 'isPercentage': true},
    {'title': 'Temps moyen', 'value': 24, 'change': -8, 'isPositive': true, 'icon': Icons.timer_outlined, 'unit': 'min'},
  ];

  // Données fictives pour le graphique
  final List<FlSpot> _weeklyData = [
    const FlSpot(0, 5),
    const FlSpot(1, 8),
    const FlSpot(2, 7),
    const FlSpot(3, 10),
    const FlSpot(4, 12),
    const FlSpot(5, 9),
    const FlSpot(6, 14),
  ];

  // Données fictives pour les activités récentes
  final List<Map<String, dynamic>> _recentActivities = [
    {
      'title': 'Nouveau ticket créé',
      'description': 'Problème de connexion au réseau',
      'time': '10:30',
      'icon': Icons.add_circle_outline,
      'color': NewAppTheme.primaryColor,
    },
    {
      'title': 'Ticket résolu',
      'description': 'Mise à jour du système effectuée',
      'time': '09:15',
      'icon': Icons.check_circle_outline,
      'color': NewAppTheme.accentColor,
    },
    {
      'title': 'Nouvel opérateur',
      'description': 'Jean Dupont a rejoint l\'équipe',
      'time': 'Hier',
      'icon': Icons.person_add_alt_1_outlined,
      'color': NewAppTheme.secondaryColor,
    },
    {
      'title': 'Maintenance planifiée',
      'description': 'Serveur principal - 15/09/2025',
      'time': 'Hier',
      'icon': Icons.calendar_today_outlined,
      'color': Colors.amber,
    },
  ];


  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final user = authController.userModel;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        // En-tête avec profil et recherche
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour,',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    user?.displayName ?? 'Administrateur',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Navigation vers le profil
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: NewAppTheme.primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          (user?.displayName?.isNotEmpty == true)
                              ? user!.displayName![0].toUpperCase()
                              : 'A',
                          style: TextStyle(
                            color: NewAppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Contenu principal avec défilement
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // Statistiques en grille
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _statsData.length,
                    itemBuilder: (context, index) {
                      final stat = _statsData[index];
                      return _buildStatCard(stat, isDarkMode);
                    },
                  ).animate().fadeIn(duration: 600.ms, delay: 100.ms).slideY(begin: 0.2, end: 0),
                  
                  const SizedBox(height: 24),
                  
                  // Graphique d'activité
                  Text(
                    'Activité hebdomadaire',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 220,
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
                    child: _buildChart(isDarkMode),
                  ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                  
                  const SizedBox(height: 24),
                  
                  // Activités récentes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Activités récentes',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Voir tout',
                          style: TextStyle(
                            color: NewAppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _recentActivities.length,
                    itemBuilder: (context, index) {
                      final activity = _recentActivities[index];
                      return _buildActivityItem(activity, isDarkMode, index);
                    },
                  ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat, bool isDarkMode) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  stat['title'],
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? NewAppTheme.white.withOpacity(0.7) : NewAppTheme.darkGrey.withOpacity(0.7),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                stat['icon'],
                color: NewAppTheme.primaryColor,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            stat['isPercentage'] == true
                ? '${stat['value']}%'
                : stat['unit'] != null
                    ? '${stat['value']} ${stat['unit']}'
                    : stat['value'].toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(
                stat['isPositive'] ? Icons.arrow_upward : Icons.arrow_downward,
                color: stat['isPositive'] ? NewAppTheme.accentColor : NewAppTheme.errorColor,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '${stat['change']}%',
                style: TextStyle(
                  fontSize: 12,
                  color: stat['isPositive'] ? NewAppTheme.accentColor : NewAppTheme.errorColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart(bool isDarkMode) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 4,
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
              interval: 1,
              getTitlesWidget: (value, meta) {
                const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
                final index = value.toInt();
                if (index >= 0 && index < days.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      days[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode
                            ? NewAppTheme.white.withOpacity(0.7)
                            : NewAppTheme.darkGrey.withOpacity(0.7),
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
              interval: 4,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? NewAppTheme.white.withOpacity(0.7)
                          : NewAppTheme.darkGrey.withOpacity(0.7),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 16,
        lineBarsData: [
          LineChartBarData(
            spots: _weeklyData,
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                NewAppTheme.primaryColor.withOpacity(0.8),
                NewAppTheme.secondaryColor.withOpacity(0.8),
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  NewAppTheme.primaryColor.withOpacity(0.3),
                  NewAppTheme.secondaryColor.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity, bool isDarkMode, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity['color'].withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity['icon'],
              color: activity['color'],
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode
                        ? NewAppTheme.white.withOpacity(0.7)
                        : NewAppTheme.darkGrey.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity['time'],
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode
                  ? NewAppTheme.white.withOpacity(0.5)
                  : NewAppTheme.darkGrey.withOpacity(0.5),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 300.ms + (index * 100).ms).slideX(begin: 0.2, end: 0);
  }
}
