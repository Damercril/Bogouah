import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/new_app_theme.dart';
import 'chart_detail_screen.dart';
import '../../operators/views/operator_detail_screen.dart';
import '../../operators/models/operator_stats.dart';

class NewDashboardScreen extends StatefulWidget {
  const NewDashboardScreen({Key? key}) : super(key: key);

  @override
  State<NewDashboardScreen> createState() => _NewDashboardScreenState();
}

class _NewDashboardScreenState extends State<NewDashboardScreen> {
  int _selectedPeriodIndex = 1; // Semaine par défaut
  final List<String> _periods = ['Jour', 'Semaine', 'Mois', 'Année'];

  // Données fictives pour les KPIs
  final List<Map<String, dynamic>> _kpiData = [
    {
      'title': 'Chiffre d\'affaires',
      'value': '125M FCFA',
      'change': 12,
      'isPositive': true,
      'color': NewAppTheme.primaryColor,
    },
    {
      'title': 'Chauffeurs actifs',
      'value': 48,
      'change': 8,
      'isPositive': true,
      'color': NewAppTheme.accentColor,
    },
    {
      'title': 'Courses totales',
      'value': 1250,
      'change': 15,
      'isPositive': true,
      'color': NewAppTheme.secondaryColor,
    },
    {
      'title': 'Satisfaction',
      'value': '92%',
      'change': 3,
      'isPositive': true,
      'color': Colors.amber,
    },
  ];

  // Données fictives pour le graphique en camembert
  final List<Map<String, dynamic>> _pieChartData = [
    {'title': 'VTC', 'value': 45, 'color': NewAppTheme.primaryColor},
    {'title': 'Taxi', 'value': 30, 'color': NewAppTheme.secondaryColor},
    {'title': 'Livraison', 'value': 15, 'color': NewAppTheme.accentColor},
    {'title': 'Autres', 'value': 10, 'color': Colors.amber},
  ];

  // Données fictives pour le graphique en barres
  final List<Map<String, dynamic>> _barChartData = [
    {'day': 'Lun', 'courses': 180, 'revenus': 2250000},
    {'day': 'Mar', 'courses': 165, 'revenus': 2100000},
    {'day': 'Mer', 'courses': 190, 'revenus': 2400000},
    {'day': 'Jeu', 'courses': 210, 'revenus': 2600000},
    {'day': 'Ven', 'courses': 230, 'revenus': 2850000},
    {'day': 'Sam', 'courses': 175, 'revenus': 2200000},
    {'day': 'Dim', 'courses': 100, 'revenus': 1300000},
  ];

  // Données fictives pour les performances des chauffeurs
  final List<Map<String, dynamic>> _operatorPerformance = [
    {
      'name': 'Jean Dupont',
      'avatar': 'JD',
      'courses': 128,
      'chiffreAffaires': '3,25M FCFA',
      'satisfaction': 96,
    },
    {
      'name': 'Marie Dubois',
      'avatar': 'MD',
      'courses': 115,
      'chiffreAffaires': '2,98M FCFA',
      'satisfaction': 98,
    },
    {
      'name': 'Ahmed Benali',
      'avatar': 'AB',
      'courses': 105,
      'chiffreAffaires': '2,75M FCFA',
      'satisfaction': 94,
    },
    {
      'name': 'Sophie Moreau',
      'avatar': 'SM',
      'courses': 98,
      'chiffreAffaires': '2,54M FCFA',
      'satisfaction': 92,
    },
  ];

  // La méthode _onNavTap a été supprimée car la navigation est gérée par MainScreenWrapper

  void _onPeriodChanged(int index) {
    setState(() {
      _selectedPeriodIndex = index;
    });
    // Ici, vous pourriez charger des données différentes selon la période
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
                'Dashboard',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
            ],
          ),
        ),
        // Contenu principal
        Expanded(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // Sélecteur de période
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.lightGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: List.generate(
                    _periods.length,
                    (index) => Expanded(
                      child: GestureDetector(
                        onTap: () => _onPeriodChanged(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedPeriodIndex == index
                                ? NewAppTheme.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              _periods[index],
                              style: TextStyle(
                                color: _selectedPeriodIndex == index
                                    ? NewAppTheme.white
                                    : isDarkMode
                                        ? NewAppTheme.white.withOpacity(0.7)
                                        : NewAppTheme.darkGrey.withOpacity(0.7),
                                fontWeight: _selectedPeriodIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              
              const SizedBox(height: 24),
              
              // KPIs en ligne
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _kpiData.length,
                  itemBuilder: (context, index) {
                    final kpi = _kpiData[index];
                    return Container(
                      width: 150,
                      margin: EdgeInsets.only(
                        right: index < _kpiData.length - 1 ? 16 : 0,
                      ),
                      padding: const EdgeInsets.all(16),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            kpi['title'],
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode
                                  ? NewAppTheme.white.withOpacity(0.7)
                                  : NewAppTheme.darkGrey.withOpacity(0.7),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              kpi['value'].toString(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: kpi['color'],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                kpi['isPositive']
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: kpi['isPositive']
                                    ? NewAppTheme.accentColor
                                    : NewAppTheme.errorColor,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${kpi['change']}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kpi['isPositive']
                                      ? NewAppTheme.accentColor
                                      : NewAppTheme.errorColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms + (index * 100).ms).slideX(begin: 0.2, end: 0);
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Graphiques
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Répartition des services',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChartDetailScreen(
                                  title: 'Répartition des services',
                                  chartBuilder: (context, isDarkMode) => _buildFullScreenPieChart(),
                                  data: _pieChartData,
                                  chartType: 'services',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 220,
                            padding: const EdgeInsets.all(16),
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
                            child: Stack(
                              children: [
                                _buildPieChart(),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Icon(
                                    Icons.fullscreen,
                                    color: isDarkMode ? NewAppTheme.white.withOpacity(0.7) : NewAppTheme.darkGrey.withOpacity(0.7),
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Courses et revenus par jour',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChartDetailScreen(
                                  title: 'Courses et revenus par jour',
                                  chartBuilder: (context, isDarkMode) => _buildFullScreenBarChart(isDarkMode),
                                  chartType: 'barChart',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 220,
                            padding: const EdgeInsets.all(16),
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
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      child: _buildBarChart(isDarkMode),
                                    ),
                                    const SizedBox(height: 8),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          _buildLegendItem(NewAppTheme.primaryColor, 'Courses', isDarkMode),
                                          const SizedBox(width: 16),
                                          _buildLegendItem(NewAppTheme.accentColor, 'Revenus (FCFA)', isDarkMode),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Icon(
                                    Icons.fullscreen,
                                    color: isDarkMode ? NewAppTheme.white.withOpacity(0.7) : NewAppTheme.darkGrey.withOpacity(0.7),
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Performances des opérateurs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chauffeurs les plus performants',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Voir tout',
                      style: TextStyle(
                        color: NewAppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _operatorPerformance.length,
                itemBuilder: (context, index) {
                  final operator = _operatorPerformance[index];
                  return InkWell(
                    onTap: () {
                      // Naviguer vers l'écran de détails de l'opérateur
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OperatorDetailScreen(
                            operator: operator,
                            operatorStats: OperatorStats.generateMockDataForOperator(operator['name']),
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
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
                      child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
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
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                operator['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildOperatorStat(
                                      Icons.directions_car_outlined,
                                      '${operator['courses']} courses',
                                      isDarkMode,
                                    ),
                                    const SizedBox(width: 16),
                                    _buildOperatorStat(
                                      Icons.euro_outlined,
                                      operator['chiffreAffaires'],
                                      isDarkMode,
                                    ),
                                    const SizedBox(width: 16),
                                    _buildOperatorStat(
                                      Icons.thumb_up_outlined,
                                      '${operator['satisfaction']}%',
                                      isDarkMode,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: isDarkMode
                              ? NewAppTheme.white.withOpacity(0.5)
                              : NewAppTheme.darkGrey.withOpacity(0.5),
                        ),
                      ],
                    ),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 500.ms + (index * 100).ms).slideY(begin: 0.2, end: 0);
                },
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
        ),
      ],
    );
  }

  Widget _buildOperatorStat(IconData icon, String text, bool isDarkMode) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: isDarkMode
              ? NewAppTheme.white.withOpacity(0.7)
              : NewAppTheme.darkGrey.withOpacity(0.7),
        ),
        const SizedBox(width: 4),
        Text(
          text,
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
  
  Widget _buildLegendItem(Color color, String text, bool isDarkMode) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
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

  // Index du service actuellement sélectionné
  int _selectedServiceIndex = 0;

  Widget _buildPieChart() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final selectedData = _pieChartData[_selectedServiceIndex];
    
    return Column(
      children: [
        // Affichage du service sélectionné
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Cercle extérieur
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedData['color'].withOpacity(0.2),
                ),
              ),
              
              // Cercle intérieur
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedData['color'],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedData['title'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${selectedData['value']}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Slider pour naviguer entre les services
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: NewAppTheme.primaryColor,
            inactiveTrackColor: isDarkMode 
                ? NewAppTheme.white.withOpacity(0.2) 
                : NewAppTheme.darkGrey.withOpacity(0.1),
            thumbColor: NewAppTheme.primaryColor,
            overlayColor: NewAppTheme.primaryColor.withOpacity(0.2),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            min: 0,
            max: (_pieChartData.length - 1).toDouble(),
            divisions: _pieChartData.length - 1,
            value: _selectedServiceIndex.toDouble(),
            onChanged: (value) {
              setState(() {
                _selectedServiceIndex = value.toInt();
              });
            },
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Indicateurs de services
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _pieChartData.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == _selectedServiceIndex
                    ? _pieChartData[index]['color']
                    : (isDarkMode 
                        ? NewAppTheme.white.withOpacity(0.3) 
                        : NewAppTheme.darkGrey.withOpacity(0.3)),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Liste des services avec pourcentages
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _pieChartData.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedServiceIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: index == _selectedServiceIndex
                        ? data['color'].withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: index == _selectedServiceIndex
                          ? data['color']
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: _buildLegendItem(
                    data['color'] as Color,
                    '${data['title']} (${data['value']}%)',
                    isDarkMode,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFullScreenPieChart() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final selectedData = _pieChartData[_selectedServiceIndex];
    
    return Column(
      children: [
        // Affichage du service sélectionné
        Expanded(
          flex: 3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Cercle extérieur
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedData['color'].withOpacity(0.2),
                ),
              ),
              
              // Cercle intérieur
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedData['color'],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedData['title'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${selectedData['value']}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Slider pour naviguer entre les services
        Expanded(
          flex: 2,
          child: Column(
            children: [
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: NewAppTheme.primaryColor,
                  inactiveTrackColor: isDarkMode 
                      ? NewAppTheme.white.withOpacity(0.2) 
                      : NewAppTheme.darkGrey.withOpacity(0.1),
                  thumbColor: NewAppTheme.primaryColor,
                  overlayColor: NewAppTheme.primaryColor.withOpacity(0.2),
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                ),
                child: Slider(
                  min: 0,
                  max: (_pieChartData.length - 1).toDouble(),
                  divisions: _pieChartData.length - 1,
                  value: _selectedServiceIndex.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _selectedServiceIndex = value.toInt();
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Indicateurs de services
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pieChartData.length,
                  (index) => Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _selectedServiceIndex
                          ? _pieChartData[index]['color']
                          : (isDarkMode 
                              ? NewAppTheme.white.withOpacity(0.3) 
                              : NewAppTheme.darkGrey.withOpacity(0.3)),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Liste des services avec pourcentages
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _pieChartData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedServiceIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12.0),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: index == _selectedServiceIndex
                              ? data['color'].withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: index == _selectedServiceIndex
                                ? data['color']
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: _buildLegendItem(
                          data['color'] as Color,
                          '${data['title']} (${data['value']}%)',
                          isDarkMode,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFullScreenBarChart(bool isDarkMode) {
    return Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 3000000,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: isDarkMode ? NewAppTheme.darkBlue.withOpacity(0.8) : Colors.white.withOpacity(0.8),
                  tooltipPadding: const EdgeInsets.all(12),
                  tooltipMargin: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final data = _barChartData[group.x.toInt()];
                    String value = rodIndex == 0 
                        ? '${data['courses']} courses' 
                        : '${(data['revenus'] / 1000000).toStringAsFixed(2)}M FCFA';
                    return BarTooltipItem(
                      '${data['day']}\n$value',
                      TextStyle(
                        color: isDarkMode ? Colors.white : NewAppTheme.darkGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < _barChartData.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _barChartData[value.toInt()]['day'],
                            style: TextStyle(
                              color: isDarkMode
                                  ? NewAppTheme.white.withOpacity(0.8)
                                  : NewAppTheme.darkGrey.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                    reservedSize: 40,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    interval: 1000000,
                    getTitlesWidget: (value, meta) {
                      if (value % 1000000 == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '${(value / 1000000).toInt()}M',
                            style: TextStyle(
                              color: isDarkMode
                                  ? NewAppTheme.white.withOpacity(0.7)
                                  : NewAppTheme.darkGrey.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1000000,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: isDarkMode
                        ? NewAppTheme.white.withOpacity(0.1)
                        : NewAppTheme.darkGrey.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(_barChartData.length, (index) {
                final data = _barChartData[index];
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data['courses'].toDouble(),
                      color: NewAppTheme.primaryColor,
                      width: 12,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                    BarChartRodData(
                      toY: data['revenus'].toDouble(),
                      color: NewAppTheme.accentColor,
                      width: 20,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(NewAppTheme.primaryColor, 'Courses', isDarkMode),
            const SizedBox(width: 32),
            _buildLegendItem(NewAppTheme.accentColor, 'Revenus (FCFA)', isDarkMode),
          ],
        ),
      ],
    );
  }

  Widget _buildBarChart(bool isDarkMode) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 3000000,
        barTouchData: BarTouchData(
          enabled: false,
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < _barChartData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _barChartData[value.toInt()]['day'],
                      style: TextStyle(
                        color: isDarkMode
                            ? NewAppTheme.white.withOpacity(0.7)
                            : NewAppTheme.darkGrey.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1000000,
              getTitlesWidget: (value, meta) {
                if (value % 1000000 == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      '${(value / 1000000).toInt()}M',
                      style: TextStyle(
                        color: isDarkMode
                            ? NewAppTheme.white.withOpacity(0.5)
                            : NewAppTheme.darkGrey.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1000000,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDarkMode
                  ? NewAppTheme.white.withOpacity(0.1)
                  : NewAppTheme.darkGrey.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(_barChartData.length, (index) {
          final data = _barChartData[index];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data['courses'].toDouble(),
                color: NewAppTheme.primaryColor,
                width: 8,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              BarChartRodData(
                toY: data['revenus'].toDouble(),
                color: NewAppTheme.accentColor,
                width: 14,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
