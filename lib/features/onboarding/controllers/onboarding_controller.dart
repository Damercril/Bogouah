import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController {
  // Contrôleur de page pour l'onboarding
  final PageController pageController = PageController();
  
  // Méthode pour naviguer à la page suivante
  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  // Méthode pour naviguer à une page spécifique
  void goToPage(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  // Méthode pour marquer l'onboarding comme complété
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
  }
  
  // Méthode pour vérifier si l'onboarding a déjà été complété
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed') ?? false;
  }
  
  // Méthode pour disposer des ressources
  void dispose() {
    pageController.dispose();
  }
}
