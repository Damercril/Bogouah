import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../../core/theme/new_app_theme.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../auth/controllers/auth_controller.dart';

/// Écran d'accueil pour les opérateurs
class OperatorHomeScreen extends StatefulWidget {
  const OperatorHomeScreen({Key? key}) : super(key: key);

  @override
  State<OperatorHomeScreen> createState() => _OperatorHomeScreenState();
}

class _OperatorHomeScreenState extends State<OperatorHomeScreen> {
  int _selectedPeriodIndex = 1; // 0: Jour, 1: Semaine, 2: Mois, 3: Année
  
  // Données fictives pour les statistiques de l'opérateur selon la période
  Map<int, List<Map<String, dynamic>>> _statsDataByPeriod = {
    0: [ // Jour
      {'title': 'Appels effectués', 'value': 24, 'icon': Icons.phone_in_talk, 'color': Colors.blue, 'trend': '+12%'},
      {'title': 'Tickets en cours', 'value': 5, 'icon': Icons.pending_actions, 'color': Colors.orange, 'trend': '+2'},
      {'title': 'Tickets résolus', 'value': 18, 'icon': Icons.check_circle, 'color': Colors.green, 'trend': '+8%'},
      {'title': 'Durée moy. appel', 'value': 8, 'unit': 'min', 'icon': Icons.timer, 'color': Colors.purple, 'trend': '-2min'},
      {'title': 'Taux résolution', 'value': 85, 'unit': '%', 'icon': Icons.trending_up, 'color': Colors.teal, 'trend': '+3%'},
      {'title': 'Clients contactés', 'value': 22, 'icon': Icons.people, 'color': Colors.indigo, 'trend': '+10%'},
    ],
    1: [ // Semaine
      {'title': 'Appels effectués', 'value': 156, 'icon': Icons.phone_in_talk, 'color': Colors.blue, 'trend': '+18%'},
      {'title': 'Tickets en cours', 'value': 12, 'icon': Icons.pending_actions, 'color': Colors.orange, 'trend': '+4'},
      {'title': 'Tickets résolus', 'value': 124, 'icon': Icons.check_circle, 'color': Colors.green, 'trend': '+12%'},
      {'title': 'Durée moy. appel', 'value': 9, 'unit': 'min', 'icon': Icons.timer, 'color': Colors.purple, 'trend': '-1min'},
      {'title': 'Taux résolution', 'value': 82, 'unit': '%', 'icon': Icons.trending_up, 'color': Colors.teal, 'trend': '+5%'},
      {'title': 'Clients contactés', 'value': 145, 'icon': Icons.people, 'color': Colors.indigo, 'trend': '+15%'},
    ],
    2: [ // Mois
      {'title': 'Appels effectués', 'value': 680, 'icon': Icons.phone_in_talk, 'color': Colors.blue, 'trend': '+25%'},
      {'title': 'Tickets en cours', 'value': 28, 'icon': Icons.pending_actions, 'color': Colors.orange, 'trend': '+8'},
      {'title': 'Tickets résolus', 'value': 542, 'icon': Icons.check_circle, 'color': Colors.green, 'trend': '+18%'},
      {'title': 'Durée moy. appel', 'value': 10, 'unit': 'min', 'icon': Icons.timer, 'color': Colors.purple, 'trend': '+1min'},
      {'title': 'Taux résolution', 'value': 79, 'unit': '%', 'icon': Icons.trending_up, 'color': Colors.teal, 'trend': '+7%'},
      {'title': 'Clients contactés', 'value': 628, 'icon': Icons.people, 'color': Colors.indigo, 'trend': '+22%'},
    ],
    3: [ // Année
      {'title': 'Appels effectués', 'value': 8240, 'icon': Icons.phone_in_talk, 'color': Colors.blue, 'trend': '+32%'},
      {'title': 'Tickets en cours', 'value': 42, 'icon': Icons.pending_actions, 'color': Colors.orange, 'trend': '+12'},
      {'title': 'Tickets résolus', 'value': 6580, 'icon': Icons.check_circle, 'color': Colors.green, 'trend': '+28%'},
      {'title': 'Durée moy. appel', 'value': 11, 'unit': 'min', 'icon': Icons.timer, 'color': Colors.purple, 'trend': '+2min'},
      {'title': 'Taux résolution', 'value': 80, 'unit': '%', 'icon': Icons.trending_up, 'color': Colors.teal, 'trend': '+10%'},
      {'title': 'Clients contactés', 'value': 7520, 'icon': Icons.people, 'color': Colors.indigo, 'trend': '+30%'},
    ],
  };
  
  List<Map<String, dynamic>> get _statsData => _statsDataByPeriod[_selectedPeriodIndex]!;

  // Tickets en attente
  final List<Map<String, dynamic>> _pendingTickets = [
    {
      'id': '#TK-1234',
      'title': 'Problème de connexion',
      'priority': 'Haute',
      'time': '10 min',
      'customer': 'Jean Dupont',
    },
    {
      'id': '#TK-1235',
      'title': 'Erreur de paiement',
      'priority': 'Moyenne',
      'time': '25 min',
      'customer': 'Marie Martin',
    },
    {
      'id': '#TK-1236',
      'title': 'Question sur le service',
      'priority': 'Basse',
      'time': '1h',
      'customer': 'Pierre Durand',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final user = authController.userModel;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.getHorizontalPadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              
              // En-tête avec salutation
              _buildHeader(user, isDarkMode),
              
              const SizedBox(height: 24),
              
              // Filtres de période
              _buildPeriodFilters(isDarkMode),
              
              const SizedBox(height: 24),
              
              // Statistiques
              _buildStats(isDarkMode),
              
              const SizedBox(height: 32),
              
              // Performance par rapport à la moyenne
              _buildPerformanceComparison(isDarkMode),
              
              const SizedBox(height: 32),
              
              // Tickets en attente
              _buildPendingTickets(isDarkMode),
              
              const SizedBox(height: 32),
              
              // Actions rapides
              _buildQuickActions(isDarkMode),
              
              const SizedBox(height: 32),
              
              // Opérateurs les plus performants
              _buildTopPerformers(isDarkMode),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceComparison(bool isDarkMode) {
    // Données de l'opérateur connecté vs moyenne de l'équipe
    final operatorStats = {
      'appels': {'value': 156, 'average': 130, 'label': 'Appels effectués'},
      'resolution': {'value': 82, 'average': 75, 'label': 'Taux résolution'},
      'conversion': {'value': 68, 'average': 55, 'label': 'Taux conversion'},
      'dureeAppel': {'value': 9, 'average': 12, 'label': 'Durée moy. appel', 'inverse': true}, // Plus bas = mieux
      'ticketsResolus': {'value': 124, 'average': 95, 'label': 'Tickets résolus'},
      'satisfaction': {'value': 92, 'average': 85, 'label': 'Satisfaction client'},
    };

    // Calculer les points forts (au-dessus de la moyenne)
    List<Map<String, dynamic>> strengths = [];
    operatorStats.forEach((key, data) {
      final value = data['value'] as num;
      final average = data['average'] as num;
      final inverse = data['inverse'] as bool? ?? false;
      
      final isStrength = inverse ? value < average : value > average;
      final difference = inverse ? average - value : value - average;
      final percentDiff = ((difference / average) * 100).abs().toInt();
      
      if (isStrength) {
        strengths.add({
          'label': data['label'],
          'value': value,
          'average': average,
          'percentDiff': percentDiff,
          'icon': _getIconForMetric(key),
          'color': _getColorForMetric(key),
        });
      }
    });

    // Trier par différence en pourcentage (du plus fort au plus faible)
    strengths.sort((a, b) => (b['percentDiff'] as int).compareTo(a['percentDiff'] as int));

    // Prendre les 3 meilleurs
    final topStrengths = strengths.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            NewAppTheme.primaryColor.withOpacity(0.1),
            NewAppTheme.secondaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NewAppTheme.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      NewAppTheme.primaryColor,
                      NewAppTheme.secondaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vos points forts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Comparaison avec la moyenne de l\'équipe',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          if (topStrengths.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Continuez vos efforts pour dépasser la moyenne !',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: topStrengths.map((strength) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: (strength['color'] as Color).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (strength['color'] as Color).withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        strength['icon'] as IconData,
                        color: strength['color'] as Color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            strength['label'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                '${strength['value']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: strength['color'] as Color,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_upward, size: 10, color: Colors.green),
                                    const SizedBox(width: 2),
                                    Text(
                                      '+${strength['percentDiff']}%',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Moy: ${strength['average']}',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDarkMode ? Colors.white38 : Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2, end: 0);
  }

  IconData _getIconForMetric(String metric) {
    switch (metric) {
      case 'appels':
        return Icons.phone_in_talk;
      case 'resolution':
        return Icons.check_circle;
      case 'conversion':
        return Icons.trending_up;
      case 'dureeAppel':
        return Icons.timer;
      case 'ticketsResolus':
        return Icons.task_alt;
      case 'satisfaction':
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.star;
    }
  }

  Color _getColorForMetric(String metric) {
    switch (metric) {
      case 'appels':
        return Colors.blue;
      case 'resolution':
        return Colors.green;
      case 'conversion':
        return Colors.teal;
      case 'dureeAppel':
        return Colors.purple;
      case 'ticketsResolus':
        return Colors.orange;
      case 'satisfaction':
        return Colors.pink;
      default:
        return NewAppTheme.primaryColor;
    }
  }

  Widget _buildTopPerformers(bool isDarkMode) {
    final topPerformers = [
      {
        'name': 'Sophie Martin',
        'avatar': 'SM',
        'tickets': 45,
        'satisfaction': 98,
        'responseTime': '12 min',
        'badge': '🏆',
      },
      {
        'name': 'Thomas Dubois',
        'avatar': 'TD',
        'tickets': 42,
        'satisfaction': 96,
        'responseTime': '15 min',
        'badge': '🥈',
      },
      {
        'name': 'Emma Bernard',
        'avatar': 'EB',
        'tickets': 38,
        'satisfaction': 95,
        'responseTime': '18 min',
        'badge': '🥉',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Opérateurs les plus performants',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Voir tout',
                style: TextStyle(
                  color: NewAppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topPerformers.length,
          itemBuilder: (context, index) {
            final performer = topPerformers[index];
            return _buildPerformerCard(performer, isDarkMode, index);
          },
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildPerformerCard(Map<String, dynamic> performer, bool isDarkMode, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: index == 0 ? Border.all(
          color: Colors.amber,
          width: 2,
        ) : null,
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
          // Badge et position
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: index == 0
                    ? [Colors.amber, Colors.orange]
                    : index == 1
                        ? [Colors.grey[400]!, Colors.grey[600]!]
                        : [Colors.brown[300]!, Colors.brown[500]!],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                performer['badge'],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Avatar et nom
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: NewAppTheme.primaryColor.withOpacity(0.2),
                      child: Text(
                        performer['avatar'],
                        style: TextStyle(
                          color: NewAppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            performer['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.confirmation_number,
                                size: 14,
                                color: isDarkMode ? Colors.white60 : Colors.black54,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${performer['tickets']} tickets',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode ? Colors.white60 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildPerformerStat(
                        Icons.thumb_up,
                        '${performer['satisfaction']}%',
                        'Satisfaction',
                        Colors.green,
                        isDarkMode,
                      ),
                    ),
                    Expanded(
                      child: _buildPerformerStat(
                        Icons.timer,
                        performer['responseTime'],
                        'Réponse moy.',
                        Colors.blue,
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
    ).animate().fadeIn(duration: 400.ms, delay: (400 + index * 100).ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildPerformerStat(IconData icon, String value, String label, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic user, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            NewAppTheme.primaryColor,
            NewAppTheme.secondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: Icon(
              Icons.support_agent,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour, ${user?.displayName ?? 'Opérateur'}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vous avez 12 tickets à traiter aujourd\'hui',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildPeriodFilters(bool isDarkMode) {
    final periods = ['Jour', 'Semaine', 'Mois', 'Année'];
    
    return Container(
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
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildStats(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vos statistiques',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            // Ajustement dynamique du nombre de colonnes en fonction de la largeur disponible
            final screenWidth = constraints.maxWidth;
            int crossAxisCount;
            
            if (ResponsiveHelper.isDesktop(context)) {
              crossAxisCount = screenWidth > 1200 ? 6 : screenWidth > 900 ? 4 : 3;
            } else if (ResponsiveHelper.isTablet(context)) {
              crossAxisCount = screenWidth > 650 ? 3 : 2;
            } else {
              crossAxisCount = 2;
            }
            
            // Calcul de la largeur des cartes avec un minimum pour éviter qu'elles soient trop petites
            final cardWidth = max((constraints.maxWidth - (6 * (crossAxisCount - 1))) / crossAxisCount, 80.0);
            final cardHeight = 75.0; // Hauteur réduite pour éviter l'overflow
            
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: cardWidth / cardHeight,
                crossAxisSpacing: 6,
                mainAxisSpacing: 8,
              ),
              itemCount: _statsData.length,
              itemBuilder: (context, index) {
                final stat = _statsData[index];
                return _buildStatCard(stat, isDarkMode);
              },
            );
          },
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 100.ms);
  }

  Widget _buildStatCard(Map<String, dynamic> stat, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: stat['color'].withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: stat['color'].withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Utiliser un FittedBox avec un alignement pour garantir que le contenu s'adapte
            return FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Container(
                width: constraints.maxWidth,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      stat['icon'],
                      size: 12,
                      color: stat['color'],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stat['unit'] != null ? '${stat['value']} ${stat['unit']}' : stat['value'].toString(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      stat['title'],
                      style: TextStyle(
                        fontSize: 7,
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPendingTickets(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tickets en attente',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Voir tout',
                style: TextStyle(
                  color: NewAppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _pendingTickets.length,
          itemBuilder: (context, index) {
            final ticket = _pendingTickets[index];
            return _buildTicketCard(ticket, isDarkMode, index);
          },
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket, bool isDarkMode, int index) {
    Color priorityColor;
    switch (ticket['priority']) {
      case 'Haute':
        priorityColor = Colors.red;
        break;
      case 'Moyenne':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      ticket['id'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white60 : Colors.black45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        ticket['priority'],
                        style: TextStyle(
                          fontSize: 10,
                          color: priorityColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  ticket['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Client: ${ticket['customer']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: isDarkMode ? Colors.white60 : Colors.black45,
              ),
              const SizedBox(height: 4),
              Text(
                ticket['time'],
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.white60 : Colors.black45,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: NewAppTheme.primaryColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (300 + index * 100).ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildQuickActions(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions rapides',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              icon: Icons.add_circle,
              title: 'Nouveau ticket',
              color: Colors.blue,
              isDarkMode: isDarkMode,
            ),
            _buildActionCard(
              icon: Icons.history,
              title: 'Historique',
              color: Colors.purple,
              isDarkMode: isDarkMode,
            ),
            _buildActionCard(
              icon: Icons.chat,
              title: 'Messages',
              color: Colors.green,
              isDarkMode: isDarkMode,
            ),
            _buildActionCard(
              icon: Icons.help,
              title: 'Aide',
              color: Colors.orange,
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 300.ms);
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
