import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/new_app_theme.dart';
import '../controllers/ticket_controller.dart';
import '../models/ticket_assignment_model.dart';

/// Panneau de notifications pour les tickets
class NotificationsPanel extends StatelessWidget {
  const NotificationsPanel({Key? key}) : super(key: key);

  IconData _getIconForNotificationType(String type) {
    switch (type) {
      case 'new':
        return Icons.add_circle;
      case 'assigned':
        return Icons.person_add;
      case 'reassigned':
        return Icons.swap_horiz;
      case 'updated':
        return Icons.update;
      case 'resolved':
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForNotificationType(String type) {
    switch (type) {
      case 'new':
        return Colors.blue;
      case 'assigned':
        return Colors.green;
      case 'reassigned':
        return Colors.orange;
      case 'updated':
        return Colors.purple;
      case 'resolved':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return 'Il y a ${(difference.inDays / 7).floor()}sem';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final ticketController = Provider.of<TicketController>(context);
    final notifications = ticketController.notifications;

    return Container(
      width: 400,
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: isDarkMode ? NewAppTheme.darkBlue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // En-tête
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NewAppTheme.primaryColor,
                  NewAppTheme.secondaryColor,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_active,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (ticketController.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${ticketController.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Actions rapides
          if (notifications.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isDarkMode 
                    ? Colors.white.withOpacity(0.05) 
                    : Colors.grey.shade100,
                border: Border(
                  bottom: BorderSide(
                    color: isDarkMode 
                        ? Colors.white.withOpacity(0.1) 
                        : Colors.grey.shade300,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${notifications.length} notification${notifications.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  if (ticketController.unreadCount > 0)
                    TextButton(
                      onPressed: () {
                        ticketController.markAllNotificationsAsRead();
                      },
                      child: const Text(
                        'Tout marquer comme lu',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),

          // Liste des notifications
          Expanded(
            child: notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 64,
                          color: isDarkMode ? Colors.white30 : Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune notification',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _buildNotificationCard(
                        notification,
                        isDarkMode,
                        ticketController,
                        index,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    TicketNotification notification,
    bool isDarkMode,
    TicketController ticketController,
    int index,
  ) {
    final color = _getColorForNotificationType(notification.type);
    final icon = _getIconForNotificationType(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        ticketController.deleteNotification(notification.id);
      },
      child: InkWell(
        onTap: () {
          if (!notification.isRead) {
            ticketController.markNotificationAsRead(notification.id);
          }
          // Ici, vous pouvez naviguer vers le détail du ticket
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: notification.isRead
                ? (isDarkMode ? Colors.white.withOpacity(0.03) : Colors.grey.shade50)
                : (isDarkMode ? Colors.white.withOpacity(0.08) : color.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notification.isRead
                  ? (isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.shade200)
                  : color.withOpacity(0.3),
              width: notification.isRead ? 1 : 2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead 
                                  ? FontWeight.w500 
                                  : FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: isDarkMode ? Colors.white38 : Colors.black38,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getTimeAgo(notification.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: isDarkMode ? Colors.white38 : Colors.black38,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            notification.ticketId,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms).slideX(begin: 0.2, end: 0),
    );
  }
}
