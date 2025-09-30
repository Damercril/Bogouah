import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/new_app_theme.dart';
import '../../../core/utils/responsive_helper.dart';

/// Écran principal Houbago avec gestion des utilisateurs
class HoubagoScreen extends StatefulWidget {
  const HoubagoScreen({Key? key}) : super(key: key);

  @override
  State<HoubagoScreen> createState() => _HoubagoScreenState();
}

class _HoubagoScreenState extends State<HoubagoScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedVehicleType = 'Tous';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _users = [
    {
      'username': 'Jean Dupont',
      'avatar': 'JD',
      'affiliates': 12,
      'totalGains': 45000,
      'registrationDate': '15/01/2024',
      'role': 'Parrain',
      'vehicleType': 'Voiture',
      'status': 'Actif',
      'searchingVehicle': false,
      'searchingDriver': true,
      'hasLicense': true,
      'hasRegistration': true,
      'phone': '+33 6 12 34 56 78',
      'email': 'jean.dupont@email.com',
      'notes': [
        {'date': '2024-01-20 10:30', 'text': 'Intéressé par le programme de parrainage', 'status': 'Actif'},
        {'date': '2024-01-18 14:20', 'text': 'Premier contact établi, très motivé', 'status': 'Actif'},
      ],
    },
    {
      'username': 'Marie Martin',
      'avatar': 'MM',
      'affiliates': 8,
      'totalGains': 32000,
      'registrationDate': '20/01/2024',
      'role': 'Chauffeur',
      'vehicleType': 'Camion',
      'status': 'Actif',
      'searchingVehicle': true,
      'searchingDriver': false,
      'hasLicense': true,
      'hasRegistration': false,
      'phone': '+33 6 23 45 67 89',
      'email': 'marie.martin@email.com',
      'notes': [
        {'date': '2024-01-22 16:45', 'text': 'Cherche un véhicule pour commencer', 'status': 'En attente'},
      ],
    },
    {
      'username': 'Pierre Durand',
      'avatar': 'PD',
      'affiliates': 0,
      'totalGains': 0,
      'registrationDate': '25/01/2024',
      'role': 'Propriétaire',
      'vehicleType': 'Moto',
      'status': 'En attente',
      'searchingVehicle': false,
      'searchingDriver': true,
      'hasLicense': true,
      'hasRegistration': true,
      'phone': '+33 6 34 56 78 90',
      'email': 'pierre.durand@email.com',
      'notes': [],
    },
    {
      'username': 'Sophie Bernard',
      'avatar': 'SB',
      'affiliates': 15,
      'totalGains': 67000,
      'registrationDate': '10/01/2024',
      'role': 'Parrain',
      'vehicleType': 'Voiture',
      'status': 'Actif',
      'searchingVehicle': false,
      'searchingDriver': false,
      'hasLicense': true,
      'hasRegistration': true,
      'phone': '+33 6 45 67 89 01',
      'email': 'sophie.bernard@email.com',
      'notes': [
        {'date': '2024-01-15 09:00', 'text': 'Excellent parrain, très actif', 'status': 'Actif'},
      ],
    },
    {
      'username': 'Luc Petit',
      'avatar': 'LP',
      'affiliates': 5,
      'totalGains': 18000,
      'registrationDate': '28/01/2024',
      'role': 'Chauffeur',
      'vehicleType': 'Camion',
      'status': 'Inactif',
      'searchingVehicle': true,
      'searchingDriver': false,
      'hasLicense': true,
      'hasRegistration': true,
      'phone': '+33 6 56 78 90 12',
      'email': 'luc.petit@email.com',
      'notes': [
        {'date': '2024-01-29 11:15', 'text': 'Ne répond plus aux appels', 'status': 'Inactif'},
      ],
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
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredUsers {
    return _users.where((user) {
      final matchesTab = _getTabFilter(user);
      final matchesVehicle = _selectedVehicleType == 'Tous' || user['vehicleType'] == _selectedVehicleType;
      final matchesSearch = _searchQuery.isEmpty ||
          user['username'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user['email'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesTab && matchesVehicle && matchesSearch;
    }).toList();
  }

  bool _getTabFilter(Map<String, dynamic> user) {
    switch (_tabController.index) {
      case 0:
        return user['role'] == 'Parrain';
      case 1:
        return user['role'] == 'Chauffeur';
      case 2:
        return user['role'] == 'Propriétaire';
      default:
        return true;
    }
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
            
            // Onglets
            _buildTabs(isDarkMode),
            
            const SizedBox(height: 16),
            
            // Barre de recherche
            _buildSearchBar(isDarkMode),
            
            const SizedBox(height: 16),
            
            // Filtres de type de véhicule
            if (_tabController.index == 1) _buildVehicleFilters(isDarkMode),
            if (_tabController.index == 1) const SizedBox(height: 16),
            
            // Liste des utilisateurs
            Expanded(
              child: _buildUsersList(isDarkMode),
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
            Colors.purple,
            Colors.deepPurple,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
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
                  'Houbago',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_users.length} utilisateurs inscrits',
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
                  '${(_users.fold(0, (sum, user) => sum + (user['totalGains'] as int)) / 1000).toStringAsFixed(0)}k',
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

  Widget _buildTabs(bool isDarkMode) {
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
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          setState(() {});
        },
        labelColor: Colors.purple,
        unselectedLabelColor: isDarkMode ? Colors.white60 : Colors.black54,
        indicatorColor: Colors.purple,
        indicatorWeight: 3,
        tabs: const [
          Tab(
            icon: Icon(Icons.star),
            text: 'Parrain',
          ),
          Tab(
            icon: Icon(Icons.drive_eta),
            text: 'Chauffeur',
          ),
          Tab(
            icon: Icon(Icons.business),
            text: 'Propriétaire',
          ),
          Tab(
            icon: Icon(Icons.group),
            text: 'Tous',
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
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
          hintText: '🔍 Rechercher un utilisateur...',
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
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildVehicleFilters(bool isDarkMode) {
    final types = ['Tous', 'Voiture', 'Camion', 'Moto'];
    
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: types.length,
        itemBuilder: (context, index) {
          final type = types[index];
          final isSelected = _selectedVehicleType == type;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedVehicleType = type;
                });
              },
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.purple : (isDarkMode ? NewAppTheme.darkBlue : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(25),
                  border: isSelected ? null : Border.all(
                    color: Colors.purple.withOpacity(0.3),
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    type,
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
    ).animate().fadeIn(duration: 400.ms, delay: 300.ms);
  }

  Widget _buildUsersList(bool isDarkMode) {
    final filteredUsers = _filteredUsers;
    
    if (filteredUsers.isEmpty) {
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
              'Aucun utilisateur trouvé',
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
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return _buildUserCard(user, isDarkMode, index);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, bool isDarkMode, int index) {
    Color getStatusColor() {
      switch (user['status']) {
        case 'Actif':
          return Colors.green;
        case 'Inactif':
          return Colors.red;
        default:
          return Colors.orange;
      }
    }

    return InkWell(
      onTap: () => _showUserDetails(user, isDarkMode),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.purple.withOpacity(0.2),
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
                  backgroundColor: Colors.purple.withOpacity(0.2),
                  child: Text(
                    user['avatar'],
                    style: const TextStyle(
                      color: Colors.purple,
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
                        user['username'],
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
                              color: Colors.purple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              user['role'],
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: getStatusColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              user['status'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: getStatusColor(),
                              ),
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
                _buildInfoChip(Icons.people, '${user['affiliates']} affiliés', Colors.blue, isDarkMode),
                _buildInfoChip(Icons.euro, '${(user['totalGains'] / 1000).toStringAsFixed(0)}k FCFA', Colors.green, isDarkMode),
                _buildInfoChip(Icons.calendar_today, user['registrationDate'], Colors.orange, isDarkMode),
                _buildInfoChip(Icons.directions_car, user['vehicleType'], Colors.purple, isDarkMode),
                if (user['searchingVehicle'])
                  _buildInfoChip(Icons.search, 'Cherche véhicule', Colors.red, isDarkMode),
                if (user['searchingDriver'])
                  _buildInfoChip(Icons.search, 'Cherche chauffeur', Colors.teal, isDarkMode),
                if (user['hasLicense'])
                  _buildInfoChip(Icons.badge, 'Permis ✓', Colors.green, isDarkMode),
                if (user['hasRegistration'])
                  _buildInfoChip(Icons.description, 'Carte grise ✓', Colors.green, isDarkMode),
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

  void _showUserDetails(Map<String, dynamic> user, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _UserDetailsSheet(user: user, isDarkMode: isDarkMode),
    );
  }
}

class _UserDetailsSheet extends StatefulWidget {
  final Map<String, dynamic> user;
  final bool isDarkMode;

  const _UserDetailsSheet({required this.user, required this.isDarkMode});

  @override
  State<_UserDetailsSheet> createState() => _UserDetailsSheetState();
}

class _UserDetailsSheetState extends State<_UserDetailsSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
            
            // En-tête utilisateur
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.purple.withOpacity(0.2),
                    child: Text(
                      widget.user['avatar'],
                      style: const TextStyle(
                        color: Colors.purple,
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
                          widget.user['username'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.user['role'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.purple,
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
                labelColor: Colors.purple,
                unselectedLabelColor: widget.isDarkMode ? Colors.white60 : Colors.black54,
                indicatorColor: Colors.purple,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(icon: Icon(Icons.info, size: 20), text: 'Infos'),
                  Tab(icon: Icon(Icons.note_alt, size: 20), text: 'Notes'),
                  Tab(icon: Icon(Icons.bar_chart, size: 20), text: 'Stats'),
                  Tab(icon: Icon(Icons.description, size: 20), text: 'Docs'),
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
                  _buildDocsTab(scrollController),
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
                      icon: const Icon(Icons.edit),
                      label: const Text('Modifier'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
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
        _buildDetailSection('Informations générales', [
          _buildDetailRow('Nom d\'utilisateur', widget.user['username'], Icons.person),
          _buildDetailRow('Email', widget.user['email'], Icons.email),
          _buildDetailRow('Téléphone', widget.user['phone'], Icons.phone),
          _buildDetailRow('Date d\'inscription', widget.user['registrationDate'], Icons.calendar_today),
          _buildDetailRow('Rôle', widget.user['role'], Icons.badge),
          _buildDetailRow('Statut', widget.user['status'], Icons.info),
        ]),
        
        const SizedBox(height: 24),
        
        _buildDetailSection('Véhicule', [
          _buildDetailRow('Type de véhicule', widget.user['vehicleType'], Icons.directions_car),
          _buildDetailRow('Cherche véhicule', widget.user['searchingVehicle'] ? 'Oui' : 'Non', Icons.search),
          _buildDetailRow('Cherche chauffeur', widget.user['searchingDriver'] ? 'Oui' : 'Non', Icons.search),
        ]),
      ],
    );
  }

  Widget _buildNotesTab(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        _buildNotesSection(widget.user, widget.isDarkMode),
      ],
    );
  }

  Widget _buildStatsTab(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        _buildDetailSection('Statistiques', [
          _buildDetailRow('Nombre d\'affiliés', widget.user['affiliates'].toString(), Icons.people),
          _buildDetailRow('Gains totaux', '${widget.user['totalGains']} FCFA', Icons.euro),
          _buildDetailRow('Type de véhicule', widget.user['vehicleType'], Icons.directions_car),
        ]),
      ],
    );
  }

  Widget _buildDocsTab(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        _buildDetailSection('Documents', [
          _buildDetailRow('Permis', widget.user['hasLicense'] ? 'Validé ✓' : 'Non fourni', Icons.badge),
          _buildDetailRow('Carte grise', widget.user['hasRegistration'] ? 'Validé ✓' : 'Non fourni', Icons.description),
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
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
          Icon(icon, size: 20, color: Colors.purple),
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

  Widget _buildNotesSection(Map<String, dynamic> user, bool isDarkMode) {
    final notes = user['notes'] as List;
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
            Colors.purple.withOpacity(0.15),
            Colors.deepPurple.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
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
                  Colors.purple,
                  Colors.deepPurple,
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
                    'Notes d\'appel',
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
                      hintText: '✍️ Notez les points importants de l\'appel...',
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
                      labelText: 'Statut de l\'appel',
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
                        Colors.purple,
                        Colors.deepPurple,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (noteController.text.trim().isNotEmpty) {
                        // Logique d'enregistrement de la note
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
                                color: Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                note['status'],
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
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
