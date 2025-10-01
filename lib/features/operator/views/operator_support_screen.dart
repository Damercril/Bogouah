import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/new_app_theme.dart';
import '../../../core/utils/responsive_helper.dart';
import '../models/incidents_manager.dart';

/// Écran de support pour gérer les incidents et bugs signalés par les chauffeurs
class OperatorSupportScreen extends StatefulWidget {
  const OperatorSupportScreen({Key? key}) : super(key: key);

  @override
  State<OperatorSupportScreen> createState() => _OperatorSupportScreenState();
}

class _OperatorSupportScreenState extends State<OperatorSupportScreen> {
  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', 'En cours', 'Résolu', 'En attente'];
  final IncidentsManager _incidentsManager = IncidentsManager();

  // Liste des incidents/bugs (maintenant récupérée depuis le gestionnaire)
  List<Map<String, dynamic>> get _incidents => _incidentsManager.incidents;

  List<Map<String, dynamic>> get _filteredIncidents {
    if (_selectedFilter == 'Tous') return _incidents;
    return _incidents.where((incident) => incident['status'] == _selectedFilter).toList();
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Urgente':
        return Colors.red;
      case 'Haute':
        return Colors.orange;
      case 'Moyenne':
        return Colors.blue;
      case 'Basse':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'En cours':
        return Colors.blue;
      case 'Résolu':
        return Colors.green;
      case 'En attente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

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
              
              // En-tête
              _buildHeader(isDarkMode),
              
              const SizedBox(height: 24),
              
              // Filtres
              _buildFilters(isDarkMode),
              
              const SizedBox(height: 24),
              
              // Statistiques rapides
              _buildQuickStats(isDarkMode),
              
              const SizedBox(height: 24),
              
              // Liste des incidents
              _buildIncidentsList(isDarkMode),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showNewIncidentDialog(context, isDarkMode);
        },
        backgroundColor: NewAppTheme.primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Nouvel incident'),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red,
            Colors.deepOrange,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
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
              Icons.support_agent,
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
                  'Support Technique',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_incidents.length} incidents signalés • ${_incidents.where((i) => i['status'] == 'En cours').length} en cours',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildFilters(bool isDarkMode) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          final count = filter == 'Tous' 
              ? _incidents.length 
              : _incidents.where((i) => i['status'] == filter).length;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? NewAppTheme.primaryColor 
                      : (isDarkMode ? NewAppTheme.darkBlue : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(25),
                  border: isSelected ? null : Border.all(
                    color: NewAppTheme.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      filter,
                      style: TextStyle(
                        color: isSelected 
                            ? Colors.white 
                            : (isDarkMode ? Colors.white70 : Colors.black87),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Colors.white.withOpacity(0.3) 
                            : NewAppTheme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : NewAppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildQuickStats(bool isDarkMode) {
    final totalDriversAffected = _incidents.fold<int>(
      0, 
      (sum, incident) => sum + (incident['affectedDrivers'] as List).length,
    );
    final avgResponseTime = '15 min';
    final resolvedToday = _incidents.where((i) => 
      i['status'] == 'Résolu' && 
      i['resolvedAt'] != null &&
      (i['resolvedAt'] as DateTime).isAfter(DateTime.now().subtract(const Duration(hours: 24)))
    ).length;
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Chauffeurs affectés',
            '$totalDriversAffected',
            Icons.people,
            Colors.blue,
            isDarkMode,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Temps de réponse moy.',
            avgResponseTime,
            Icons.timer,
            Colors.orange,
            isDarkMode,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Résolus aujourd\'hui',
            '$resolvedToday',
            Icons.check_circle,
            Colors.green,
            isDarkMode,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
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
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white60 : Colors.black54,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  Widget _buildIncidentsList(bool isDarkMode) {
    final filteredIncidents = _filteredIncidents;
    
    if (filteredIncidents.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: isDarkMode ? NewAppTheme.darkBlue : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.inbox,
                size: 64,
                color: isDarkMode ? Colors.white30 : Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun incident dans cette catégorie',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredIncidents.length,
      itemBuilder: (context, index) {
        final incident = filteredIncidents[index];
        return _buildIncidentCard(incident, isDarkMode, index);
      },
    );
  }

  Widget _buildIncidentCard(Map<String, dynamic> incident, bool isDarkMode, int index) {
    final affectedDrivers = incident['affectedDrivers'] as List;
    final statusColor = _getStatusColor(incident['status']);
    final priorityColor = _getPriorityColor(incident['priority']);
    
    return InkWell(
      onTap: () {
        _showIncidentDetails(context, incident, isDarkMode);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: statusColor.withOpacity(0.3),
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
          children: [
            // En-tête
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: priorityColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.flag, size: 14, color: priorityColor),
                      const SizedBox(width: 4),
                      Text(
                        incident['priority'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: priorityColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    incident['status'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  incident['id'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Titre et description
            Text(
              incident['title'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              incident['description'],
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Informations
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.category, size: 16, color: isDarkMode ? Colors.white60 : Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      incident['category'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person, size: 16, color: isDarkMode ? Colors.white60 : Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      incident['assignedTo'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, size: 16, color: isDarkMode ? Colors.white60 : Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      _getTimeAgo(incident['createdAt']),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            
            // Chauffeurs affectés
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 18,
                  color: NewAppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  '${affectedDrivers.length} chauffeur${affectedDrivers.length > 1 ? 's' : ''} affecté${affectedDrivers.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: NewAppTheme.primaryColor,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddDriverToIncidentDialog(context, incident, isDarkMode, () {
                      setState(() {});
                    });
                  },
                  icon: const Icon(Icons.person_add, size: 16),
                  label: const Text('Ajouter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    _showAffectedDrivers(context, incident, isDarkMode);
                  },
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('Voir'),
                  style: TextButton.styleFrom(
                    foregroundColor: NewAppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            
            // Avatars des chauffeurs
            const SizedBox(height: 8),
            Row(
              children: [
                ...affectedDrivers.take(5).map((driver) => Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: NewAppTheme.primaryColor.withOpacity(0.2),
                    child: Text(
                      driver['avatar'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: NewAppTheme.primaryColor,
                      ),
                    ),
                  ),
                )),
                if (affectedDrivers.length > 5)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: NewAppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+${affectedDrivers.length - 5}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: NewAppTheme.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (300 + index * 50).ms).slideY(begin: 0.1, end: 0);
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else {
      return 'Il y a ${difference.inDays}j';
    }
  }

  void _showIncidentDetails(BuildContext context, Map<String, dynamic> incident, bool isDarkMode) {
    // Afficher les détails complets de l'incident
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(incident['title']),
        content: Text('Détails de l\'incident ${incident['id']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAffectedDrivers(BuildContext context, Map<String, dynamic> incident, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final affectedDrivers = incident['affectedDrivers'] as List;
          
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Barre de drag
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                // En-tête
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chauffeurs affectés (${affectedDrivers.length})',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  incident['id'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDarkMode ? Colors.white60 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Rappeler tous les chauffeurs
                            },
                            icon: const Icon(Icons.phone, size: 18),
                            label: const Text('Rappeler'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Bouton Ajouter un chauffeur
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showAddDriverToIncidentDialog(context, incident, isDarkMode, () {
                              setModalState(() {});
                              setState(() {});
                            });
                          },
                          icon: const Icon(Icons.person_add),
                          label: const Text('Ajouter un chauffeur concerné'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: NewAppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Divider(height: 1),
                
                // Liste des chauffeurs
                Expanded(
                  child: affectedDrivers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Aucun chauffeur concerné',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () {
                                  _showAddDriverToIncidentDialog(context, incident, isDarkMode, () {
                                    setModalState(() {});
                                    setState(() {});
                                  });
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Ajouter le premier chauffeur'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: affectedDrivers.length,
                          itemBuilder: (context, index) {
                            final driver = affectedDrivers[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: NewAppTheme.primaryColor.withOpacity(0.2),
                                    child: Text(
                                      driver['avatar'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: NewAppTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          driver['name'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          driver['phone'],
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isDarkMode ? Colors.white60 : Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Appelé ${_getTimeAgo(driver['calledAt'])}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isDarkMode ? Colors.white38 : Colors.black38,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Appeler le chauffeur
                                    },
                                    icon: const Icon(Icons.phone),
                                    color: Colors.green,
                                    tooltip: 'Appeler',
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Retirer via le gestionnaire
                                      _incidentsManager.removeDriverFromIncident(
                                        incident['id'],
                                        index,
                                      );
                                      setModalState(() {});
                                      setState(() {});
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${driver['name']} retiré de la liste'),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.remove_circle),
                                    color: Colors.red,
                                    tooltip: 'Retirer',
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddDriverToIncidentDialog(BuildContext context, Map<String, dynamic> incident, bool isDarkMode, VoidCallback onAdded) {
    final searchController = TextEditingController();
    String searchQuery = '';
    
    // Liste des clients (à récupérer depuis une source partagée)
    final List<Map<String, dynamic>> allClients = [
      {'name': 'Jean Dupont', 'avatar': 'JD', 'phone': '+221 77 123 45 67'},
      {'name': 'Marie Martin', 'avatar': 'MM', 'phone': '+221 77 234 56 78'},
      {'name': 'Pierre Durand', 'avatar': 'PD', 'phone': '+221 77 345 67 89'},
      {'name': 'Sophie Bernard', 'avatar': 'SB', 'phone': '+221 77 456 78 90'},
      {'name': 'Mamadou Diallo', 'avatar': 'MD', 'phone': '+221 77 567 89 01'},
      {'name': 'Fatou Sall', 'avatar': 'FS', 'phone': '+221 77 678 90 12'},
      {'name': 'Ousmane Ba', 'avatar': 'OB', 'phone': '+221 77 789 01 23'},
      {'name': 'Aissatou Cisse', 'avatar': 'AC', 'phone': '+221 77 890 12 34'},
    ];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final filteredClients = searchQuery.isEmpty
              ? allClients
              : allClients.where((client) =>
                  client['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
                  client['phone'].contains(searchQuery)
                ).toList();
          
          return AlertDialog(
            backgroundColor: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
            title: Row(
              children: [
                Icon(Icons.person_add, color: NewAppTheme.primaryColor),
                const SizedBox(width: 12),
                const Expanded(child: Text('Ajouter un chauffeur')),
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Incident: ${incident['id']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Barre de recherche
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setDialogState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Rechercher un chauffeur',
                      hintText: 'Nom ou téléphone...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setDialogState(() {
                                  searchController.clear();
                                  searchQuery = '';
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Liste des chauffeurs avec hauteur contrainte
                  SizedBox(
                    height: 400,
                    child: filteredClients.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_off,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Aucun chauffeur trouvé',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredClients.length,
                            itemBuilder: (context, index) {
                              final client = filteredClients[index];
                              return InkWell(
                                onTap: () {
                                  // Ajouter via le gestionnaire
                                  _incidentsManager.addDriverToIncident(
                                    incident['id'],
                                    {
                                      'name': client['name'],
                                      'phone': client['phone'],
                                      'avatar': client['avatar'],
                                      'calledAt': DateTime.now(),
                                    },
                                  );
                                  
                                  onAdded();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${client['name']} ajouté à l\'incident'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.white.withOpacity(0.05)
                                        : Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: NewAppTheme.primaryColor.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: NewAppTheme.primaryColor.withOpacity(0.2),
                                        child: Text(
                                          client['avatar'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: NewAppTheme.primaryColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              client['name'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              client['phone'],
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: isDarkMode
                                                    ? Colors.white60
                                                    : Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.add_circle,
                                        color: NewAppTheme.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showNewIncidentDialog(BuildContext context, bool isDarkMode) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'Technique';
    String selectedPriority = 'Moyenne';
    final List<Map<String, dynamic>> selectedDrivers = [];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
          title: Row(
            children: [
              Icon(Icons.bug_report, color: NewAppTheme.primaryColor),
              const SizedBox(width: 12),
              const Text('Créer un Ticket Support'),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Titre du problème *',
                      hintText: 'Ex: Bug de l\'application',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description *',
                      hintText: 'Décrivez le problème en détail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.description),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Catégorie et Priorité
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Catégorie',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.category),
                          ),
                          items: ['Technique', 'Paiement', 'GPS', 'Notifications', 'Autre']
                              .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                              .toList(),
                          onChanged: (value) {
                            setDialogState(() => selectedCategory = value!);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedPriority,
                          decoration: InputDecoration(
                            labelText: 'Priorité',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.priority_high),
                          ),
                          items: ['Basse', 'Moyenne', 'Haute', 'Urgente']
                              .map((pri) => DropdownMenuItem(value: pri, child: Text(pri)))
                              .toList(),
                          onChanged: (value) {
                            setDialogState(() => selectedPriority = value!);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Section Chauffeurs affectés
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chauffeurs concernés (${selectedDrivers.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          _showAddDriverDialog(context, isDarkMode, (driver) {
                            setDialogState(() {
                              selectedDrivers.add(driver);
                            });
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Liste des chauffeurs sélectionnés
                  if (selectedDrivers.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey[600]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Ajoutez les chauffeurs qui ont signalé ce problème',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: selectedDrivers.length,
                        itemBuilder: (context, index) {
                          final driver = selectedDrivers[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: NewAppTheme.primaryColor.withOpacity(0.2),
                                  child: Text(
                                    driver['avatar'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: NewAppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        driver['name'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        driver['phone'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDarkMode ? Colors.white60 : Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () {
                                    setDialogState(() {
                                      selectedDrivers.removeAt(index);
                                    });
                                  },
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
                  );
                  return;
                }
                
                // Créer le ticket
                setState(() {
                  _incidents.insert(0, {
                    'id': 'INC-${(_incidents.length + 1).toString().padLeft(3, '0')}',
                    'title': titleController.text,
                    'description': descriptionController.text,
                    'status': 'En cours',
                    'priority': selectedPriority,
                    'createdAt': DateTime.now(),
                    'affectedDrivers': selectedDrivers,
                    'assignedTo': 'Vous',
                    'category': selectedCategory,
                  });
                });
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ticket créé avec ${selectedDrivers.length} chauffeur(s) concerné(s)'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: NewAppTheme.primaryColor,
              ),
              icon: const Icon(Icons.check),
              label: const Text('Créer le ticket'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDriverDialog(BuildContext context, bool isDarkMode, Function(Map<String, dynamic>) onDriverAdded) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        title: const Text('Ajouter un chauffeur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nom du chauffeur',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Téléphone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty || phoneController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veuillez remplir tous les champs')),
                );
                return;
              }
              
              final nameParts = nameController.text.split(' ');
              final avatar = nameParts.length >= 2
                  ? '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase()
                  : nameController.text.substring(0, 2).toUpperCase();
              
              onDriverAdded({
                'name': nameController.text,
                'phone': phoneController.text,
                'avatar': avatar,
                'calledAt': DateTime.now(),
              });
              
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: NewAppTheme.primaryColor,
            ),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
