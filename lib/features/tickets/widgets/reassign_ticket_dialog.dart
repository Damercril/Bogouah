import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/new_app_theme.dart';
import '../controllers/ticket_controller.dart';
import '../models/ticket_model.dart';

/// Dialog pour réassigner un ticket à un autre opérateur
class ReassignTicketDialog extends StatefulWidget {
  final TicketModel ticket;

  const ReassignTicketDialog({Key? key, required this.ticket}) : super(key: key);

  @override
  State<ReassignTicketDialog> createState() => _ReassignTicketDialogState();
}

class _ReassignTicketDialogState extends State<ReassignTicketDialog> {
  String? _selectedOperator;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final ticketController = Provider.of<TicketController>(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange,
                        Colors.deepOrange,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.swap_horiz,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Réassigner le ticket',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.ticket.id,
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
            
            // Assignation actuelle
            if (widget.ticket.assignedTo != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? Colors.white.withOpacity(0.05) 
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode 
                        ? Colors.white.withOpacity(0.1) 
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Actuellement assigné à : ',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    Text(
                      widget.ticket.assignedTo!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Sélection du nouvel opérateur
            const Text(
              'Réassigner à',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            DropdownButtonFormField<String>(
              value: _selectedOperator,
              decoration: InputDecoration(
                labelText: 'Sélectionner un opérateur',
                prefixIcon: const Icon(Icons.person_add),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: ticketController.availableOperators
                  .where((op) => op['name'] != widget.ticket.assignedTo)
                  .map((operator) {
                return DropdownMenuItem(
                  value: operator['name'],
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: NewAppTheme.primaryColor.withOpacity(0.2),
                        child: Text(
                          operator['avatar']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: NewAppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(operator['name']!),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOperator = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Raison de la réassignation
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Raison de la réassignation (optionnel)',
                hintText: 'Ex: Charge de travail, expertise spécifique...',
                prefixIcon: const Icon(Icons.comment),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _selectedOperator == null
                        ? null
                        : () async {
                            await ticketController.reassignTicket(
                              ticketId: widget.ticket.id,
                              newOperatorName: _selectedOperator!,
                              reassignedBy: 'Admin', // À remplacer par l'utilisateur connecté
                              reason: _reasonController.text.isNotEmpty
                                  ? _reasonController.text
                                  : null,
                            );
                            
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Ticket réassigné à $_selectedOperator',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                    icon: const Icon(Icons.check),
                    label: const Text('Réassigner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
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
          ],
        ),
      ),
    );
  }
}
