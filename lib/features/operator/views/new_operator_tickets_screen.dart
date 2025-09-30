import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/new_app_theme.dart';
import '../../../core/utils/responsive_helper.dart';

/// Nouvelle interface moderne de gestion des tickets pour les opérateurs
class NewOperatorTicketsScreen extends StatefulWidget {
  const NewOperatorTicketsScreen({Key? key}) : super(key: key);

  @override
  State<NewOperatorTicketsScreen> createState() => _NewOperatorTicketsScreenState();
}

class _NewOperatorTicketsScreenState extends State<NewOperatorTicketsScreen> {
  String _selectedStatus = 'Tous';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _tickets = [
    {
      'id': '#TK-1234',
      'title': 'Problème de connexion',
      'description': 'Le client ne peut pas se connecter à son compte',
      'priority': 'Haute',
      'status': 'En cours',
      'customer': 'Jean Dupont',
      'phone': '+33 6 12 34 56 78',
      'time': '10 min',
      'category': 'Technique',
      'avatar': 'JD',
      'assignedTo': 'Sophie Martin',
      'assignedAvatar': 'SM',
      'startTime': DateTime.now().subtract(const Duration(minutes: 10)),
    },
    {
      'id': '#TK-1235',
      'title': 'Erreur de paiement',
      'description': 'Transaction échouée lors du paiement',
      'priority': 'Haute',
      'status': 'Nouveau',
      'customer': 'Marie Martin',
      'phone': '+33 6 23 45 67 89',
      'time': '25 min',
      'category': 'Facturation',
      'avatar': 'MM',
      'assignedTo': null,
      'assignedAvatar': null,
      'startTime': null,
    },
    {
      'id': '#TK-1236',
      'title': 'Question sur le service',
      'description': 'Demande d\'informations sur les fonctionnalités',
      'priority': 'Moyenne',
      'status': 'En attente',
      'customer': 'Pierre Durand',
      'phone': '+33 6 34 56 78 90',
      'time': '1h',
      'category': 'Support',
      'avatar': 'PD',
      'assignedTo': 'Thomas Dubois',
      'assignedAvatar': 'TD',
      'startTime': null,
    },
    {
      'id': '#TK-1237',
      'title': 'Bug dans l\'application',
      'description': 'L\'application se ferme de manière inattendue',
      'priority': 'Haute',
      'status': 'En cours',
      'customer': 'Sophie Bernard',
      'phone': '+33 6 45 67 89 01',
      'time': '2h',
      'category': 'Technique',
      'avatar': 'SB',
      'assignedTo': 'Sophie Martin',
      'assignedAvatar': 'SM',
      'startTime': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '#TK-1238',
      'title': 'Demande de remboursement',
      'description': 'Le client souhaite être remboursé',
      'priority': 'Basse',
      'status': 'Résolu',
      'customer': 'Luc Petit',
      'phone': '+33 6 56 78 90 12',
      'time': '3h',
      'category': 'Facturation',
      'avatar': 'LP',
      'assignedTo': 'Emma Bernard',
      'assignedAvatar': 'EB',
      'startTime': null,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredTickets {
    return _tickets.where((ticket) {
      final matchesStatus = _selectedStatus == 'Tous' || ticket['status'] == _selectedStatus;
      final matchesSearch = _searchQuery.isEmpty ||
          ticket['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ticket['id'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ticket['customer'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  String _getElapsedTime(DateTime? startTime) {
    if (startTime == null) return '0min';
    final elapsed = DateTime.now().difference(startTime);
    if (elapsed.inHours > 0) {
      return '${elapsed.inHours}h ${elapsed.inMinutes % 60}min';
    }
    return '${elapsed.inMinutes}min';
  }

  void _startTicket(Map<String, dynamic> ticket) {
    setState(() {
      ticket['status'] = 'En cours';
      ticket['startTime'] = DateTime.now();
      ticket['assignedTo'] = 'Vous';
      ticket['assignedAvatar'] = 'VO';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket ${ticket['id']} en cours de traitement'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _resolveTicket(Map<String, dynamic> ticket) {
    setState(() {
      ticket['status'] = 'Résolu';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket ${ticket['id']} résolu avec succès'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _closeTicket(Map<String, dynamic> ticket) {
    setState(() {
      ticket['status'] = 'Fermé';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket ${ticket['id']} fermé'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showCreateTicketDialog(BuildContext context, bool isDarkMode) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final customerController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedPriority = 'Moyenne';
    String selectedCategory = 'Support';
    String? selectedAssignee;

    final operators = [
      'Sophie Martin',
      'Thomas Dubois',
      'Emma Bernard',
      'Lucas Petit',
      'Marie Durand',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: NewAppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.add_circle,
                  color: NewAppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Créer un nouveau ticket'),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Client
                  TextField(
                    controller: customerController,
                    decoration: InputDecoration(
                      labelText: 'Nom du client',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Téléphone
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Téléphone',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Titre
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Titre du ticket',
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Priorité
                  DropdownButtonFormField<String>(
                    value: selectedPriority,
                    decoration: InputDecoration(
                      labelText: 'Priorité',
                      prefixIcon: const Icon(Icons.flag),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ['Haute', 'Moyenne', 'Basse'].map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedPriority = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Catégorie
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Catégorie',
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ['Technique', 'Facturation', 'Support'].map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Assigner à
                  DropdownButtonFormField<String>(
                    value: selectedAssignee,
                    decoration: InputDecoration(
                      labelText: 'Assigner à (optionnel)',
                      prefixIcon: const Icon(Icons.person_add),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Non assigné'),
                      ),
                      ...operators.map((operator) {
                        return DropdownMenuItem(
                          value: operator,
                          child: Text(operator),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        selectedAssignee = value;
                      });
                    },
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
                if (titleController.text.isEmpty || 
                    customerController.text.isEmpty ||
                    phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez remplir tous les champs obligatoires'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                // Créer le nouveau ticket
                final newTicket = {
                  'id': '#TK-${1239 + _tickets.length}',
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'priority': selectedPriority,
                  'status': 'Nouveau',
                  'customer': customerController.text,
                  'phone': phoneController.text,
                  'time': 'À l\'instant',
                  'category': selectedCategory,
                  'avatar': customerController.text.split(' ').map((e) => e[0]).join().toUpperCase(),
                  'assignedTo': selectedAssignee,
                  'assignedAvatar': selectedAssignee?.split(' ').map((e) => e[0]).join().toUpperCase(),
                  'startTime': null,
                };
                
                setState(() {
                  _tickets.insert(0, newTicket);
                });
                
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ticket ${newTicket['id']} créé avec succès'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.check),
              label: const Text('Créer le ticket'),
              style: ElevatedButton.styleFrom(
                backgroundColor: NewAppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getHorizontalPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            
            // En-tête avec statistiques
            _buildStatsHeader(isDarkMode),
            
            const SizedBox(height: 24),
            
            // Barre de recherche
            _buildSearchBar(isDarkMode),
            
            const SizedBox(height: 16),
            
            // Filtres de statut
            _buildStatusFilters(isDarkMode),
            
            const SizedBox(height: 16),
            
            // Liste des tickets
            Expanded(
              child: _buildTicketsList(isDarkMode),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTicketDialog(context, isDarkMode),
        backgroundColor: NewAppTheme.primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Créer un ticket'),
      ),
    );
  }

  Widget _buildStatsHeader(bool isDarkMode) {
    final stats = [
      {'label': 'Nouveau', 'count': 1, 'color': Colors.blue, 'icon': Icons.fiber_new},
      {'label': 'En cours', 'count': 2, 'color': Colors.orange, 'icon': Icons.pending_actions},
      {'label': 'En attente', 'count': 1, 'color': Colors.amber, 'icon': Icons.schedule},
      {'label': 'Résolu', 'count': 1, 'color': Colors.green, 'icon': Icons.check_circle},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            NewAppTheme.primaryColor,
            NewAppTheme.secondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: NewAppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.confirmation_number,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mes Tickets',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Gérez vos tickets efficacement',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white30, height: 1),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: stats.map((stat) => _buildStatItem(
              stat['label'] as String,
              stat['count'] as int,
              stat['color'] as Color,
              stat['icon'] as IconData,
            )).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildStatItem(String label, int count, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Container(
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
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: '🔍 Rechercher un ticket, client...',
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.white38 : Colors.black38,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildStatusFilters(bool isDarkMode) {
    final statuses = ['Tous', 'Nouveau', 'En cours', 'En attente', 'Résolu'];
    
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = _selectedStatus == status;
          
          Color getColor() {
            switch (status) {
              case 'Nouveau':
                return Colors.blue;
              case 'En cours':
                return Colors.orange;
              case 'En attente':
                return Colors.amber;
              case 'Résolu':
                return Colors.green;
              default:
                return NewAppTheme.primaryColor;
            }
          }
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedStatus = status;
                });
              },
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? getColor() : (isDarkMode ? NewAppTheme.darkBlue : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(25),
                  border: isSelected ? null : Border.all(
                    color: getColor().withOpacity(0.3),
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: getColor().withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    status,
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
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildTicketsList(bool isDarkMode) {
    final filteredTickets = _filteredTickets;
    
    if (filteredTickets.isEmpty) {
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
              'Aucun ticket trouvé',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Essayez de modifier vos filtres',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white38 : Colors.black38,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: filteredTickets.length,
      itemBuilder: (context, index) {
        final ticket = filteredTickets[index];
        return _buildTicketCard(ticket, isDarkMode, index);
      },
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket, bool isDarkMode, int index) {
    Color getPriorityColor() {
      switch (ticket['priority']) {
        case 'Haute':
          return Colors.red;
        case 'Moyenne':
          return Colors.orange;
        default:
          return Colors.green;
      }
    }

    Color getStatusColor() {
      switch (ticket['status']) {
        case 'Nouveau':
          return Colors.blue;
        case 'En cours':
          return Colors.orange;
        case 'En attente':
          return Colors.amber;
        case 'Résolu':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    return InkWell(
      onTap: () => _showTicketDetails(ticket, isDarkMode),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: getPriorityColor().withOpacity(0.3),
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
            // En-tête avec ID et badges
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: getPriorityColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ticket['id'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: getPriorityColor(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: getPriorityColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.flag,
                              size: 12,
                              color: getPriorityColor(),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              ticket['priority'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: getPriorityColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: getStatusColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ticket['status'],
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Titre
            Text(
              ticket['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Description
            Text(
              ticket['description'],
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.white60 : Colors.black54,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            
            // Footer avec client, assignation et temps
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: NewAppTheme.primaryColor.withOpacity(0.2),
                  child: Text(
                    ticket['avatar'],
                    style: TextStyle(
                      color: NewAppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket['customer'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (ticket['assignedTo'] != null)
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 12,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Assigné à ${ticket['assignedTo']}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Icon(
                              Icons.person_off_outlined,
                              size: 12,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Non assigné',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                if (ticket['startTime'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer,
                          size: 14,
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getElapsedTime(ticket['startTime']),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ticket['time'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            
            // Bouton d'action rapide selon le statut
            if (ticket['status'] == 'Nouveau' || ticket['status'] == 'En attente') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _startTicket(ticket),
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text('Traiter ce ticket'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ] else if (ticket['status'] == 'En cours') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _resolveTicket(ticket),
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text('Marquer comme résolu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (300 + index * 50).ms).slideX(begin: 0.2, end: 0);
  }

  void _showTicketDetails(Map<String, dynamic> ticket, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              // Barre de drag
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // En-tête
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: NewAppTheme.primaryColor.withOpacity(0.2),
                    child: Text(
                      ticket['avatar'],
                      style: TextStyle(
                        color: NewAppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket['customer'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ticket['phone'],
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              
              // Détails du ticket
              _buildDetailRow('ID', ticket['id'], Icons.tag),
              _buildDetailRow('Titre', ticket['title'], Icons.title),
              _buildDetailRow('Description', ticket['description'], Icons.description),
              _buildDetailRow('Priorité', ticket['priority'], Icons.flag),
              _buildDetailRow('Statut', ticket['status'], Icons.info),
              _buildDetailRow('Catégorie', ticket['category'], Icons.category),
              _buildDetailRow('Temps', ticket['time'], Icons.access_time),
              
              const SizedBox(height: 24),
              
              // Actions selon le statut
              if (ticket['status'] == 'Nouveau' || ticket['status'] == 'En attente')
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _startTicket(ticket);
                        },
                        icon: const Icon(Icons.play_arrow, size: 24),
                        label: const Text(
                          'Traiter ce ticket',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.phone),
                            label: const Text('Appeler'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: const BorderSide(color: Colors.green),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _closeTicket(ticket);
                            },
                            icon: const Icon(Icons.close),
                            label: const Text('Fermer'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              else if (ticket['status'] == 'En cours')
                Column(
                  children: [
                    if (ticket['startTime'] != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.purple.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.timer, color: Colors.purple, size: 28),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Temps écoulé',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  _getElapsedTime(ticket['startTime']),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _resolveTicket(ticket);
                        },
                        icon: const Icon(Icons.check_circle, size: 24),
                        label: const Text(
                          'Marquer comme résolu',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.phone),
                            label: const Text('Appeler'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green,
                              side: const BorderSide(color: Colors.green),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _closeTicket(ticket);
                            },
                            icon: const Icon(Icons.close),
                            label: const Text('Fermer'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.phone),
                        label: const Text('Appeler'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _closeTicket(ticket);
                        },
                        icon: const Icon(Icons.close),
                        label: const Text('Fermer'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: NewAppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
