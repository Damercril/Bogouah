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
      'role': 'Opérateur Senior',
      'status': 'En ligne',
      'statusColor': Colors.green,
      'appelsEffectues': 156,
      'ticketsEnCours': 12,
      'ticketsResolus': 124,
      'tauxResolution': 91,
      'caGenere': 15800000,
      'satisfaction': 96,
      'lastActive': 'Maintenant',
    },
    {
      'id': '2',
      'name': 'Thomas Dubois',
      'avatar': 'TD',
      'role': 'Opérateur',
      'status': 'Occupé',
      'statusColor': Colors.orange,
      'appelsEffectues': 142,
      'ticketsEnCours': 10,
      'ticketsResolus': 115,
      'tauxResolution': 92,
      'caGenere': 13500000,
      'satisfaction': 94,
      'lastActive': '5 min',
    },
    {
      'id': '3',
      'name': 'Emma Bernard',
      'avatar': 'EB',
      'role': 'Opérateur Senior',
      'status': 'En ligne',
      'statusColor': Colors.green,
      'appelsEffectues': 138,
      'ticketsEnCours': 15,
      'ticketsResolus': 108,
      'tauxResolution': 88,
      'caGenere': 12200000,
      'satisfaction': 95,
      'lastActive': '2 min',
    },
    {
      'id': '4',
      'name': 'Lucas Petit',
      'avatar': 'LP',
      'role': 'Opérateur',
      'status': 'Hors ligne',
      'statusColor': Colors.grey,
      'appelsEffectues': 125,
      'ticketsEnCours': 18,
      'ticketsResolus': 98,
      'tauxResolution': 84,
      'caGenere': 10500000,
      'satisfaction': 90,
      'lastActive': '3h',
    },
    {
      'id': '5',
      'name': 'Léa Moreau',
      'avatar': 'LM',
      'role': 'Opérateur',
      'status': 'En ligne',
      'statusColor': Colors.green,
      'appelsEffectues': 118,
      'ticketsEnCours': 14,
      'ticketsResolus': 92,
      'tauxResolution': 87,
      'caGenere': 9800000,
      'satisfaction': 93,
      'lastActive': '1 min',
    },
    {
      'id': '6',
      'name': 'Antoine Moreau',
      'avatar': 'AM',
      'role': 'Opérateur Junior',
      'status': 'Hors ligne',
      'statusColor': Colors.grey,
      'appelsEffectues': 95,
      'ticketsEnCours': 8,
      'ticketsResolus': 78,
      'tauxResolution': 82,
      'caGenere': 8500000,
      'satisfaction': 85,
      'lastActive': '1j',
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
                  
                  // Statistiques en grille
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildMetricChip(
                        Icons.phone_in_talk,
                        '${operator['appelsEffectues']} appels',
                        Colors.blue,
                        isDarkMode,
                      ),
                      _buildMetricChip(
                        Icons.pending_actions,
                        '${operator['ticketsEnCours']} en cours',
                        Colors.orange,
                        isDarkMode,
                      ),
                      _buildMetricChip(
                        Icons.check_circle,
                        '${operator['ticketsResolus']} résolus',
                        Colors.green,
                        isDarkMode,
                      ),
                      _buildMetricChip(
                        Icons.trending_up,
                        '${operator['tauxResolution']}% résolution',
                        Colors.teal,
                        isDarkMode,
                      ),
                      _buildMetricChip(
                        Icons.attach_money,
                        '${(operator['caGenere'] / 1000000).toStringAsFixed(1)}M CA',
                        Colors.purple,
                        isDarkMode,
                      ),
                      _buildMetricChip(
                        Icons.sentiment_satisfied,
                        '${operator['satisfaction']}% satisf.',
                        Colors.pink,
                        isDarkMode,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Dernière activité
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: isDarkMode ? Colors.white38 : Colors.black38,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Dernière activité: ${operator['lastActive']}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (index * 100).ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildMetricChip(IconData icon, String label, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
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
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDarkMode
                ? NewAppTheme.white.withOpacity(0.6)
                : NewAppTheme.darkGrey.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
