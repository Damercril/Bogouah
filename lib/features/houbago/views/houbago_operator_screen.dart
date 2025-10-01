import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/new_app_theme.dart';
import '../../../core/utils/responsive_helper.dart';

/// Écran Houbago pour les opérateurs - Gestion des parrains et affiliés
class HoubagoOperatorScreen extends StatefulWidget {
  const HoubagoOperatorScreen({Key? key}) : super(key: key);

  @override
  State<HoubagoOperatorScreen> createState() => _HoubagoOperatorScreenState();
}

class _HoubagoOperatorScreenState extends State<HoubagoOperatorScreen> with SingleTickerProviderStateMixin {
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
      'phone': '+221 77 123 45 67',
      'email': 'jean.dupont@email.com',
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
      'phone': '+221 77 234 56 78',
      'email': 'marie.martin@email.com',
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
      'phone': '+221 77 345 67 89',
      'email': 'pierre.durand@email.com',
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
      'phone': '+221 77 456 78 90',
      'email': 'sophie.bernard@email.com',
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
      'phone': '+221 77 567 89 01',
      'email': 'luc.petit@email.com',
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

    return Container(
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
              _buildInfoChip(Icons.attach_money, '${(user['totalGains'] / 1000).toStringAsFixed(0)}k FCFA', Colors.green, isDarkMode),
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
}
