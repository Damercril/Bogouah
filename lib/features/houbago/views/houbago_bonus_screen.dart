import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/new_app_theme.dart';
import '../../../core/utils/responsive_helper.dart';

/// Écran de gestion des bonus pour les chauffeurs Houbago
class HoubagoBonusScreen extends StatefulWidget {
  const HoubagoBonusScreen({Key? key}) : super(key: key);

  @override
  State<HoubagoBonusScreen> createState() => _HoubagoBonusScreenState();
}

class _HoubagoBonusScreenState extends State<HoubagoBonusScreen> {
  // Programmes de bonus actifs
  final List<Map<String, dynamic>> _bonusPrograms = [
    {
      'id': 1,
      'name': 'Bonus Courses Hebdomadaires',
      'type': 'courses',
      'condition': '70 courses',
      'period': 'Lundi - Samedi',
      'reward': 'Sans commission',
      'rewardAmount': 0,
      'paymentDay': 'Dimanche',
      'active': true,
      'participants': 45,
      'qualified': 12,
      'totalPaid': 0,
      'icon': Icons.directions_car,
      'color': Colors.blue,
    },
    {
      'id': 2,
      'name': 'Bonus CA Mensuel',
      'type': 'revenue',
      'condition': '175 000 FCFA',
      'period': 'Mensuel',
      'reward': '5 000 FCFA',
      'rewardAmount': 5000,
      'paymentDay': '1er du mois',
      'active': true,
      'participants': 156,
      'qualified': 38,
      'totalPaid': 190000,
      'icon': Icons.attach_money,
      'color': Colors.green,
    },
    {
      'id': 3,
      'name': 'Bonus Performance Journalière',
      'type': 'courses',
      'condition': '15 courses/jour',
      'period': 'Quotidien',
      'reward': '2 000 FCFA',
      'rewardAmount': 2000,
      'paymentDay': 'Lendemain',
      'active': true,
      'participants': 156,
      'qualified': 23,
      'totalPaid': 46000,
      'icon': Icons.star,
      'color': Colors.orange,
    },
    {
      'id': 4,
      'name': 'Bonus Fidélité Trimestriel',
      'type': 'loyalty',
      'condition': '90 jours actifs',
      'period': 'Trimestriel',
      'reward': '25 000 FCFA',
      'rewardAmount': 25000,
      'paymentDay': 'Fin trimestre',
      'active': false,
      'participants': 89,
      'qualified': 15,
      'totalPaid': 375000,
      'icon': Icons.loyalty,
      'color': Colors.purple,
    },
  ];

  // Chauffeurs qualifiés pour les bonus
  final List<Map<String, dynamic>> _qualifiedDrivers = [
    {
      'name': 'Mamadou Diallo',
      'avatar': 'MD',
      'courses': 72,
      'revenue': 185000,
      'bonus': 'Courses Hebdo + CA Mensuel',
      'amount': 5000,
      'status': 'En attente',
      'paymentDate': 'Dimanche',
    },
    {
      'name': 'Fatou Sall',
      'avatar': 'FS',
      'courses': 68,
      'revenue': 178000,
      'bonus': 'CA Mensuel',
      'amount': 5000,
      'status': 'Payé',
      'paymentDate': '01/12/2024',
    },
    {
      'name': 'Ibrahima Ndiaye',
      'avatar': 'IN',
      'courses': 85,
      'revenue': 220000,
      'bonus': 'Courses Hebdo + CA Mensuel',
      'amount': 5000,
      'status': 'En attente',
      'paymentDate': 'Dimanche',
    },
  ];

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
              
              // Statistiques des bonus
              _buildBonusStats(isDarkMode),
              
              const SizedBox(height: 32),
              
              // Programmes de bonus actifs
              _buildBonusPrograms(isDarkMode),
              
              const SizedBox(height: 32),
              
              // Chauffeurs qualifiés
              _buildQualifiedDrivers(isDarkMode),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateBonusDialog(context, isDarkMode),
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.add),
        label: const Text('Nouveau Bonus'),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
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
              Icons.card_giftcard,
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
                  'Gestion des Bonus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_bonusPrograms.where((p) => p['active'] == true).length} programmes actifs',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildBonusStats(bool isDarkMode) {
    final totalParticipants = _bonusPrograms.fold(0, (sum, p) => sum + (p['participants'] as int));
    final totalQualified = _bonusPrograms.fold(0, (sum, p) => sum + (p['qualified'] as int));
    final totalPaid = _bonusPrograms.fold(0, (sum, p) => sum + (p['totalPaid'] as int));
    
    return ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isTablet(context)
        ? Row(
            children: [
              Expanded(child: _buildStatCard('Participants', '$totalParticipants', Icons.people, Colors.blue, isDarkMode)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Qualifiés', '$totalQualified', Icons.check_circle, Colors.green, isDarkMode)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Total Versé', '${(totalPaid / 1000).toStringAsFixed(0)}k FCFA', Icons.payments, Colors.orange, isDarkMode)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Programmes', '${_bonusPrograms.length}', Icons.card_giftcard, Colors.purple, isDarkMode)),
            ],
          )
        : Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatCard('Participants', '$totalParticipants', Icons.people, Colors.blue, isDarkMode)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('Qualifiés', '$totalQualified', Icons.check_circle, Colors.green, isDarkMode)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatCard('Total Versé', '${(totalPaid / 1000).toStringAsFixed(0)}k', Icons.payments, Colors.orange, isDarkMode)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('Programmes', '${_bonusPrograms.length}', Icons.card_giftcard, Colors.purple, isDarkMode)),
                ],
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
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }

  Widget _buildBonusPrograms(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Programmes de Bonus',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showCreateBonusDialog(context, isDarkMode),
              icon: const Icon(Icons.add),
              label: const Text('Nouveau'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _bonusPrograms.length,
          itemBuilder: (context, index) {
            return _buildBonusProgramCard(_bonusPrograms[index], isDarkMode, index);
          },
        ),
      ],
    );
  }

  Widget _buildBonusProgramCard(Map<String, dynamic> program, bool isDarkMode, int index) {
    final isActive = program['active'] as bool;
    final color = program['color'] as Color;
    
    return InkWell(
      onTap: () => _showProgramDetails(context, program, isDarkMode),
      borderRadius: BorderRadius.circular(16),
      child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? color.withOpacity(0.5) : Colors.grey.withOpacity(0.3),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  program['icon'] as IconData,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            program['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isActive ? 'Actif' : 'Inactif',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isActive ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Période: ${program['period']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildProgramInfo('Condition', program['condition'], Icons.flag, color, isDarkMode),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildProgramInfo('Récompense', program['reward'], Icons.card_giftcard, color, isDarkMode),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildProgramInfo('Paiement', program['paymentDay'], Icons.calendar_today, color, isDarkMode),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${program['participants']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Participants',
                        style: TextStyle(fontSize: 11, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${program['qualified']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Qualifiés',
                        style: TextStyle(fontSize: 11, color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${(program['totalPaid'] / 1000).toStringAsFixed(0)}k',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Versé',
                        style: TextStyle(fontSize: 11, color: Colors.orange),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _editBonusProgram(program),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Modifier'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _toggleBonusProgram(program),
                icon: Icon(isActive ? Icons.pause : Icons.play_arrow, size: 18),
                label: Text(isActive ? 'Désactiver' : 'Activer'),
                style: TextButton.styleFrom(
                  foregroundColor: isActive ? Colors.orange : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (index * 100).ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildProgramInfo(String label, String value, IconData icon, Color color, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDarkMode ? Colors.white60 : Colors.black54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildQualifiedDrivers(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chauffeurs Qualifiés',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _qualifiedDrivers.length,
          itemBuilder: (context, index) {
            return _buildDriverCard(_qualifiedDrivers[index], isDarkMode, index);
          },
        ),
      ],
    );
  }

  Widget _buildDriverCard(Map<String, dynamic> driver, bool isDarkMode, int index) {
    final isPaid = driver['status'] == 'Payé';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPaid ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
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
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.purple.withOpacity(0.2),
            child: Text(
              driver['avatar'],
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 18,
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  driver['bonus'],
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildDriverStat(Icons.directions_car, '${driver['courses']} courses', Colors.blue),
                    const SizedBox(width: 12),
                    _buildDriverStat(Icons.attach_money, '${(driver['revenue'] / 1000).toStringAsFixed(0)}k', Colors.green),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isPaid ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  driver['status'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isPaid ? Colors.green : Colors.orange,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${driver['amount']} FCFA',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                driver['paymentDate'],
                style: TextStyle(
                  fontSize: 11,
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (index * 100).ms);
  }

  Widget _buildDriverStat(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showCreateBonusDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        title: const Text('Créer un Programme de Bonus'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nom du programme',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Type de condition',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'courses', child: Text('Nombre de courses')),
                  DropdownMenuItem(value: 'revenue', child: Text('Chiffre d\'affaires')),
                  DropdownMenuItem(value: 'loyalty', child: Text('Fidélité')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Condition (ex: 70 courses)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Montant du bonus (FCFA)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Période',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'daily', child: Text('Quotidien')),
                  DropdownMenuItem(value: 'weekly', child: Text('Hebdomadaire')),
                  DropdownMenuItem(value: 'monthly', child: Text('Mensuel')),
                  DropdownMenuItem(value: 'quarterly', child: Text('Trimestriel')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Programme de bonus créé avec succès')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  void _editBonusProgram(Map<String, dynamic> program) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modification de ${program['name']}')),
    );
  }

  void _toggleBonusProgram(Map<String, dynamic> program) {
    setState(() {
      program['active'] = !(program['active'] as bool);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          program['active'] 
              ? '${program['name']} activé' 
              : '${program['name']} désactivé',
        ),
      ),
    );
  }

  void _showProgramDetails(BuildContext context, Map<String, dynamic> program, bool isDarkMode) {
    // Générer des chauffeurs fictifs pour la démo
    final List<Map<String, dynamic>> allDrivers = [
      {'name': 'Mamadou Diallo', 'avatar': 'MD', 'courses': 72, 'revenue': 185000, 'qualified': true},
      {'name': 'Fatou Sall', 'avatar': 'FS', 'courses': 68, 'revenue': 178000, 'qualified': false},
      {'name': 'Ibrahima Ndiaye', 'avatar': 'IN', 'courses': 85, 'revenue': 220000, 'qualified': true},
      {'name': 'Aminata Ba', 'avatar': 'AB', 'courses': 45, 'revenue': 125000, 'qualified': false},
      {'name': 'Ousmane Sarr', 'avatar': 'OS', 'courses': 78, 'revenue': 195000, 'qualified': true},
      {'name': 'Aissatou Diop', 'avatar': 'AD', 'courses': 52, 'revenue': 142000, 'qualified': false},
      {'name': 'Cheikh Sy', 'avatar': 'CS', 'courses': 91, 'revenue': 245000, 'qualified': true},
      {'name': 'Mariama Cisse', 'avatar': 'MC', 'courses': 38, 'revenue': 98000, 'qualified': false},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          String filterStatus = 'Tous'; // Tous, Qualifiés, Non qualifiés
          
          final filteredDrivers = allDrivers.where((driver) {
            if (filterStatus == 'Qualifiés') return driver['qualified'] == true;
            if (filterStatus == 'Non qualifiés') return driver['qualified'] == false;
            return true;
          }).toList();

          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (program['color'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              program['icon'] as IconData,
                              color: program['color'] as Color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  program['name'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Condition: ${program['condition']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDarkMode ? Colors.white60 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${allDrivers.where((d) => d['qualified'] == true).length}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const Text(
                                    'Qualifiés',
                                    style: TextStyle(fontSize: 12, color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${allDrivers.where((d) => d['qualified'] == false).length}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const Text(
                                    'Non qualifiés',
                                    style: TextStyle(fontSize: 12, color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const Divider(height: 1),
                
                // Filtres
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildFilterChip('Tous', filterStatus == 'Tous', () {
                        setModalState(() => filterStatus = 'Tous');
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip('Qualifiés', filterStatus == 'Qualifiés', () {
                        setModalState(() => filterStatus = 'Qualifiés');
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip('Non qualifiés', filterStatus == 'Non qualifiés', () {
                        setModalState(() => filterStatus = 'Non qualifiés');
                      }),
                    ],
                  ),
                ),
                
                // Liste des chauffeurs
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredDrivers.length,
                    itemBuilder: (context, index) {
                      final driver = filteredDrivers[index];
                      final isQualified = driver['qualified'] as bool;
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isQualified ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: (program['color'] as Color).withOpacity(0.2),
                              child: Text(
                                driver['avatar'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: program['color'] as Color,
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
                                  Row(
                                    children: [
                                      Icon(Icons.directions_car, size: 14, color: Colors.blue),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${driver['courses']} courses',
                                        style: const TextStyle(fontSize: 12, color: Colors.blue),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(Icons.attach_money, size: 14, color: Colors.green),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${(driver['revenue'] / 1000).toStringAsFixed(0)}k',
                                        style: const TextStyle(fontSize: 12, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isQualified ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isQualified ? Icons.check_circle : Icons.cancel,
                                    size: 16,
                                    color: isQualified ? Colors.green : Colors.orange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isQualified ? 'Qualifié' : 'Non qualifié',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isQualified ? Colors.green : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
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

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
