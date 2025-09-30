# 🏢 Bougouah Admin

Application d'administration Bougouah pour la gestion et le suivi des activités.

## 📱 Plateformes Supportées

- ✅ **Android** - Application mobile native
- ✅ **iOS** - Application mobile native
- ✅ **Web** - Application web responsive (Desktop, Tablette, Mobile)
- ✅ **Windows** - Application desktop
- ✅ **macOS** - Application desktop
- ✅ **Linux** - Application desktop

## ✨ Fonctionnalités

### 🎯 Principales
- **Tableau de bord** - Vue d'ensemble des statistiques et activités
- **Gestion des opérateurs** - Suivi et administration des opérateurs
- **Gestion des tickets** - Création et suivi des tickets
- **Profil utilisateur** - Gestion du compte et paramètres
- **Support** - Assistance et chat en direct

### 🌐 Version Web
- **Layout responsive** adapté à toutes les tailles d'écran
- **Navigation latérale** (sidebar) pour desktop et tablette
- **Progressive Web App** (PWA) - Installable sur desktop
- **Optimisations performance** - Chargement rapide et fluide

## 🚀 Démarrage Rapide

### Prérequis
- Flutter SDK 3.9.0 ou supérieur
- Dart SDK
- Android Studio / Xcode (pour mobile)
- Chrome / Edge (pour web)

### Installation

```bash
# Cloner le repository
git clone https://github.com/votre-repo/bougouah.git
cd bougouah

# Installer les dépendances
flutter pub get
```

### Lancement

#### Mobile (Android/iOS)
```bash
# Android
flutter run

# iOS (macOS uniquement)
flutter run -d ios
```

#### Web
```bash
# Lancer en mode développement
flutter run -d chrome

# Ou avec Edge
flutter run -d edge
```

#### Desktop
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## 🌐 Version Web - Guide Complet

Pour la version web, consultez les guides détaillés :

- 📖 **[QUICK_START_WEB.md](QUICK_START_WEB.md)** - Démarrage rapide (3 étapes)
- 📚 **[WEB_README.md](WEB_README.md)** - Documentation technique complète
- 🚀 **[GUIDE_LANCEMENT_WEB.md](GUIDE_LANCEMENT_WEB.md)** - Guide de lancement détaillé
- 🏗️ **[ARCHITECTURE_WEB.md](ARCHITECTURE_WEB.md)** - Architecture et patterns
- 📝 **[CHANGELOG_WEB.md](CHANGELOG_WEB.md)** - Historique des changements
- 📋 **[RESUME_VERSION_WEB.md](RESUME_VERSION_WEB.md)** - Résumé de la version web

### Lancement rapide Web
```bash
# 1. Installer les dépendances
flutter pub get

# 2. Lancer en mode web
flutter run -d chrome

# 3. Build pour production
flutter build web --release
```

### Script PowerShell (Windows)
```powershell
.\build_web.ps1
```

## 🏗️ Structure du Projet

```
lib/
├── core/
│   ├── layouts/          # Layouts (web, mobile)
│   ├── navigation/       # Configuration de navigation
│   ├── theme/            # Thème et styles
│   ├── utils/            # Utilitaires (responsive, etc.)
│   └── widgets/          # Widgets réutilisables
├── features/
│   ├── auth/             # Authentification
│   ├── dashboard/        # Tableau de bord
│   ├── home/             # Écran d'accueil
│   ├── operators/        # Gestion opérateurs
│   ├── profile/          # Profil utilisateur
│   └── tickets/          # Gestion tickets
└── main.dart             # Point d'entrée
```

## 🎨 Design

- **Material Design 3** - Interface moderne et cohérente
- **Thème clair/sombre** - Support automatique du mode système
- **Animations fluides** - Transitions et micro-interactions
- **Responsive** - Adapté à toutes les tailles d'écran

## 📦 Technologies

### Framework & Langages
- **Flutter** 3.9.0+ - Framework UI multiplateforme
- **Dart** - Langage de programmation

### Packages Principaux
- **go_router** - Navigation déclarative
- **provider** - Gestion d'état
- **get** - Gestion d'état et utilitaires
- **fl_chart** - Graphiques et visualisations
- **google_fonts** - Typographie
- **flutter_animate** - Animations

### Web
- **PWA Support** - Application web progressive
- **Responsive Design** - Layout adaptatif
- **Firebase Hosting** - Déploiement (optionnel)
- **Netlify** - Déploiement (optionnel)

## 🔧 Build de Production

### Mobile
```bash
# Android (APK)
flutter build apk --release

# Android (App Bundle)
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Web
```bash
# Build standard
flutter build web --release

# Build avec renderer spécifique
flutter build web --release --web-renderer html
flutter build web --release --web-renderer canvaskit
```

### Desktop
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 🚀 Déploiement

### Web
- **Firebase Hosting** - Configuration incluse (`firebase.json`)
- **Netlify** - Configuration incluse (`netlify.toml`)
- **GitHub Pages** - Instructions dans les guides
- **Serveurs classiques** - Apache, Nginx

### Mobile
- **Google Play Store** - Android
- **Apple App Store** - iOS

## 📱 Responsive Design

### Breakpoints
- **Mobile** : < 600px
- **Tablette** : 600px - 1024px
- **Desktop** : > 1024px

### Layouts
- **Mobile** : Bottom navigation bar
- **Tablette** : Sidebar + contenu adapté
- **Desktop** : Sidebar étendue + layout large

## 🧪 Tests

```bash
# Lancer les tests
flutter test

# Tests avec coverage
flutter test --coverage
```

## 📄 Licence

Ce projet est privé et propriétaire.

## 👥 Équipe

Développé par l'équipe Bougouah.

## 📞 Support

Pour toute question ou problème :
- Consultez la documentation dans les fichiers MD
- Contactez l'équipe de développement

---

**Version** : 1.0.0  
**Dernière mise à jour** : 2025-09-30
