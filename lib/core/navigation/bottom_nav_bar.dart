import 'package:flutter/material.dart';
import '../theme/new_app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 90, // Increased height to fix overflow
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode 
              ? [
                  NewAppTheme.darkBlue,
                  Color(0xFF1A2B4D),
                  Color(0xFF162544),
                ] 
              : [
                  NewAppTheme.white,
                  Color(0xFFF8F9FD),
                  Color(0xFFF0F4FA),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, -3),
            spreadRadius: 1,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: NewAppTheme.primaryColor,
          unselectedItemColor: isDarkMode
              ? NewAppTheme.white.withOpacity(0.5)
              : NewAppTheme.darkGrey.withOpacity(0.7),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10, // Reduced font size
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 9, // Reduced font size
          ),
          selectedFontSize: 10, // Explicitly set font size
          unselectedFontSize: 9, // Explicitly set font size
          showUnselectedLabels: true,
          enableFeedback: true,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          items: [
            _buildNavItem(
              context: context,
              icon: 'assets/icons/home.svg',
              activeIcon: 'assets/icons/home_filled.svg',
              label: 'Accueil',
              index: 0,
            ),
            _buildNavItem(
              context: context,
              icon: 'assets/icons/operators.svg',
              activeIcon: 'assets/icons/operators_filled.svg',
              label: 'Opérateurs',
              index: 1,
            ),
            _buildNavItem(
              context: context,
              icon: 'assets/icons/dashboard.svg',
              activeIcon: 'assets/icons/dashboard_filled.svg',
              label: 'Dashboard',
              index: 2,
            ),
            _buildNavItem(
              context: context,
              icon: 'assets/icons/tickets.svg',
              activeIcon: 'assets/icons/tickets_filled.svg',
              label: 'Tickets',
              index: 3,
            ),
            _buildNavItem(
              context: context,
              icon: 'assets/icons/profile.svg',
              activeIcon: 'assets/icons/profile_filled.svg',
              label: 'Profil',
              index: 4,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required BuildContext context,
    required String icon,
    required String activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Conteneur pour l'icône avec animation et indicateur de sélection
    Widget buildIconContainer(Widget iconWidget) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    NewAppTheme.primaryColor.withOpacity(0.2),
                    NewAppTheme.primaryColor.withOpacity(0.1),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: NewAppTheme.primaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            iconWidget,
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      NewAppTheme.primaryColor.withOpacity(0.7),
                      NewAppTheme.primaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
          ],
        ),
      );
    }
    
    // Use fallback icons directly to avoid SVG loading errors
    Widget iconWidget;
    // Skip SVG loading attempt since we're having issues with the assets
    // and use fallback icons directly
    IconData fallbackIcon;
    switch (index) {
      case 0:
        fallbackIcon = isSelected ? Icons.home : Icons.home_outlined;
        break;
      case 1:
        fallbackIcon = isSelected ? Icons.people : Icons.people_outline;
        break;
      case 2:
        fallbackIcon = isSelected ? Icons.dashboard : Icons.dashboard_outlined;
        break;
      case 3:
        fallbackIcon = isSelected ? Icons.confirmation_number : Icons.confirmation_number_outlined;
        break;
      case 4:
        fallbackIcon = isSelected ? Icons.person : Icons.person_outline;
        break;
      default:
        fallbackIcon = Icons.circle;
    }
    iconWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.all(isSelected ? 2 : 0),
      child: Icon(
        fallbackIcon,
        size: isSelected ? 20 : 18, // Reduced icon size
        color: isSelected
            ? NewAppTheme.primaryColor
            : isDarkMode
                ? NewAppTheme.white.withOpacity(0.6)
                : NewAppTheme.darkGrey.withOpacity(0.7),
      ),
    );

    return BottomNavigationBarItem(
      icon: buildIconContainer(iconWidget),
      label: label,
      backgroundColor: Colors.transparent,
    );
  }
}
