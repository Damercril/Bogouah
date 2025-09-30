import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/new_app_theme.dart';
import '../../../core/utils/responsive_helper.dart';
import 'operator_crm_screen.dart';
import 'operator_stats_screen.dart';
import 'new_operator_tickets_screen.dart';
import '../../houbago/views/houbago_screen.dart';
import '../../profile/views/profile_screen.dart';

/// Écran principal pour les opérateurs avec navigation
class OperatorMainScreen extends StatefulWidget {
  const OperatorMainScreen({Key? key}) : super(key: key);

  @override
  State<OperatorMainScreen> createState() => _OperatorMainScreenState();
}

class _OperatorMainScreenState extends State<OperatorMainScreen> {
  int _currentIndex = 0;
  int _pendingTicketsCount = 3; // Nombre de tickets non traités

  final List<Widget> _screens = [
    const OperatorCRMScreen(),
    const OperatorStatsScreen(),
    const NewOperatorTicketsScreen(),
    const HoubagoScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Sur web, utiliser un layout avec sidebar
    if (ResponsiveHelper.isWeb(context)) {
      return _buildWebLayout(isDarkMode);
    }

    // Sur mobile, utiliser bottom navigation
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(isDarkMode),
    );
  }

  Widget _buildWebLayout(bool isDarkMode) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  height: 80,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
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
                          Icons.support_agent,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'OPÉRATEUR',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Menu items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _buildMenuItem(
                        icon: Icons.dashboard_customize_rounded,
                        label: 'Fiches CRM',
                        index: 0,
                        isDarkMode: isDarkMode,
                      ),
                      _buildMenuItem(
                        icon: Icons.bar_chart_rounded,
                        label: 'Mes Statistiques',
                        index: 1,
                        isDarkMode: isDarkMode,
                      ),
                      _buildMenuItem(
                        icon: Icons.confirmation_number_rounded,
                        label: 'Mes Tickets',
                        index: 2,
                        isDarkMode: isDarkMode,
                        badge: _pendingTicketsCount,
                      ),
                      _buildMenuItem(
                        icon: Icons.people_alt_rounded,
                        label: 'Houbago',
                        index: 3,
                        isDarkMode: isDarkMode,
                      ),
                      _buildMenuItem(
                        icon: Icons.person_rounded,
                        label: 'Profil',
                        index: 4,
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ),

                // Logout
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Déconnexion',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    context.go('/login');
                  },
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Column(
              children: [
                // Top bar
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getHorizontalPadding(context),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getPageTitle(_currentIndex),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            onPressed: () {
                              _showNotifications(context, isDarkMode);
                            },
                          ),
                          if (_pendingTicketsCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Center(
                                  child: Text(
                                    _pendingTicketsCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: NewAppTheme.primaryColor.withOpacity(0.2),
                        child: Icon(
                          Icons.support_agent,
                          color: NewAppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Screen content
                Expanded(
                  child: Container(
                    color: isDarkMode ? NewAppTheme.darkBackground : Colors.grey[50],
                    child: _screens[_currentIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isDarkMode,
    int? badge,
  }) {
    final isSelected = _currentIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? NewAppTheme.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Icon(
                      icon,
                      color: isSelected
                          ? NewAppTheme.primaryColor
                          : (isDarkMode ? Colors.white60 : Colors.black54),
                      size: 24,
                    ),
                    if (badge != null && badge > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Text(
                              badge.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected
                          ? NewAppTheme.primaryColor
                          : (isDarkMode ? Colors.white : Colors.black87),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildNotificationItem(
              icon: Icons.new_releases,
              title: 'Nouveau ticket',
              subtitle: 'Ticket #TK-1234 a été assigné',
              time: '5 min',
              color: Colors.blue,
              isDarkMode: isDarkMode,
            ),
            const Divider(),
            _buildNotificationItem(
              icon: Icons.warning,
              title: 'Ticket urgent',
              subtitle: 'Ticket #TK-1235 nécessite une attention',
              time: '15 min',
              color: Colors.red,
              isDarkMode: isDarkMode,
            ),
            const Divider(),
            _buildNotificationItem(
              icon: Icons.check_circle,
              title: 'Ticket résolu',
              subtitle: 'Ticket #TK-1230 a été marqué comme résolu',
              time: '1h',
              color: Colors.green,
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white60 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(bool isDarkMode) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      selectedItemColor: NewAppTheme.primaryColor,
      unselectedItemColor: isDarkMode ? Colors.white60 : Colors.black54,
      backgroundColor: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_customize_rounded),
          label: 'CRM',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_rounded),
          label: 'Stats',
        ),
        BottomNavigationBarItem(
          icon: _pendingTicketsCount > 0
              ? Badge(
                  label: Text(_pendingTicketsCount.toString()),
                  child: const Icon(Icons.confirmation_number_rounded),
                )
              : const Icon(Icons.confirmation_number_rounded),
          label: 'Tickets',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_rounded),
          label: 'Houbago',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profil',
        ),
      ],
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Fiches CRM';
      case 1:
        return 'Mes Statistiques';
      case 2:
        return 'Mes Tickets';
      case 3:
        return 'Houbago';
      case 4:
        return 'Profil';
      default:
        return 'Opérateur';
    }
  }
}
