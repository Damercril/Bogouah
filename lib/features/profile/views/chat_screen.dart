import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/profile_controller.dart';
import '../models/support_message_model.dart';
import '../../../core/theme/new_app_theme.dart';

class ChatScreen extends StatefulWidget {
  final String ticketId;

  const ChatScreen({Key? key, required this.ticketId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ProfileController controller;
  late SupportTicket ticket;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProfileController>();
    _loadTicket();
    
    // Scroll to bottom when keyboard appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _loadTicket() {
    final index = controller.supportTickets.indexWhere((t) => t.id == widget.ticketId);
    if (index == -1) {
      Get.back();
      Get.snackbar(
        'Erreur',
        'Ticket non trouvé',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    ticket = controller.supportTickets[index];
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.subject,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _getStatusText(ticket.status),
              style: TextStyle(
                fontSize: 12,
                color: _getStatusColor(ticket.status).withOpacity(0.8),
              ),
            ),
          ],
        ),
        backgroundColor: isDarkMode ? NewAppTheme.darkBackground : NewAppTheme.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showTicketDetails(context),
          ),
        ],
      ),
      body: Obx(() {
        _loadTicket(); // Reload ticket on state change
        
        return Column(
          children: [
            Expanded(
              child: _buildMessageList(context),
            ),
            _buildInputArea(context),
          ],
        );
      }),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    if (ticket.messages.isEmpty) {
      return Center(
        child: Text(
          'Aucun message',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white60
                : Colors.black54,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: ticket.messages.length,
      itemBuilder: (context, index) {
        final message = ticket.messages[index];
        final showDate = index == 0 ||
            !_isSameDay(
              ticket.messages[index].timestamp,
              ticket.messages[index - 1].timestamp,
            );
        
        return Column(
          children: [
            if (showDate) _buildDateSeparator(message.timestamp),
            _buildMessageBubble(context, message),
          ],
        );
      },
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.withOpacity(0.3))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _formatDate(date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.withOpacity(0.3))),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, SupportMessage message) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isUserMessage = message.isUserMessage;
    
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUserMessage
              ? NewAppTheme.primaryColor
              : isDarkMode
                  ? Colors.grey.shade800
                  : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUserMessage ? const Radius.circular(0) : null,
            bottomLeft: !isUserMessage ? const Radius.circular(0) : null,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isUserMessage
                    ? Colors.white
                    : isDarkMode
                        ? Colors.white
                        : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 11,
                    color: isUserMessage
                        ? Colors.white.withOpacity(0.7)
                        : isDarkMode
                            ? Colors.white70
                            : Colors.black54,
                  ),
                ),
                const SizedBox(width: 4),
                if (isUserMessage) _buildMessageStatus(message.status, isUserMessage),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageStatus(MessageStatus status, bool isUserMessage) {
    IconData icon;
    Color color;
    
    switch (status) {
      case MessageStatus.sent:
        icon = Icons.check;
        color = Colors.white70;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = Colors.white70;
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = Colors.blue.shade300;
        break;
      case MessageStatus.failed:
        icon = Icons.error_outline;
        color = Colors.red.shade300;
        break;
      case MessageStatus.pending:
        icon = Icons.access_time;
        color = Colors.white70;
        break;
    }
    
    return Icon(
      icon,
      size: 12,
      color: color,
    );
  }

  Widget _buildInputArea(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkCardBackground : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              // Fonctionnalité d'attachement de fichier
              Get.snackbar(
                'Info',
                'Fonctionnalité d\'attachement à venir',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            color: NewAppTheme.primaryColor,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Écrivez votre message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: NewAppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    
    controller.sendSupportMessage(widget.ticketId, message);
    _messageController.clear();
    
    // Scroll to bottom after sending message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _showTicketDetails(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Détails du ticket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Sujet', ticket.subject),
            const SizedBox(height: 8),
            _buildDetailItem('Description', ticket.description),
            const SizedBox(height: 8),
            _buildDetailItem('Créé le', _formatFullDate(ticket.createdAt)),
            const SizedBox(height: 8),
            _buildDetailItem('Statut', _getStatusText(ticket.status)),
            if (ticket.resolvedAt != null) ...[
              const SizedBox(height: 8),
              _buildDetailItem('Résolu le', _formatFullDate(ticket.resolvedAt!)),
            ],
            const SizedBox(height: 8),
            _buildDetailItem('Messages', '${ticket.messages.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);
    
    if (dateToCheck == DateTime(now.year, now.month, now.day)) {
      return 'Aujourd\'hui';
    } else if (dateToCheck == yesterday) {
      return 'Hier';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  String _formatFullDate(DateTime date) {
    return DateFormat('dd/MM/yyyy à HH:mm').format(date);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getStatusText(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'Ouvert';
      case TicketStatus.inProgress:
        return 'En cours';
      case TicketStatus.resolved:
        return 'Résolu';
      case TicketStatus.closed:
        return 'Fermé';
      case TicketStatus.pending:
        return 'En attente';
    }
  }

  Color _getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return Colors.blue;
      case TicketStatus.inProgress:
        return Colors.orange;
      case TicketStatus.resolved:
        return Colors.green;
      case TicketStatus.closed:
        return Colors.grey;
      case TicketStatus.pending:
        return Colors.purple;
    }
  }
}
