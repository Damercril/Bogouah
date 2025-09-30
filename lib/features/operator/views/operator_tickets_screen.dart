import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/new_app_theme.dart';
import '../../../core/utils/responsive_helper.dart';

/// Écran de gestion des tickets pour les opérateurs
class OperatorTicketsScreen extends StatefulWidget {
  const OperatorTicketsScreen({Key? key}) : super(key: key);

  @override
  State<OperatorTicketsScreen> createState() => _OperatorTicketsScreenState();
}

class _OperatorTicketsScreenState extends State<OperatorTicketsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Tous';

  final List<Map<String, dynamic>> _tickets = [
    {
      'id': '#TK-1234',
      'title': 'Problème de connexion',
      'description': 'Le client ne peut pas se connecter à son compte',
      'priority': 'Haute',
      'status': 'En cours',
      'customer': 'Jean Dupont',
      'time': '10 min',
      'category': 'Technique',
    },
    {
      'id': '#TK-1235',
      'title': 'Erreur de paiement',
      'description': 'Transaction échouée lors du paiement',
      'priority': 'Moyenne',
      'status': 'Nouveau',
      'customer': 'Marie Martin',
      'time': '25 min',
      'category': 'Facturation',
    },
    {
      'id': '#TK-1236',
      'title': 'Question sur le service',
      'description': 'Demande d\'informations sur les fonctionnalités',
      'priority': 'Basse',
      'status': 'En attente',
      'customer': 'Pierre Durand',
      'time': '1h',
      'category': 'Support',
    },
    {
      'id': '#TK-1237',
      'title': 'Bug dans l\'application',
      'description': 'L\'application se ferme de manière inattendue',
      'priority': 'Haute',
      'status': 'En cours',
      'customer': 'Sophie Bernard',
      'time': '2h',
      'category': 'Technique',
    },
    {
      'id': '#TK-1238',
      'title': 'Demande de remboursement',
      'description': 'Le client souhaite être remboursé',
      'priority': 'Moyenne',
      'status': 'Résolu',
      'customer': 'Luc Petit',
      'time': '3h',
      'category': 'Facturation',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
      body: Column(
        children: [
          _buildHeader(isDarkMode),
          _buildTabs(isDarkMode),
          _buildFilters(isDarkMode),
          Expanded(
            child: _buildTicketsList(isDarkMode),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: NewAppTheme.primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Nouveau ticket'),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getHorizontalPadding(context)),
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un ticket...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey[200],
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
            tooltip: 'Filtres',
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTabs(bool isDarkMode) {
    return Container(
      color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: NewAppTheme.primaryColor,
        unselectedLabelColor: isDarkMode ? Colors.white60 : Colors.black54,
        indicatorColor: NewAppTheme.primaryColor,
        tabs: const [
          Tab(text: 'Tous'),
          Tab(text: 'Nouveau'),
          Tab(text: 'En cours'),
          Tab(text: 'Résolu'),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildFilters(bool isDarkMode) {
    final filters = ['Tous', 'Haute', 'Moyenne', 'Basse'];
    
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getHorizontalPadding(context)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: NewAppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: NewAppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? NewAppTheme.primaryColor : (isDarkMode ? Colors.white70 : Colors.black87),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildTicketsList(bool isDarkMode) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildTicketsGrid(_tickets, isDarkMode),
        _buildTicketsGrid(_tickets.where((t) => t['status'] == 'Nouveau').toList(), isDarkMode),
        _buildTicketsGrid(_tickets.where((t) => t['status'] == 'En cours').toList(), isDarkMode),
        _buildTicketsGrid(_tickets.where((t) => t['status'] == 'Résolu').toList(), isDarkMode),
      ],
    );
  }

  Widget _buildTicketsGrid(List<Map<String, dynamic>> tickets, bool isDarkMode) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 80,
              color: isDarkMode ? Colors.white30 : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun ticket',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(ResponsiveHelper.getHorizontalPadding(context)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTablet(context) ? 2 : 1,
        childAspectRatio: ResponsiveHelper.isMobile(context) ? 2.5 : 1.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        return _buildTicketCard(tickets[index], isDarkMode, index);
      },
    );
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

    Color statusColor;
    switch (ticket['status']) {
      case 'Nouveau':
        statusColor = Colors.blue;
        break;
      case 'En cours':
        statusColor = Colors.orange;
        break;
      case 'Résolu':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return InkWell(
      onTap: () => _showTicketDetails(ticket, isDarkMode),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: priorityColor.withOpacity(0.3),
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
                Flexible(
                  child: Text(
                    ticket['id'],
                    style: TextStyle(
                      fontSize: 11,
                      color: isDarkMode ? Colors.white60 : Colors.black45,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        ticket['priority'],
                        style: TextStyle(
                          fontSize: 9,
                          color: priorityColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        ticket['status'],
                        style: TextStyle(
                          fontSize: 9,
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ticket['title'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              ticket['description'],
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white60 : Colors.black54,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person,
                        size: 14,
                        color: isDarkMode ? Colors.white60 : Colors.black45,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          ticket['customer'],
                          style: TextStyle(
                            fontSize: 11,
                            color: isDarkMode ? Colors.white60 : Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: isDarkMode ? Colors.white60 : Colors.black45,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ticket['time'],
                      style: TextStyle(
                        fontSize: 11,
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (index * 100).ms).slideY(begin: 0.2, end: 0);
  }

  void _showTicketDetails(Map<String, dynamic> ticket, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ticket['title']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${ticket['id']}'),
              const SizedBox(height: 8),
              Text('Client: ${ticket['customer']}'),
              const SizedBox(height: 8),
              Text('Priorité: ${ticket['priority']}'),
              const SizedBox(height: 8),
              Text('Statut: ${ticket['status']}'),
              const SizedBox(height: 16),
              Text(
                'Description:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(ticket['description']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Ouvrir le chat
            },
            child: const Text('Répondre'),
          ),
        ],
      ),
    );
  }
}
