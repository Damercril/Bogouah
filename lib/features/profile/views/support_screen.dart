import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../models/support_message_model.dart';
import '../../../core/theme/new_app_theme.dart';
import 'chat_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support & Assistance'),
        centerTitle: true,
        backgroundColor: isDarkMode ? NewAppTheme.darkBackground : NewAppTheme.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // TODO: Implémenter le centre d'aide
            },
            tooltip: 'Centre d\'aide',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: controller.supportTickets.isEmpty
                  ? _buildEmptyState(context)
                  : _buildTicketsList(context, controller),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewTicketDialog(context),
        backgroundColor: NewAppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            NewAppTheme.primaryColor.withOpacity(0.8),
            NewAppTheme.primaryColor,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comment pouvons-nous vous aider ?',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Notre équipe est disponible pour répondre à vos questions',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.support_agent,
            size: 80,
            color: isDarkMode ? Colors.white38 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun ticket de support',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Créez un nouveau ticket pour contacter notre équipe',
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white60 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showNewTicketDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Nouveau ticket'),
            style: ElevatedButton.styleFrom(
              backgroundColor: NewAppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsList(BuildContext context, ProfileController controller) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.supportTickets.length,
      itemBuilder: (context, index) {
        final ticket = controller.supportTickets[index];
        return _buildTicketCard(context, ticket);
      },
    );
  }

  Widget _buildTicketCard(BuildContext context, SupportTicket ticket) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final lastMessage = ticket.messages.isNotEmpty ? ticket.messages.last : null;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? NewAppTheme.darkCardBackground : Colors.white,
      child: InkWell(
        onTap: () {
          Get.to(() => ChatScreen(ticketId: ticket.id));
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildStatusBadge(ticket.status),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ticket.subject,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${ticket.createdAt.day}/${ticket.createdAt.month}/${ticket.createdAt.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (lastMessage != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: lastMessage.isUserMessage
                          ? NewAppTheme.primaryColor.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      child: Icon(
                        lastMessage.isUserMessage ? Icons.person : Icons.support_agent,
                        size: 16,
                        color: lastMessage.isUserMessage
                            ? NewAppTheme.primaryColor
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lastMessage.isUserMessage ? 'Vous' : 'Support',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lastMessage.content,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white60 : Colors.black54,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${ticket.messages.length} message${ticket.messages.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TicketStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case TicketStatus.open:
        color = Colors.blue;
        text = 'Ouvert';
        break;
      case TicketStatus.inProgress:
        color = Colors.orange;
        text = 'En cours';
        break;
      case TicketStatus.resolved:
        color = Colors.green;
        text = 'Résolu';
        break;
      case TicketStatus.closed:
        color = Colors.grey;
        text = 'Fermé';
        break;
      case TicketStatus.pending:
        color = Colors.purple;
        text = 'En attente';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  void _showNewTicketDialog(BuildContext context) {
    final subjectController = TextEditingController();
    final descriptionController = TextEditingController();
    final controller = Get.find<ProfileController>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau ticket de support'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Sujet',
                  hintText: 'Ex: Problème de connexion',
                ),
                maxLength: 100,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Décrivez votre problème en détail',
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                maxLength: 500,
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
              if (subjectController.text.trim().isEmpty ||
                  descriptionController.text.trim().isEmpty) {
                Get.snackbar(
                  'Erreur',
                  'Veuillez remplir tous les champs',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              
              controller.createSupportTicket(
                subjectController.text.trim(),
                descriptionController.text.trim(),
              );
              
              Navigator.pop(context);
            },
            child: const Text('Envoyer'),
          ),
        ],
      ),
    );
  }
}
