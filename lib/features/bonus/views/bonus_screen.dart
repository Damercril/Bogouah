import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/new_app_theme.dart';
import '../../../core/utils/responsive_helper.dart';

/// Écran de gestion des bonus pour les chauffeurs
class BonusScreen extends StatefulWidget {
  const BonusScreen({Key? key}) : super(key: key);

  @override
  State<BonusScreen> createState() => _BonusScreenState();
}

class _BonusScreenState extends State<BonusScreen> {
  int _selectedBonusIndex = 0;

  // Règles de bonus disponibles
  final List<Map<String, dynamic>> _bonusRules = [
    {
      'id': 1,
      'title': 'Dimanche sans commission',
      'description': '70 courses dans la semaine',
      'icon': Icons.weekend,
      'color': Colors.purple,
      'target': 70,
      'type': 'courses',
      'reward': 'Dimanche sans commission',
      'active': true,
    },
    {
      'id': 2,
      'title': 'Bonus 50 000 FCFA',
      'description': '100 courses dans le mois',
      'icon': Icons.attach_money,
      'color': Colors.green,
      'target': 100,
      'type': 'courses',
      'reward': '50 000 FCFA',
      'active': true,
    },
    {
      'id': 3,
      'title': 'Réduction carburant 20%',
      'description': 'Satisfaction > 95%',
      'icon': Icons.local_gas_station,
      'color': Colors.orange,
      'target': 95,
      'type': 'satisfaction',
      'reward': '20% réduction carburant',
      'active': true,
    },
    {
      'id': 4,
      'title': 'Prime excellence',
      'description': 'CA > 20M FCFA',
      'icon': Icons.star,
      'color': Colors.amber,
      'target': 20000000,
      'type': 'ca',
      'reward': '100 000 FCFA',
      'active': false,
    },
  ];

  // Chauffeurs éligibles par bonus
  final Map<int, List<Map<String, dynamic>>> _eligibleDrivers = {
    1: [ // Dimanche sans commission
      {
        'name': 'Ahmed Diallo',
        'avatar': 'AD',
        'courses': 78,
        'progress': 78 / 70,
        'zone': 'Dakar Centre',
      },
      {
        'name': 'Fatou Sow',
        'avatar': 'FS',
        'courses': 75,
        'progress': 75 / 70,
        'zone': 'Plateau',
      },
      {
        'name': 'Moussa Kane',
        'avatar': 'MK',
        'courses': 72,
        'progress': 72 / 70,
        'zone': 'Almadies',
      },
    ],
    2: [ // Bonus 50 000 FCFA
      {
        'name': 'Ahmed Diallo',
        'avatar': 'AD',
        'courses': 105,
        'progress': 105 / 100,
        'zone': 'Dakar Centre',
      },
      {
        'name': 'Fatou Sow',
        'avatar': 'FS',
        'courses': 102,
        'progress': 102 / 100,
        'zone': 'Plateau',
      },
    ],
    3: [ // Réduction carburant
      {
        'name': 'Ahmed Diallo',
        'avatar': 'AD',
        'satisfaction': 98,
        'progress': 98 / 95,
        'zone': 'Dakar Centre',
      },
      {
        'name': 'Fatou Sow',
        'avatar': 'FS',
        'satisfaction': 97,
        'progress': 97 / 95,
        'zone': 'Plateau',
      },
      {
        'name': 'Moussa Kane',
        'avatar': 'MK',
        'satisfaction': 96,
        'progress': 96 / 95,
        'zone': 'Almadies',
      },
    ],
    4: [], // Prime excellence (aucun éligible pour le moment)
  };

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
              
              const SizedBox(height: 32),
              
              // Grille des règles de bonus
              _buildBonusRulesGrid(isDarkMode),
              
              const SizedBox(height: 32),
              
              // Section des chauffeurs éligibles
              _buildEligibleDriversSection(isDarkMode),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber,
            Colors.orange,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
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
              Icons.card_giftcard,
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
                  'Programme de Bonus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_bonusRules.where((r) => r['active']).length} bonus actifs • ${_getTotalEligibleDrivers()} chauffeurs éligibles',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Ajouter un nouveau bonus
            },
            icon: const Icon(Icons.add),
            label: const Text('Nouveau bonus'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildBonusRulesGrid(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Règles de bonus',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _bonusRules.length,
          itemBuilder: (context, index) {
            final bonus = _bonusRules[index];
            final isSelected = _selectedBonusIndex == index;
            final eligibleCount = _eligibleDrivers[bonus['id']]?.length ?? 0;
            
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedBonusIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected 
                        ? bonus['color'] 
                        : (bonus['color'] as Color).withOpacity(0.2),
                    width: isSelected ? 3 : 1,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (bonus['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            bonus['icon'],
                            color: bonus['color'],
                            size: 28,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: bonus['active'] 
                                ? Colors.green.withOpacity(0.1) 
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            bonus['active'] ? 'Actif' : 'Inactif',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: bonus['active'] ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bonus['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bonus['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? Colors.white60 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 14,
                              color: bonus['color'],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$eligibleCount éligible${eligibleCount > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: bonus['color'],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: (index * 100).ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEligibleDriversSection(bool isDarkMode) {
    final selectedBonus = _bonusRules[_selectedBonusIndex];
    final eligibleDrivers = _eligibleDrivers[selectedBonus['id']] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (selectedBonus['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                selectedBonus['icon'],
                color: selectedBonus['color'],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chauffeurs éligibles : ${selectedBonus['title']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    selectedBonus['reward'],
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedBonus['color'],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (eligibleDrivers.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () {
                  // Attribuer le bonus à tous
                },
                icon: const Icon(Icons.check_circle, size: 18),
                label: const Text('Attribuer à tous'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedBonus['color'],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        
        if (eligibleDrivers.isEmpty)
          Container(
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
                    'Aucun chauffeur éligible pour le moment',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: eligibleDrivers.length,
            itemBuilder: (context, index) {
              final driver = eligibleDrivers[index];
              return _buildEligibleDriverCard(driver, selectedBonus, isDarkMode, index);
            },
          ),
      ],
    );
  }

  Widget _buildEligibleDriverCard(
    Map<String, dynamic> driver,
    Map<String, dynamic> bonus,
    bool isDarkMode,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (bonus['color'] as Color).withOpacity(0.3),
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
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: (bonus['color'] as Color).withOpacity(0.2),
            child: Text(
              driver['avatar'],
              style: TextStyle(
                color: bonus['color'],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Informations
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
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: isDarkMode ? Colors.white60 : Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      driver['zone'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Barre de progression
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: driver['progress'] > 1 ? 1 : driver['progress'],
                          backgroundColor: (bonus['color'] as Color).withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(bonus['color']),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _getProgressText(driver, bonus),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: bonus['color'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Bouton d'action
          ElevatedButton(
            onPressed: () {
              // Attribuer le bonus
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: bonus['color'],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Attribuer'),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (index * 50).ms).slideX(begin: 0.2, end: 0);
  }

  String _getProgressText(Map<String, dynamic> driver, Map<String, dynamic> bonus) {
    if (bonus['type'] == 'courses') {
      return '${driver['courses']}/${bonus['target']}';
    } else if (bonus['type'] == 'satisfaction') {
      return '${driver['satisfaction']}%';
    } else if (bonus['type'] == 'ca') {
      return '${(driver['ca'] / 1000000).toStringAsFixed(1)}M';
    }
    return '';
  }

  int _getTotalEligibleDrivers() {
    return _eligibleDrivers.values.fold(0, (sum, list) => sum + list.length);
  }
}
