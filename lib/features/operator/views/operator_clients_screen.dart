import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/new_app_theme.dart';
import '../../../core/utils/responsive_helper.dart';

/// Écran "Mes clients" pour l'opérateur
class OperatorClientsScreen extends StatefulWidget {
  const OperatorClientsScreen({Key? key}) : super(key: key);

  @override
  State<OperatorClientsScreen> createState() => _OperatorClientsScreenState();
}

class _OperatorClientsScreenState extends State<OperatorClientsScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Tous';

  final List<Map<String, dynamic>> _clients = [
    {
      'name': 'Jean Dupont',
      'avatar': 'JD',
      'phone': '+33 6 12 34 56 78',
      'email': 'jean.dupont@email.com',
      'status': 'Actif',
      'assignedDate': '15/01/2024',
      'lastContact': '20/01/2024',
      'totalOrders': 12,
      'totalSpent': 45000,
      'priority': 'Haute',
      'notes': [
        {'date': '2024-01-20 10:30', 'text': 'Client très satisfait du service', 'status': 'Actif'},
        {'date': '2024-01-18 14:20', 'text': 'Demande de suivi régulier', 'status': 'Actif'},
      ],
    },
    {
      'name': 'Marie Martin',
      'avatar': 'MM',
      'phone': '+33 6 23 45 67 89',
      'email': 'marie.martin@email.com',
      'status': 'En attente',
      'assignedDate': '20/01/2024',
      'lastContact': '22/01/2024',
      'totalOrders': 8,
      'totalSpent': 32000,
      'priority': 'Moyenne',
      'notes': [
        {'date': '2024-01-22 16:45', 'text': 'Intéressée par nos nouveaux services', 'status': 'En attente'},
      ],
    },
    {
      'name': 'Pierre Durand',
      'avatar': 'PD',
      'phone': '+33 6 34 56 78 90',
      'email': 'pierre.durand@email.com',
      'status': 'Inactif',
      'assignedDate': '25/01/2024',
      'lastContact': '26/01/2024',
      'totalOrders': 3,
      'totalSpent': 12000,
      'priority': 'Basse',
      'notes': [],
    },
    {
      'name': 'Sophie Bernard',
      'avatar': 'SB',
      'phone': '+33 6 45 67 89 01',
      'email': 'sophie.bernard@email.com',
      'status': 'Actif',
      'assignedDate': '10/01/2024',
      'lastContact': '23/01/2024',
      'totalOrders': 15,
      'totalSpent': 67000,
      'priority': 'Haute',
      'notes': [
        {'date': '2024-01-23 09:00', 'text': 'Cliente fidèle, excellent profil', 'status': 'Actif'},
      ],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredClients {
    return _clients.where((client) {
      final matchesSearch = _searchQuery.isEmpty ||
          client['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          client['email'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'Tous' || client['status'] == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
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
            
            // En-tête
            _buildHeader(isDarkMode),
            
            const SizedBox(height: 24),
            
            // Barre de recherche
            _buildSearchBar(isDarkMode),
            
            const SizedBox(height: 16),
            
            // Filtres
            _buildFilters(isDarkMode),
            
            const SizedBox(height: 16),
            
            // Liste des clients
            Expanded(
              child: _buildClientsList(isDarkMode),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.people,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mes clients',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_clients.length} clients attribués',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${(_clients.fold(0, (sum, client) => sum + (client['totalSpent'] as int)) / 1000).toStringAsFixed(0)}k',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
          hintText: '🔍 Rechercher un client...',
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

  Widget _buildFilters(bool isDarkMode) {
    final filters = ['Tous', 'Actif', 'En attente', 'Inactif'];
    
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          
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
                  color: isSelected ? NewAppTheme.primaryColor : (isDarkMode ? NewAppTheme.darkBlue : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(25),
                  border: isSelected ? null : Border.all(
                    color: NewAppTheme.primaryColor.withOpacity(0.3),
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: NewAppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    filter,
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

  Widget _buildClientsList(bool isDarkMode) {
    final filteredClients = _filteredClients;
    
    if (filteredClients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              size: 80,
              color: isDarkMode ? Colors.white30 : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun client trouvé',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white60 : Colors.black54,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: filteredClients.length,
      itemBuilder: (context, index) {
        final client = filteredClients[index];
        return _buildClientCard(client, isDarkMode, index);
      },
    );
  }

  Widget _buildClientCard(Map<String, dynamic> client, bool isDarkMode, int index) {
    Color getStatusColor() {
      switch (client['status']) {
        case 'Actif':
          return Colors.green;
        case 'Inactif':
          return Colors.red;
        default:
          return Colors.orange;
      }
    }

    Color getPriorityColor() {
      switch (client['priority']) {
        case 'Haute':
          return Colors.red;
        case 'Moyenne':
          return Colors.orange;
        default:
          return Colors.blue;
      }
    }

    return InkWell(
      onTap: () => _showClientDetails(client, isDarkMode),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: NewAppTheme.primaryColor.withOpacity(0.2),
            width: 1.5,
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
            // En-tête avec avatar et nom
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: NewAppTheme.primaryColor.withOpacity(0.2),
                  child: Text(
                    client['avatar'],
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
                        client['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: getStatusColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              client['status'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: getStatusColor(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: getPriorityColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.flag, size: 10, color: getPriorityColor()),
                                const SizedBox(width: 4),
                                Text(
                                  client['priority'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: getPriorityColor(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: isDarkMode ? Colors.white60 : Colors.black45,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            
            // Grille d'informations
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildInfoChip(Icons.shopping_cart, '${client['totalOrders']} commandes', Colors.blue, isDarkMode),
                _buildInfoChip(Icons.euro, '${(client['totalSpent'] / 1000).toStringAsFixed(0)}k FCFA', Colors.green, isDarkMode),
                _buildInfoChip(Icons.calendar_today, 'Attribué: ${client['assignedDate']}', Colors.orange, isDarkMode),
                _buildInfoChip(Icons.access_time, 'Dernier contact: ${client['lastContact']}', Colors.purple, isDarkMode),
                _buildInfoChip(Icons.note, '${client['notes'].length} notes', Colors.teal, isDarkMode),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (400 + index * 50).ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildInfoChip(IconData icon, String label, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
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
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showClientDetails(Map<String, dynamic> client, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ClientDetailsSheet(client: client, isDarkMode: isDarkMode),
    );
  }
}

class _ClientDetailsSheet extends StatefulWidget {
  final Map<String, dynamic> client;
  final bool isDarkMode;

  const _ClientDetailsSheet({required this.client, required this.isDarkMode});

  @override
  State<_ClientDetailsSheet> createState() => _ClientDetailsSheetState();
}

class _ClientDetailsSheetState extends State<_ClientDetailsSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: widget.isDarkMode ? NewAppTheme.darkBlue : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Barre de drag
            Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            
            // En-tête client
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: NewAppTheme.primaryColor.withOpacity(0.2),
                    child: Text(
                      widget.client['avatar'],
                      style: TextStyle(
                        color: NewAppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.client['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.client['status'],
                          style: TextStyle(
                            fontSize: 16,
                            color: NewAppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
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
            ),
            
            const SizedBox(height: 16),
            
            // Onglets
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: NewAppTheme.primaryColor,
                unselectedLabelColor: widget.isDarkMode ? Colors.white60 : Colors.black54,
                indicatorColor: NewAppTheme.primaryColor,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(icon: Icon(Icons.info, size: 20), text: 'Infos'),
                  Tab(icon: Icon(Icons.note_alt, size: 20), text: 'Notes'),
                  Tab(icon: Icon(Icons.bar_chart, size: 20), text: 'Stats'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Contenu des onglets
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildInfoTab(scrollController),
                  _buildNotesTab(scrollController),
                  _buildStatsTab(scrollController),
                ],
              ),
            ),
            
            // Boutons d'action
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.phone),
                      label: const Text('Appeler'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.email),
                      label: const Text('Email'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NewAppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        _buildDetailSection('Informations de contact', [
          _buildDetailRow('Nom', widget.client['name'], Icons.person),
          _buildDetailRow('Email', widget.client['email'], Icons.email),
          _buildDetailRow('Téléphone', widget.client['phone'], Icons.phone),
        ]),
        
        const SizedBox(height: 24),
        
        _buildDetailSection('Informations client', [
          _buildDetailRow('Statut', widget.client['status'], Icons.info),
          _buildDetailRow('Priorité', widget.client['priority'], Icons.flag),
          _buildDetailRow('Date d\'attribution', widget.client['assignedDate'], Icons.calendar_today),
          _buildDetailRow('Dernier contact', widget.client['lastContact'], Icons.access_time),
        ]),
      ],
    );
  }

  Widget _buildNotesTab(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        _buildNotesSection(widget.client, widget.isDarkMode),
      ],
    );
  }

  Widget _buildStatsTab(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        _buildDetailSection('Statistiques', [
          _buildDetailRow('Nombre de commandes', widget.client['totalOrders'].toString(), Icons.shopping_cart),
          _buildDetailRow('Total dépensé', '${widget.client['totalSpent']} FCFA', Icons.euro),
          _buildDetailRow('Nombre de notes', '${widget.client['notes'].length}', Icons.note),
        ]),
      ],
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: NewAppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
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

  Widget _buildNotesSection(Map<String, dynamic> client, bool isDarkMode) {
    final notes = client['notes'] as List;
    final TextEditingController noteController = TextEditingController();
    String selectedStatus = 'Actif';
    
    final statusOptions = [
      'Actif',
      'Ne répond pas',
      'En attente',
      'Inactif',
      'À rappeler',
      'Intéressé',
      'Non intéressé',
    ];
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            NewAppTheme.primaryColor.withOpacity(0.15),
            NewAppTheme.secondaryColor.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NewAppTheme.primaryColor.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: NewAppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // En-tête
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NewAppTheme.primaryColor,
                  NewAppTheme.secondaryColor,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.note_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Notes client',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${notes.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Contenu
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Champ de saisie
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: noteController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: '✍️ Notez les points importants...',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white38 : Colors.black38,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Menu déroulant de statut
                StatefulBuilder(
                  builder: (context, setState) => DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: InputDecoration(
                      labelText: 'Statut',
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                      prefixIcon: Icon(Icons.flag, color: isDarkMode ? Colors.white70 : Colors.grey.shade700, size: 20),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: isDarkMode ? Colors.white70 : Colors.grey.shade700, width: 2),
                      ),
                      filled: true,
                      fillColor: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
                    ),
                    items: statusOptions.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(
                          status,
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                    },
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Bouton enregistrer
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        NewAppTheme.primaryColor,
                        NewAppTheme.secondaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: NewAppTheme.primaryColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (noteController.text.trim().isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Note enregistrée avec succès'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        noteController.clear();
                      }
                    },
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text(
                      'Enregistrer la note',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Séparateur
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDarkMode ? Colors.white30 : Colors.grey.shade400,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'HISTORIQUE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDarkMode ? Colors.white30 : Colors.grey.shade400,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Historique des notes
                if (notes.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.speaker_notes_off,
                            size: 48,
                            color: isDarkMode ? Colors.white30 : Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Aucune note enregistrée',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white60 : Colors.black54,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...notes.map((note) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkMode ? Colors.white24 : Colors.grey.shade300,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.white10 : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.access_time,
                                size: 14,
                                color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                note['date'],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: NewAppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                note['status'],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: NewAppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          note['text'],
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
