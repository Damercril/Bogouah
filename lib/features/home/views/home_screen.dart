import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../controllers/home_controller.dart';
import '../models/stats_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/new_app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: Scaffold(
        body: Row(
          children: [
            // Navigation rail (sidebar)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
                
                // Navigation vers les autres écrans
                if (index == 1) {
                  // Navigation vers le dashboard
                  context.go('/dashboard');
                } else if (index == 2) {
                  // Navigation vers les opérateurs
                  context.go('/operators');
                }
              },
              labelType: NavigationRailLabelType.selected,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Accueil'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Tableau de bord'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: Text('Opérateurs'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.confirmation_number_outlined),
                  selectedIcon: Icon(Icons.confirmation_number),
                  label: Text('Tickets'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Paramètres'),
                ),
              ],
            ),
            
            // Main content
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const _HomeContent();
      case 1:
        return const Center(child: Text('Tableau de bord - À implémenter'));
      case 2:
        return const Center(child: Text('Opérateurs - À implémenter'));
      case 3:
        return const Center(child: Text('Tickets - À implémenter'));
      case 4:
        return const Center(child: Text('Paramètres - À implémenter'));
      default:
        return const _HomeContent();
    }
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        return Column(
          children: [
            // En-tête avec titre et actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bougouah Admin',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      // Période
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
                      
                      // Notifications
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            onPressed: () {
                              _showNotificationsDialog(context, controller);
                            },
                          ),
                          if (controller.unreadNotificationsCount > 0)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.error,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${controller.unreadNotificationsCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      
                      // Profil
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: NewAppTheme.primaryColor.withOpacity(0.2),
                        child: Icon(
                          Icons.person,
                          size: 18,
                          color: NewAppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
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
                // Titre de bienvenue
                Text(
                  'Bienvenue, Admin',
                  style: theme.textTheme.displaySmall,
                ).animate()
                  .fadeIn(duration: 500.ms)
                  .slideX(begin: -0.1, end: 0, duration: 500.ms),
                
                const SizedBox(height: 8),
                
                // Sous-titre
                Text(
                  'Voici un aperçu de votre activité pour ${controller.selectedPeriod.toLowerCase()}',
                  style: theme.textTheme.bodyLarge,
                ).animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms),
                
                const SizedBox(height: 24),
                
                // Cartes de statistiques
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: controller.stats.length,
                  itemBuilder: (context, index) {
                    return _buildStatCard(
                      context,
                      controller.stats[index],
                      index,
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Graphique et notifications
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Graphique d'activité
                    Expanded(
                      flex: 2,
                      child: _buildActivityChart(context, controller),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Notifications récentes
                    Expanded(
                      flex: 1,
                      child: _buildRecentNotifications(context, controller),
                    ),
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
  
  Widget _buildStatCard(BuildContext context, StatsModel stat, int index) {
    final theme = Theme.of(context);
    
    // Déterminer l'icône en fonction du type
    IconData iconData;
    switch (stat.iconType) {
      case IconType.operators:
        iconData = Icons.people;
        break;
      case IconType.tickets:
        iconData = Icons.confirmation_number;
        break;
      case IconType.activity:
        iconData = Icons.trending_up;
        break;
      case IconType.performance:
        iconData = Icons.speed;
        break;
      case IconType.revenue:
        iconData = Icons.attach_money;
        break;
      case IconType.customers:
        iconData = Icons.person;
        break;
    }
    
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
                  iconData,
                  color: theme.colorScheme.primary,
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
  
  Widget _buildActivityChart(BuildContext context, HomeController controller) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activité hebdomadaire',
              style: theme.textTheme.titleLarge,
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: theme.colorScheme.surface,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${controller.chartData[groupIndex].label}: ${rod.toY.round()}',
                          TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
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
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value >= controller.chartData.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              controller.chartData[value.toInt()].label,
                              style: theme.textTheme.bodySmall,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % 20 != 0) {
                            return const SizedBox();
                          }
                          return Text(
                            value.toInt().toString(),
                            style: theme.textTheme.bodySmall,
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: List.generate(
                    controller.chartData.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: controller.chartData[index].value,
                          color: theme.colorScheme.primary,
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
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
  
  Widget _buildRecentNotifications(BuildContext context, HomeController controller) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications récentes',
                  style: theme.textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    controller.markAllNotificationsAsRead();
                  },
                  child: const Text('Tout marquer comme lu'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                
                // Déterminer la couleur en fonction du type
                Color color;
                IconData iconData;
                switch (notification.type) {
                  case NotificationType.info:
                    color = theme.colorScheme.primary;
                    iconData = Icons.info_outline;
                    break;
                  case NotificationType.warning:
                    color = theme.colorScheme.tertiary;
                    iconData = Icons.warning_amber_outlined;
                    break;
                  case NotificationType.success:
                    color = Colors.green;
                    iconData = Icons.check_circle_outline;
                    break;
                  case NotificationType.error:
                    color = theme.colorScheme.error;
                    iconData = Icons.error_outline;
                    break;
                }
                
                return ListTile(
                  leading: Icon(
                    iconData,
                    color: color,
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.message),
                      const SizedBox(height: 4),
                      Text(
                        _formatNotificationTime(notification.time),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    controller.markNotificationAsRead(index);
                  },
                );
              },
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: 800.ms, duration: 800.ms)
      .slideY(begin: 0.2, end: 0, delay: 800.ms, duration: 800.ms);
  }
  
  String _formatNotificationTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inSeconds < 60) {
      return 'Il y a quelques secondes';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else {
      return DateFormat('dd/MM/yyyy').format(time);
    }
  }
  
  void _showNotificationsDialog(BuildContext context, HomeController controller) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Notifications'),
            TextButton(
              onPressed: () {
                controller.markAllNotificationsAsRead();
                Navigator.pop(context);
              },
              child: const Text('Tout marquer comme lu'),
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          height: 400,
          child: ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              
              // Déterminer la couleur en fonction du type
              Color color;
              IconData iconData;
              switch (notification.type) {
                case NotificationType.info:
                  color = theme.colorScheme.primary;
                  iconData = Icons.info_outline;
                  break;
                case NotificationType.warning:
                  color = theme.colorScheme.tertiary;
                  iconData = Icons.warning_amber_outlined;
                  break;
                case NotificationType.success:
                  color = Colors.green;
                  iconData = Icons.check_circle_outline;
                  break;
                case NotificationType.error:
                  color = theme.colorScheme.error;
                  iconData = Icons.error_outline;
                  break;
              }
              
              return ListTile(
                leading: Icon(
                  iconData,
                  color: color,
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.message),
                    const SizedBox(height: 4),
                    Text(
                      _formatNotificationTime(notification.time),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                isThreeLine: true,
                onTap: () {
                  controller.markNotificationAsRead(index);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
