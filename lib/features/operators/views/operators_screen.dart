import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../controllers/operators_controller.dart';
import '../models/operator_model.dart';
import '../../../core/theme/app_theme.dart';

class OperatorsScreen extends StatefulWidget {
  const OperatorsScreen({super.key});

  @override
  State<OperatorsScreen> createState() => _OperatorsScreenState();
}

class _OperatorsScreenState extends State<OperatorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OperatorsController(),
      child: Consumer<OperatorsController>(
        builder: (context, controller, _) {
          return Column(
            children: [
              // En-tête avec titre et actions
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Suivi des Opérateurs',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: controller.refreshOperators,
                          tooltip: 'Rafraîchir',
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _showAddOperatorDialog(context),
                          tooltip: 'Ajouter un opérateur',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Contenu principal
              Expanded(
                child: Column(
                  children: [
                    _buildFiltersSection(context, controller),
                    _buildStatisticsCards(context, controller),
                    Expanded(
                      child: _buildOperatorsList(context, controller),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFiltersSection(BuildContext context, OperatorsController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Rechercher un opérateur',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  controller.setSearchTerm('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: controller.setSearchTerm,
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  context, 
                  'Tous', 
                  controller.statusFilter == null,
                  () => controller.setStatusFilter(null),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context, 
                  'Actifs', 
                  controller.statusFilter == OperatorStatus.active,
                  () => controller.setStatusFilter(OperatorStatus.active),
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context, 
                  'Inactifs', 
                  controller.statusFilter == OperatorStatus.inactive,
                  () => controller.setStatusFilter(OperatorStatus.inactive),
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context, 
                  'En congé', 
                  controller.statusFilter == OperatorStatus.onLeave,
                  () => controller.setStatusFilter(OperatorStatus.onLeave),
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context, 
                  'Suspendus', 
                  controller.statusFilter == OperatorStatus.suspended,
                  () => controller.setStatusFilter(OperatorStatus.suspended),
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, 
    String label, 
    bool isSelected, 
    VoidCallback onTap, 
    {Color? color}
  ) {
    final theme = Theme.of(context);
    
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      showCheckmark: false,
      backgroundColor: color?.withOpacity(0.2) ?? theme.chipTheme.backgroundColor,
      selectedColor: color ?? theme.colorScheme.primary,
      onSelected: (_) => onTap(),
    );
  }

  Widget _buildStatisticsCards(BuildContext context, OperatorsController controller) {
    final stats = controller.getOperatorStats();
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStatCard(
            context,
            'Total Opérateurs',
            stats['totalOperators'].toString(),
            Icons.people,
            theme.colorScheme.primary,
          ),
          _buildStatCard(
            context,
            'Actifs',
            stats['activeOperators'].toString(),
            Icons.check_circle,
            Colors.green,
          ),
          _buildStatCard(
            context,
            'Performance Moyenne',
            '${stats['averagePerformance'].toStringAsFixed(1)}%',
            Icons.trending_up,
            Colors.blue,
          ),
          _buildStatCard(
            context,
            'Tickets Complétés',
            stats['totalCompletedTickets'].toString(),
            Icons.task_alt,
            Colors.purple,
          ),
          _buildStatCard(
            context,
            'Tickets En Attente',
            stats['totalPendingTickets'].toString(),
            Icons.pending_actions,
            Colors.orange,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorsList(BuildContext context, OperatorsController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (controller.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(controller.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.refreshOperators,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }
    
    if (controller.filteredOperators.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Aucun opérateur trouvé'),
            if (controller.searchTerm.isNotEmpty || controller.statusFilter != null)
              const SizedBox(height: 16),
            if (controller.searchTerm.isNotEmpty || controller.statusFilter != null)
              ElevatedButton(
                onPressed: () {
                  _searchController.clear();
                  controller.setSearchTerm('');
                  controller.setStatusFilter(null);
                },
                child: const Text('Effacer les filtres'),
              ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.filteredOperators.length,
      itemBuilder: (context, index) {
        final operator = controller.filteredOperators[index];
        return _buildOperatorCard(context, operator, controller)
          .animate()
          .fadeIn(delay: (50 * index).ms, duration: 300.ms)
          .slideY(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildOperatorCard(
    BuildContext context, 
    OperatorModel operator,
    OperatorsController controller,
  ) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: operator.status.color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showOperatorDetails(context, operator),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                    child: Text(
                      operator.name[0].toUpperCase(),
                      style: TextStyle(
                        color: theme.colorScheme.primary,
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
                          operator.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          operator.email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(context, operator.status),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      'Date d\'entrée',
                      dateFormat.format(operator.joinDate),
                      Icons.calendar_today,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      'Tickets complétés',
                      operator.completedTickets.toString(),
                      Icons.task_alt,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      'Performance',
                      '${operator.performanceScore.toStringAsFixed(1)}%',
                      Icons.trending_up,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildActionButton(
                    context,
                    'Modifier',
                    Icons.edit,
                    theme.colorScheme.primary,
                    () => _showEditOperatorDialog(context, operator),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    context,
                    'Statut',
                    Icons.swap_horiz,
                    Colors.orange,
                    () => _showStatusChangeDialog(context, operator, controller),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    context,
                    'Supprimer',
                    Icons.delete,
                    Colors.red,
                    () => _showDeleteConfirmationDialog(context, operator, controller),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, OperatorStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: status.color, width: 1),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: color),
      label: Text(label, style: TextStyle(color: color)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withOpacity(0.5)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showOperatorDetails(BuildContext context, OperatorModel operator) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                    child: Text(
                      operator.name[0].toUpperCase(),
                      style: TextStyle(
                        color: theme.colorScheme.primary,
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
                          operator.name,
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildStatusBadge(context, operator.status),
                            const SizedBox(width: 8),
                            Text(
                              'ID: ${operator.id}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailItem(context, 'Email', operator.email, Icons.email),
              _buildDetailItem(context, 'Téléphone', operator.phone, Icons.phone),
              _buildDetailItem(
                context, 
                'Date d\'entrée', 
                dateFormat.format(operator.joinDate), 
                Icons.calendar_today,
              ),
              const Divider(height: 32),
              Text(
                'Performance',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildPerformanceItem(
                      context,
                      'Score',
                      '${operator.performanceScore.toStringAsFixed(1)}%',
                      Icons.trending_up,
                      Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _buildPerformanceItem(
                      context,
                      'Tickets complétés',
                      operator.completedTickets.toString(),
                      Icons.task_alt,
                      Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildPerformanceItem(
                      context,
                      'Tickets en attente',
                      operator.pendingTickets.toString(),
                      Icons.pending_actions,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              if (operator.additionalInfo.isNotEmpty) ...[
                const Divider(height: 32),
                Text(
                  'Informations supplémentaires',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ...operator.additionalInfo.entries.map((entry) {
                  return _buildDetailItem(
                    context, 
                    entry.key, 
                    entry.value is List 
                      ? (entry.value as List).join(', ') 
                      : entry.value.toString(),
                    Icons.info,
                  );
                }),
              ],
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fermer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showAddOperatorDialog(BuildContext context) {
    // Cette fonction serait implémentée pour ajouter un nouvel opérateur
    // Pour l'instant, affichons juste un message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité d\'ajout d\'opérateur à implémenter'),
      ),
    );
  }

  void _showEditOperatorDialog(BuildContext context, OperatorModel operator) {
    // Cette fonction serait implémentée pour modifier un opérateur
    // Pour l'instant, affichons juste un message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Modification de l\'opérateur ${operator.name} à implémenter'),
      ),
    );
  }

  void _showStatusChangeDialog(
    BuildContext context, 
    OperatorModel operator,
    OperatorsController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Changer le statut de ${operator.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusOption(
              context,
              'Actif',
              OperatorStatus.active,
              operator,
              controller,
            ),
            _buildStatusOption(
              context,
              'Inactif',
              OperatorStatus.inactive,
              operator,
              controller,
            ),
            _buildStatusOption(
              context,
              'En congé',
              OperatorStatus.onLeave,
              operator,
              controller,
            ),
            _buildStatusOption(
              context,
              'Suspendu',
              OperatorStatus.suspended,
              operator,
              controller,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOption(
    BuildContext context,
    String label,
    OperatorStatus status,
    OperatorModel operator,
    OperatorsController controller,
  ) {
    final isCurrentStatus = operator.status == status;
    
    return ListTile(
      title: Text(label),
      leading: CircleAvatar(
        backgroundColor: status.color,
        radius: 12,
      ),
      trailing: isCurrentStatus ? const Icon(Icons.check) : null,
      enabled: !isCurrentStatus,
      onTap: isCurrentStatus
          ? null
          : () {
              controller.changeOperatorStatus(operator.id, status);
              Navigator.of(context).pop();
            },
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context, 
    OperatorModel operator,
    OperatorsController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer l\'opérateur ${operator.name} ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteOperator(operator.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
