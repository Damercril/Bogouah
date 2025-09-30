import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/responsive_helper.dart';

/// Layout principal pour la version web avec navigation latérale
class WebLayout extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const WebLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  bool _isDrawerExpanded = true;

  @override
  Widget build(BuildContext context) {
    // Sur mobile, utiliser le layout standard sans sidebar
    if (ResponsiveHelper.isMobile(context)) {
      return widget.child;
    }

    return Scaffold(
      body: Row(
        children: [
          // Sidebar de navigation
          _buildSidebar(context),
          
          // Contenu principal
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: Container(
                    color: Colors.grey[50],
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: ResponsiveHelper.getMaxContentWidth(context),
                        ),
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final theme = Theme.of(context);
    final width = _isDrawerExpanded ? 260.0 : 80.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo et titre
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.business,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                if (_isDrawerExpanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'BOUGOUAH',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.home_rounded,
                  label: 'Accueil',
                  route: '/',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard_rounded,
                  label: 'Tableau de bord',
                  route: '/dashboard',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.people_rounded,
                  label: 'Opérateurs',
                  route: '/operators',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.confirmation_number_rounded,
                  label: 'Tickets',
                  route: '/tickets',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.people_alt_rounded,
                  label: 'Houbago',
                  route: '/houbago',
                ),
                const Divider(height: 32, indent: 16, endIndent: 16),
                _buildMenuItem(
                  context,
                  icon: Icons.person_rounded,
                  label: 'Profil',
                  route: '/profile',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.support_agent_rounded,
                  label: 'Support',
                  route: '/support',
                ),
              ],
            ),
          ),

          // Toggle button
          const Divider(height: 1),
          InkWell(
            onTap: () {
              setState(() {
                _isDrawerExpanded = !_isDrawerExpanded;
              });
            },
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: _isDrawerExpanded
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  if (_isDrawerExpanded)
                    Text(
                      'Réduire',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  Icon(
                    _isDrawerExpanded
                        ? Icons.chevron_left_rounded
                        : Icons.chevron_right_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    final theme = Theme.of(context);
    final isSelected = widget.currentRoute.startsWith(route);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go(route),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                  size: 24,
                ),
                if (_isDrawerExpanded) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getHorizontalPadding(context),
      ),
      child: Row(
        children: [
          // Titre de la page
          Expanded(
            child: Text(
              _getPageTitle(widget.currentRoute),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Actions
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
            tooltip: 'Paramètres',
          ),
          const SizedBox(width: 16),
          
          // Avatar utilisateur
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primary,
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle(String route) {
    if (route == '/') return 'Accueil';
    if (route.startsWith('/dashboard')) return 'Tableau de bord';
    if (route.startsWith('/operators')) return 'Opérateurs';
    if (route.startsWith('/tickets')) return 'Tickets';
    if (route.startsWith('/houbago')) return 'Houbago';
    if (route.startsWith('/profile')) return 'Profil';
    if (route.startsWith('/support')) return 'Support';
    return 'Bougouah Admin';
  }
}
