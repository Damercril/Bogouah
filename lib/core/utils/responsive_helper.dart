import 'package:flutter/material.dart';

/// Helper class pour gérer la responsivité de l'application
class ResponsiveHelper {
  /// Breakpoints pour différentes tailles d'écran
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;
  static const double desktopMinWidth = 1025;

  /// Vérifie si l'écran est mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileMaxWidth;
  }

  /// Vérifie si l'écran est tablette
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileMaxWidth && width < desktopMinWidth;
  }

  /// Vérifie si l'écran est desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopMinWidth;
  }

  /// Vérifie si l'écran est web (tablette ou desktop)
  static bool isWeb(BuildContext context) {
    return isTablet(context) || isDesktop(context);
  }

  /// Retourne la largeur maximale du contenu selon la taille d'écran
  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    } else if (isTablet(context)) {
      return 900;
    } else {
      return 1400;
    }
  }

  /// Retourne le padding horizontal selon la taille d'écran
  static double getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) {
      return 16;
    } else if (isTablet(context)) {
      return 32;
    } else {
      return 48;
    }
  }

  /// Retourne le nombre de colonnes pour une grille selon la taille d'écran
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 3;
    }
  }

  /// Widget responsive qui affiche différents widgets selon la taille d'écran
  static Widget responsive({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  /// Retourne une valeur selon la taille d'écran
  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
