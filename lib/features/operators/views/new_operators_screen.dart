import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/new_app_theme.dart';
import '../models/operator_stats.dart';
import 'operator_detail_screen.dart';

class NewOperatorsScreen extends StatefulWidget {
  const NewOperatorsScreen({Key? key}) : super(key: key);

  @override
  State<NewOperatorsScreen> createState() => _NewOperatorsScreenState();
}

class _NewOperatorsScreenState extends State<NewOperatorsScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', 'En ligne', 'Occupé', 'Hors ligne'];

  // Données fictives pour les opérateurs
  final List<Map<String, dynamic>> _operators = [
    {
      'id': '1',
      'name': 'Sophie Martin',
      'avatar': 'SM',
      'role': 'Support Niveau 2',
      'status': 'En ligne',
      'statusColor': Colors.green,
      'ticketsAssigned': 5,
      'ticketsResolved': 28,
      'avgResponseTime': '15 min',
      'avgResolutionTime': '1h 45m',
      'satisfaction': 96,
      'lastActive': 'Maintenant',
      'skills': ['Réseau', 'Windows', 'Office 365', 'VPN'],
    },
    {
      'id': '2',
      'name': 'Thomas Dubois',
      'avatar': 'TD',
      'role': 'Support Niveau 1',
      'status': 'Occupé',
      'statusColor': Colors.orange,
      'ticketsAssigned': 8,
      'ticketsResolved': 24,
      'avgResponseTime': '10 min',
      'avgResolutionTime': '2h 10m',
      'satisfaction': 92,
      'lastActive': '5 min',
      'skills': ['Hardware', 'Windows', 'Imprimantes'],
    },
    {
      'id': '3',
      'name': 'Emma Leroy',
      'avatar': 'EL',
      'role': 'Support Niveau 2',
      'status': 'En ligne',
      'statusColor': Colors.green,
      'ticketsAssigned': 3,
      'ticketsResolved': 22,
      'avgResponseTime': '8 min',
      'avgResolutionTime': '1h 55m',
      'satisfaction': 94,
      'lastActive': '2 min',
      'skills': ['Linux', 'Serveurs', 'Base de données', 'Cloud'],
    },
    {
      'id': '4',
      'name': 'Lucas Bernard',
      'avatar': 'LB',
      'role': 'Support Niveau 1',
      'status': 'Hors ligne',
      'statusColor': Colors.grey,
      'ticketsAssigned': 0,
      'ticketsResolved': 18,
      'avgResponseTime': '20 min',
      'avgResolutionTime': '2h 30m',
      'satisfaction': 88,
      'lastActive': '3h',
      'skills': ['Windows', 'Office 365', 'Téléphonie'],
    },
    {
      'id': '5',
      'name': 'Camille Petit',
      'avatar': 'CP',
      'role': 'Support Niveau 3',
      'status': 'En ligne',
      'statusColor': Colors.green,
      'ticketsAssigned': 2,
      'ticketsResolved': 32,
      'avgResponseTime': '12 min',
      'avgResolutionTime': '1h 30m',
      'satisfaction': 98,
      'lastActive': '1 min',
      'skills': ['Sécurité', 'Réseau', 'Cloud', 'Serveurs', 'Linux'],
    },
    {
      'id': '6',
      'name': 'Antoine Moreau',
      'avatar': 'AM',
      'role': 'Support Niveau 1',
      'status': 'Hors ligne',
      'statusColor': Colors.grey,
      'ticketsAssigned': 0,
      'ticketsResolved': 15,
      'avgResponseTime': '25 min',
      'avgResolutionTime': '2h 45m',
      'satisfaction': 85,
      'lastActive': '1j',
      'skills': ['Windows', 'Hardware', 'Imprimantes'],
    },
  ];

  List<Map<String, dynamic>> get _filteredOperators {
    return _operators.where((operator) {
      // Filtre par recherche
      final nameMatches = operator['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Filtre par statut
      final statusMatches = _selectedFilter == 'Tous' || operator['status'] == _selectedFilter;
      
      return nameMatches && statusMatches;
    }).toList();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        // En-tête avec titre et actions
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Opérateurs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Ajouter un nouvel opérateur
                },
              ),
            ],
          ),
        ),
        // Contenu principal
        Expanded(
          child: Column(
        children: [
          // Barre de recherche et filtres
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              children: [
                // Barre de recherche
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un opérateur...',
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      hintStyle: TextStyle(
                        color: isDarkMode
                            ? NewAppTheme.white.withOpacity(0.5)
                            : NewAppTheme.darkGrey.withOpacity(0.5),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                
                const SizedBox(height: 16),
                
                // Filtres
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = _selectedFilter == filter;
                      
                      return GestureDetector(
                        onTap: () => _onFilterChanged(filter),
                        child: Container(
                          margin: EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? NewAppTheme.primaryColor
                                : isDarkMode
                                    ? NewAppTheme.darkBlue
                                    : NewAppTheme.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? NewAppTheme.primaryColor
                                  : isDarkMode
                                      ? NewAppTheme.white.withOpacity(0.2)
                                      : NewAppTheme.darkGrey.withOpacity(0.2),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              filter,
                              style: TextStyle(
                                color: isSelected
                                    ? NewAppTheme.white
                                    : isDarkMode
                                        ? NewAppTheme.white
                                        : NewAppTheme.darkGrey,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms + (index * 50).ms);
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Liste des opérateurs
          Expanded(
            child: _filteredOperators.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: isDarkMode
                              ? NewAppTheme.white.withOpacity(0.5)
                              : NewAppTheme.darkGrey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun opérateur trouvé',
                          style: TextStyle(
                            fontSize: 18,
                            color: isDarkMode
                                ? NewAppTheme.white.withOpacity(0.7)
                                : NewAppTheme.darkGrey.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: _filteredOperators.length,
                    itemBuilder: (context, index) {
                      final operator = _filteredOperators[index];
                      return _buildOperatorCard(operator, isDarkMode, index);
                    },
                  ),
          ),
        ],
      ),
        ),
      ],
    );
  }

  Widget _buildOperatorCard(Map<String, dynamic> operator, bool isDarkMode, int index) {
    return GestureDetector(
      onTap: () {
        // Générer des statistiques fictives pour l'opérateur sélectionné
        final operatorStats = OperatorStats.generateMockDataForOperator(operator['id']);
        
        // Naviguer vers le détail de l'opérateur
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OperatorDetailScreen(
              operator: operator,
              operatorStats: operatorStats,
            ),
          ),
        );
      },
      child: Container(
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
          children: [
            // En-tête avec avatar et statut
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: NewAppTheme.primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        operator['avatar'],
                        style: TextStyle(
                          color: NewAppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Nom et rôle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          operator['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          operator['role'],
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
                  
                  // Statut
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: operator['statusColor'].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: operator['statusColor'],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          operator['status'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: operator['statusColor'],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Statistiques
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  // Ligne de séparation
                  Divider(
                    color: isDarkMode
                        ? NewAppTheme.white.withOpacity(0.1)
                        : NewAppTheme.darkGrey.withOpacity(0.1),
                  ),
                  const SizedBox(height: 8),
                  
                  // Statistiques en ligne
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(
                        'Tickets assignés',
                        operator['ticketsAssigned'].toString(),
                        Icons.assignment,
                        isDarkMode,
                      ),
                      _buildStatItem(
                        'Tickets résolus',
                        operator['ticketsResolved'].toString(),
                        Icons.check_circle_outline,
                        isDarkMode,
                      ),
                      _buildStatItem(
                        'Satisfaction',
                        '${operator['satisfaction']}%',
                        Icons.thumb_up_outlined,
                        isDarkMode,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Compétences
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (operator['skills'] as List<String>).map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: NewAppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(
                            fontSize: 12,
                            color: NewAppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Dernière activité
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: isDarkMode
                            ? NewAppTheme.white.withOpacity(0.5)
                            : NewAppTheme.darkGrey.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Actif ${operator['lastActive']}',
                        style: TextStyle(
                          fontSize: 12,
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
      ).animate().fadeIn(duration: 400.ms, delay: 300.ms + (index * 100).ms).slideY(begin: 0.2, end: 0),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, bool isDarkMode) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: NewAppTheme.primaryColor,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
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
}
