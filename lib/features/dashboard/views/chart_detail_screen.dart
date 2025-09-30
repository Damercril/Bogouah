import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/new_app_theme.dart';

class ChartDetailScreen extends StatefulWidget {
  final String title;
  final Widget Function(BuildContext, bool) chartBuilder;
  final List<Map<String, dynamic>>? data;
  final String chartType;

  const ChartDetailScreen({
    Key? key,
    required this.title,
    required this.chartBuilder,
    this.data,
    required this.chartType,
  }) : super(key: key);

  @override
  State<ChartDetailScreen> createState() => _ChartDetailScreenState();
}

class _ChartDetailScreenState extends State<ChartDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Partage du graphique en cours...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.download,
              color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Téléchargement du graphique en cours...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre du graphique
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
                ),
              ).animate().fadeIn(duration: 400.ms),
              
              const SizedBox(height: 24),
              
              // Graphique agrandi
              Expanded(
                child: Container(
                  width: double.infinity,
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
                  child: widget.chartBuilder(context, isDarkMode),
                ).animate().fadeIn(duration: 600.ms).scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                  duration: 600.ms,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Informations supplémentaires ou légende
              if (widget.data != null && widget.chartType == 'services')
                _buildServiceDetails(isDarkMode),
              
              if (widget.chartType == 'barChart')
                _buildBarChartDetails(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildServiceDetails(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Détails des services',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.data!.length,
          itemBuilder: (context, index) {
            final item = widget.data![index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: item['color'],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item['title'],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Text(
                    '${item['value']}%',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: item['color'],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(
              delay: Duration(milliseconds: 200 * index),
              duration: 400.ms,
            ).slideX(
              begin: 0.1,
              end: 0,
              delay: Duration(milliseconds: 200 * index),
              duration: 400.ms,
            );
          },
        ),
      ],
    ).animate().fadeIn(delay: 800.ms, duration: 400.ms);
  }
  
  Widget _buildBarChartDetails(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analyse détaillée',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Ce graphique présente les données de courses et revenus par jour de la semaine. '
          'Vous pouvez observer les tendances et identifier les jours les plus actifs.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildLegendItem(NewAppTheme.primaryColor, 'Courses', isDarkMode),
            const SizedBox(width: 24),
            _buildLegendItem(NewAppTheme.accentColor, 'Revenus (FCFA)', isDarkMode),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 800.ms, duration: 400.ms);
  }
  
  Widget _buildLegendItem(Color color, String text, bool isDarkMode) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode
                ? NewAppTheme.white.withOpacity(0.9)
                : NewAppTheme.darkGrey.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
