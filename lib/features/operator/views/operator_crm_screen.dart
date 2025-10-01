import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/new_app_theme.dart';
import '../../../core/utils/responsive_helper.dart';

/// Écran CRM pour les opérateurs - Fiches chauffeurs avec notes
class OperatorCRMScreen extends StatefulWidget {
  const OperatorCRMScreen({Key? key}) : super(key: key);

  @override
  State<OperatorCRMScreen> createState() => _OperatorCRMScreenState();
}

class _OperatorCRMScreenState extends State<OperatorCRMScreen> {
  int _currentDriverIndex = 0;
  final TextEditingController _noteController = TextEditingController();
  String _selectedStatus = 'Actif';

  final List<String> _statusOptions = [
    'Actif',
    'Ne répond pas',
    'Véhicule au garage',
    'Parti au village',
    'En congé',
    'Indisponible',
    'À rappeler',
  ];

  // Liste des chauffeurs à traiter
  final List<Map<String, dynamic>> _drivers = [
    {
      'name': 'Jean Dupont',
      'phone': '+221 77 123 45 67',
      'courses': 145,
      'ca': 12500,
      'trend': '+15%',
      'isPositive': true,
      'rating': 4.8,
      'lastActivity': '2h',
      'lastCourseDate': '15/01/2024 18:30',
      'weekCourses': 22,
      'status': 'Actif',
      'notes': [
        {'date': '2024-01-15 10:30', 'text': 'Client satisfait, demande plus de courses en soirée'},
        {'date': '2024-01-10 14:20', 'text': 'Problème résolu avec le paiement'},
      ],
      'weekData': [12, 15, 18, 14, 20, 17, 22],
    },
    {
      'name': 'Marie Martin',
      'phone': '+221 77 234 56 78',
      'courses': 98,
      'ca': 8900,
      'trend': '-8%',
      'isPositive': false,
      'rating': 4.5,
      'lastActivity': '5h',
      'lastCourseDate': '14/01/2024 22:15',
      'weekCourses': 18,
      'status': 'Actif',
      'notes': [
        {'date': '2024-01-14 16:45', 'text': 'Demande d\'assistance technique'},
      ],
      'weekData': [18, 16, 14, 12, 10, 9, 8],
    },
    {
      'name': 'Pierre Durand',
      'phone': '+221 77 345 67 89',
      'courses': 167,
      'ca': 15200,
      'trend': '+22%',
      'isPositive': true,
      'rating': 4.9,
      'lastActivity': '30min',
      'lastCourseDate': '16/01/2024 09:45',
      'weekCourses': 28,
      'status': 'Actif',
      'notes': [],
      'weekData': [10, 13, 16, 19, 22, 25, 28],
    },
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _nextDriver() {
    if (_currentDriverIndex < _drivers.length - 1) {
      setState(() {
        _currentDriverIndex++;
        _noteController.clear();
      });
    } else {
      // Fin de la liste
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Toutes les fiches ont été traitées !'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _previousDriver() {
    if (_currentDriverIndex > 0) {
      setState(() {
        _currentDriverIndex--;
        _noteController.clear();
      });
    }
  }

  void _saveNote() {
    if (_noteController.text.trim().isEmpty) return;
    
    setState(() {
      _drivers[_currentDriverIndex]['notes'].insert(0, {
        'date': DateTime.now().toString().substring(0, 16),
        'text': _noteController.text.trim(),
      });
      _noteController.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note enregistrée avec succès'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final driver = _drivers[_currentDriverIndex];
    
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getHorizontalPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            
            // Fiche chauffeur avec graphique intégré
            _buildDriverCard(driver, isDarkMode),
            
            const SizedBox(height: 8),
            
            // Section notes (maximum d'espace)
            Expanded(
              child: _buildNotesSection(driver, isDarkMode),
            ),
            
            const SizedBox(height: 8),
            
            // Boutons d'action
            _buildActionButtons(isDarkMode),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard(Map<String, dynamic> driver, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
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
            color: NewAppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Infos chauffeur en ligne
          Row(
            children: [
              // Avatar compact
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white.withOpacity(0.3),
                child: Text(
                  driver['name'].split(' ').map((e) => e[0]).join(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              
              // Infos principales
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      driver['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Numéro de téléphone en GROS
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          driver['phone'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Dernière course et courses de la semaine
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Dernière course: ${driver['lastCourseDate']}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Courses cette semaine: ${driver['weekCourses']}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Stats compactes - Wrap dans un Flexible pour éviter l'overflow
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCompactStat(Icons.directions_car, driver['courses'].toString()),
                      const SizedBox(width: 6),
                      _buildCompactStat(Icons.euro, '${(driver["ca"] / 1000).toStringAsFixed(1)}k'),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              driver['isPositive'] ? Icons.trending_up : Icons.trending_down,
                              color: driver['isPositive'] ? Colors.greenAccent : Colors.redAccent,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              driver['trend'],
                              style: TextStyle(
                                color: driver['isPositive'] ? Colors.greenAccent : Colors.redAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Séparateur discret
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Divider(color: Colors.white.withOpacity(0.2), height: 1),
          ),
          
          // Graphique intégré
          SizedBox(
            height: 100,
            child: _buildPerformanceChart(driver, isDarkMode),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale(delay: 100.ms);
  }

  Widget _buildCompactStat(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
  
  Widget _buildPerformanceChart(Map<String, dynamic> driver, bool isDarkMode) {
    final weekData = List<double>.from(driver['weekData'].map((e) => e.toDouble()));
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              'Performance hebdomadaire',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: weekData.length - 1.0,
                minY: 0,
                maxY: weekData.reduce((a, b) => a > b ? a : b) * 1.2,
                lineBarsData: [
                  LineChartBarData(
                    spots: weekData.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value);
                    }).toList(),
                    isCurved: true,
                    color: Colors.white,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(Map<String, dynamic> driver, bool isDarkMode) {
    final notes = driver['notes'] as List;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
        // Section Notes CRM avec fond orange
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange.withOpacity(0.15),
                Colors.deepOrange.withOpacity(0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.orange.withOpacity(0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // En-tête avec icône
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange,
                      Colors.deepOrange,
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
                        'Notes CRM - Conversation',
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Champ de saisie avec style amélioré
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
                      controller: _noteController,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: '✍️ Notez les points importants de la conversation...',
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
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: InputDecoration(
                      labelText: 'Statut de la conversation',
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
                    items: _statusOptions.map((status) {
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
                        _selectedStatus = value!;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Bouton enregistrer avec style amélioré
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange,
                          Colors.deepOrange,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _saveNote,
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
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 300.ms).scale(delay: 350.ms),
        
        const SizedBox(height: 16),
        
        // Section Historique avec fond blanc
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode ? Colors.white24 : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history,
                    color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'HISTORIQUE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Historique des notes
              if (notes.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        const SizedBox(height: 4),
                        Text(
                          'Ajoutez des notes importantes',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white38 : Colors.black38,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...notes.map((note) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? NewAppTheme.darkBlue.withOpacity(0.5) : Colors.grey.shade50,
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
                              );
                  }).toList(),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Row(
      children: [
        if (_currentDriverIndex > 0)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _previousDriver,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Précédent'),
              style: OutlinedButton.styleFrom(
                foregroundColor: NewAppTheme.primaryColor,
                side: BorderSide(color: NewAppTheme.primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        if (_currentDriverIndex > 0) const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _nextDriver,
            icon: const Icon(Icons.arrow_forward),
            label: Text(_currentDriverIndex < _drivers.length - 1 ? 'Suivant' : 'Terminer'),
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
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }
}
