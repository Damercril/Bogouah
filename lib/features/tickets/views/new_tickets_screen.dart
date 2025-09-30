import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/new_app_theme.dart';
import '../models/ticket_model.dart';

class NewTicketsScreen extends StatefulWidget {
  const NewTicketsScreen({Key? key}) : super(key: key);

  @override
  State<NewTicketsScreen> createState() => _NewTicketsScreenState();
}

class _NewTicketsScreenState extends State<NewTicketsScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', 'Ouverts', 'En cours', 'Résolus', 'Fermés'];
  final List<String> _sortOptions = ['Plus récent', 'Plus ancien', 'Priorité', 'Statut'];
  String _selectedSort = 'Plus récent';

  // Utilisation du modèle de données pour les tickets
  late List<TicketModel> _tickets;
  
  @override
  void initState() {
    super.initState();
    _tickets = TicketData.getSampleTickets();
  }
  
  // Ancienne liste de données fictives pour référence
  /*
  final List<Map<String, dynamic>> _oldTickets = [
    {
      'id': 'TK-2023-001',
      'title': 'Problème de connexion au réseau',
      'description': 'Impossible de se connecter au réseau wifi de l\'entreprise depuis ce matin.',
      'status': 'Ouvert',
      'statusColor': NewAppTheme.errorColor,
      'priority': 'Haute',
      'priorityColor': NewAppTheme.errorColor,
      'category': 'Réseau',
      'assignedTo': 'Sophie Martin',
      'createdBy': 'Jean Dupont',
      'createdAt': '10:30 - Aujourd\'hui',
      'updatedAt': '10:30 - Aujourd\'hui',
      'comments': 2,
      'attachments': 1,
    },
    {
      'id': 'TK-2023-002',
      'title': 'Mise à jour du système',
      'description': 'Besoin d\'une mise à jour du système d\'exploitation sur tous les postes du service comptabilité.',
      'status': 'En cours',
      'statusColor': Colors.amber,
      'priority': 'Moyenne',
      'priorityColor': Colors.amber,
      'category': 'Logiciel',
      'assignedTo': 'Thomas Dubois',
      'createdBy': 'Marie Lambert',
      'createdAt': '09:15 - Aujourd\'hui',
      'updatedAt': '11:45 - Aujourd\'hui',
      'comments': 5,
      'attachments': 0,
    },
    {
      'id': 'TK-2023-003',
      'title': 'Problème d\'imprimante',
      'description': 'L\'imprimante du 3ème étage ne fonctionne plus et affiche une erreur de cartouche.',
      'status': 'Résolu',
      'statusColor': NewAppTheme.accentColor,
      'priority': 'Basse',
      'priorityColor': NewAppTheme.secondaryColor,
      'category': 'Matériel',
      'assignedTo': 'Lucas Bernard',
      'createdBy': 'Paul Durand',
      'createdAt': 'Hier - 14:20',
      'updatedAt': 'Hier - 16:35',
      'comments': 3,
      'attachments': 2,
    },
    {
      'id': 'TK-2023-004',
      'title': 'Accès à la base de données',
      'description': 'Besoin d\'un accès à la base de données clients pour le nouveau membre de l\'équipe marketing.',
      'status': 'En cours',
      'statusColor': Colors.amber,
      'priority': 'Haute',
      'priorityColor': NewAppTheme.errorColor,
      'category': 'Accès',
      'assignedTo': 'Emma Leroy',
      'createdBy': 'Sophie Petit',
      'createdAt': 'Hier - 11:05',
      'updatedAt': 'Aujourd\'hui - 09:30',
      'comments': 4,
      'attachments': 0,
    },
    {
      'id': 'TK-2023-005',
      'title': 'Installation de logiciel',
      'description': 'Installation de la suite Adobe sur le poste du nouveau designer.',
      'status': 'Fermé',
      'statusColor': Colors.grey,
      'priority': 'Moyenne',
      'priorityColor': Colors.amber,
      'category': 'Logiciel',
      'assignedTo': 'Thomas Dubois',
      'createdBy': 'Claire Martin',
      'createdAt': '15/06/2023 - 09:00',
      'updatedAt': '16/06/2023 - 14:20',
      'comments': 6,
      'attachments': 1,
    },
    {
      'id': 'TK-2023-006',
      'title': 'Problème de serveur mail',
      'description': 'Le serveur mail est inaccessible pour toute l\'entreprise depuis 30 minutes.',
      'status': 'Ouvert',
      'statusColor': NewAppTheme.errorColor,
      'priority': 'Critique',
      'priorityColor': Colors.purple,
      'category': 'Serveur',
      'assignedTo': 'Non assigné',
      'createdBy': 'Directeur IT',
      'createdAt': 'Aujourd\'hui - 08:45',
      'updatedAt': 'Aujourd\'hui - 08:45',
      'comments': 0,
      'attachments': 0,
    },
  ];
  */

  List<TicketModel> get _filteredTickets {
    return _tickets.where((ticket) {
      // Filtre par recherche
      final titleMatches = ticket.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final idMatches = ticket.id.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Filtre par statut
      final statusMatches = _selectedFilter == 'Tous' || ticket.status.label == _selectedFilter;
      
      return (titleMatches || idMatches) && statusMatches;
    }).toList();
  }

  // La navigation est maintenant gérée par le MainScreenWrapper

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onSortChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedSort = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        // En-tête avec titre et actions
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    color: NewAppTheme.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text('Tickets', 
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // Afficher plus d'options de filtrage
                    },
                    tooltip: 'Filtres avancés',
                  ),
                  IconButton(
                    icon: const Icon(Icons.sort),
                    onPressed: () {
                      // Afficher les options de tri
                    },
                    tooltip: 'Trier',
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
              // Barre de recherche et filtres
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  children: [
                    // Barre de recherche améliorée
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDarkMode ? NewAppTheme.darkBlue.withOpacity(0.7) : NewAppTheme.lightGrey,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Rechercher un ticket par ID ou titre...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: NewAppTheme.primaryColor,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          hintStyle: TextStyle(
                            color: isDarkMode
                                ? NewAppTheme.white.withOpacity(0.5)
                                : NewAppTheme.darkGrey.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                        style: TextStyle(
                          color: isDarkMode ? NewAppTheme.white : NewAppTheme.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                    
                    const SizedBox(height: 16),
                    
                    // Ligne avec filtres et tri
                    Row(
                      children: [
                        // Filtres
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _filters.length,
                              itemBuilder: (context, index) {
                                final filter = _filters[index];
                                final isSelected = _selectedFilter == filter;
                                
                                return GestureDetector(
                                  onTap: () => _onFilterChanged(filter),
                                  child: Container(
                                    margin: EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? NewAppTheme.primaryColor
                                          : isDarkMode
                                              ? NewAppTheme.darkBlue
                                              : NewAppTheme.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? NewAppTheme.primaryColor
                                            : isDarkMode
                                                ? NewAppTheme.white.withOpacity(0.2)
                                                : NewAppTheme.darkGrey.withOpacity(0.2),
                                      ),
                                      boxShadow: isSelected ? [
                                        BoxShadow(
                                          color: NewAppTheme.primaryColor.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ] : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isSelected)
                                          Padding(
                                            padding: const EdgeInsets.only(right: 6),
                                            child: Icon(
                                              Icons.check_circle,
                                              size: 14,
                                              color: NewAppTheme.white,
                                            ),
                                          ),
                                        Text(
                                          filter,
                                          style: TextStyle(
                                            color: isSelected
                                                ? NewAppTheme.white
                                                : isDarkMode
                                                    ? NewAppTheme.white
                                                    : NewAppTheme.darkGrey,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ).animate().fadeIn(duration: 400.ms, delay: 200.ms + (index * 50).ms);
                              },
                            ),
                          ),
                        ),
                        
                        // Tri
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDarkMode
                                  ? NewAppTheme.white.withOpacity(0.2)
                                  : NewAppTheme.darkGrey.withOpacity(0.2),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedSort,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              isDense: true,
                              items: _sortOptions.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDarkMode
                                          ? NewAppTheme.white
                                          : NewAppTheme.darkGrey,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: _onSortChanged,
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Liste des tickets
              Expanded(
                child: _filteredTickets.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: isDarkMode
                                  ? NewAppTheme.white.withOpacity(0.5)
                                  : NewAppTheme.darkGrey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucun ticket trouvé',
                              style: TextStyle(
                                fontSize: 18,
                                color: isDarkMode
                                    ? NewAppTheme.white.withOpacity(0.7)
                                    : NewAppTheme.darkGrey.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: _filteredTickets.length,
                        itemBuilder: (context, index) {
                          final ticket = _filteredTickets[index];
                          return _buildTicketCard(ticket, isDarkMode, index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
      // Le FloatingActionButton devrait être géré par le MainScreenWrapper
      // La barre de navigation est maintenant gérée par le MainScreenWrapper
    );
  }

  Widget _buildTicketCard(TicketModel ticket, bool isDarkMode, int index) {
    // Couleur de bordure basée sur la priorité
    Color borderColor;
    switch (ticket.priority) {
      case TicketPriority.critical:
        borderColor = Colors.purple;
        break;
      case TicketPriority.high:
        borderColor = Colors.red;
        break;
      case TicketPriority.medium:
        borderColor = Colors.amber;
        break;
      case TicketPriority.low:
        borderColor = Colors.blue;
        break;
    }
    
    return GestureDetector(
      onTap: () {
        // Naviguer vers le détail du ticket
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            // En-tête avec ID et statut
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ticket.id,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode
                          ? NewAppTheme.white.withOpacity(0.7)
                          : NewAppTheme.darkGrey.withOpacity(0.7),
                    ),
                  ),
                  Row(
                    children: [
                      // Priorité
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: ticket.priority.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          ticket.priority.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ticket.priority.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Statut
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: ticket.status.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          ticket.status.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ticket.status.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Contenu du ticket
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Text(
                    ticket.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Description
                  Text(
                    ticket.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode
                          ? NewAppTheme.white.withOpacity(0.7)
                          : NewAppTheme.darkGrey.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Ligne de séparation
                  Divider(
                    color: isDarkMode
                        ? NewAppTheme.white.withOpacity(0.1)
                        : NewAppTheme.darkGrey.withOpacity(0.1),
                  ),
                  const SizedBox(height: 8),
                  
                  // Informations supplémentaires
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Catégorie
                      _buildInfoChip(
                        Icons.category_outlined,
                        ticket.category,
                        isDarkMode,
                      ),
                      
                      // Assigné à
                      _buildInfoChip(
                        Icons.person_outline,
                        ticket.assignedTo ?? 'Non assigné',
                        isDarkMode,
                      ),
                      
                      // Date de mise à jour
                      _buildInfoChip(
                        Icons.access_time,
                        _formatDate(ticket.updatedAt),
                        isDarkMode,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Commentaires et pièces jointes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (ticket.commentsCount > 0)
                        _buildCountChip(
                          Icons.comment_outlined,
                          ticket.commentsCount.toString(),
                          isDarkMode,
                        ),
                      if (ticket.commentsCount > 0)
                        const SizedBox(width: 12),
                      if (ticket.attachmentsCount > 0)
                        _buildCountChip(
                          Icons.attach_file,
                          ticket.attachmentsCount.toString(),
                          isDarkMode,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms, delay: 300.ms + (index * 100).ms).slideY(begin: 0.2, end: 0),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, bool isDarkMode) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
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

  Widget _buildCountChip(IconData icon, String count, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: NewAppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: NewAppTheme.primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: NewAppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  // Méthode pour formater la date
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Il y a ${difference.inMinutes} min';
      }
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
