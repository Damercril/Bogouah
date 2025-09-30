class OnboardingModel {
  final String title;
  final String description;
  final String imagePath;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

List<OnboardingModel> onboardingData = [
  OnboardingModel(
    title: "Bienvenue sur Bougouah",
    description: "Votre plateforme d'administration complète pour gérer efficacement vos activités",
    imagePath: "assets/images/onboarding1.png",
  ),
  OnboardingModel(
    title: "Tableau de bord complet",
    description: "Accédez à toutes vos données importantes en un coup d'œil avec notre tableau de bord intuitif",
    imagePath: "assets/images/onboarding2.png",
  ),
  OnboardingModel(
    title: "Gestion des opérateurs",
    description: "Suivez les performances de vos opérateurs et optimisez leur efficacité",
    imagePath: "assets/images/onboarding3.png",
  ),
  OnboardingModel(
    title: "Système de tickets",
    description: "Gérez facilement les demandes et suivez leur résolution de manière organisée",
    imagePath: "assets/images/onboarding4.png",
  ),
];
