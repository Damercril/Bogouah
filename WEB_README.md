# Bougouah Admin - Version Web

## 🌐 Présentation

La version web de Bougouah Admin est une application responsive optimisée pour les navigateurs desktop et tablette. Elle offre une expérience utilisateur améliorée avec une navigation latérale et une interface adaptée aux grands écrans.

## ✨ Fonctionnalités Web

### Layout Responsive
- **Mobile** (< 600px) : Navigation bottom bar
- **Tablette** (600px - 1024px) : Sidebar de navigation avec contenu adapté
- **Desktop** (> 1024px) : Sidebar étendue avec layout optimisé

### Navigation
- Sidebar collapsible pour maximiser l'espace de travail
- Barre supérieure avec notifications et profil utilisateur
- Transitions fluides entre les pages
- Indicateurs visuels de la page active

### Optimisations
- Écran de chargement personnalisé avec animation
- PWA (Progressive Web App) support
- Métadonnées SEO optimisées
- Icônes et manifeste configurés

## 🚀 Lancement de la version web

### Prérequis
- Flutter SDK installé (version 3.9.0 ou supérieure)
- Chrome ou Edge installé pour le développement

### Mode développement

```bash
# Lancer l'application en mode web
flutter run -d chrome

# Ou avec hot reload
flutter run -d web-server --web-port=8080
```

### Build de production

```bash
# Build optimisé pour la production
flutter build web --release

# Build avec base href personnalisé
flutter build web --release --base-href /bougouah/

# Les fichiers seront générés dans le dossier build/web/
```

### Déploiement

#### Option 1 : Serveur local
```bash
# Installer un serveur HTTP simple
dart pub global activate dhttpd

# Lancer le serveur
dhttpd --path=build/web --port=8080
```

#### Option 2 : Firebase Hosting
```bash
firebase init hosting
firebase deploy
```

#### Option 3 : GitHub Pages
1. Copier le contenu de `build/web/` dans votre repo
2. Activer GitHub Pages dans les paramètres
3. Sélectionner la branche et le dossier

#### Option 4 : Netlify/Vercel
1. Connecter votre repo
2. Configurer le build command : `flutter build web`
3. Définir le publish directory : `build/web`

## 📱 Fonctionnalités Responsive

### Composants adaptés
- **ResponsiveHelper** : Utilitaire pour détecter la taille d'écran
- **WebLayout** : Layout spécifique pour web avec sidebar
- **MainScreenWrapper** : Wrapper intelligent qui choisit le bon layout

### Breakpoints
```dart
Mobile:  < 600px
Tablet:  600px - 1024px
Desktop: > 1024px
```

## 🎨 Personnalisation

### Modifier les couleurs du thème
Éditez `lib/core/theme/new_app_theme.dart`

### Modifier le logo de chargement
Éditez `web/index.html` dans la section `#loading`

### Modifier les icônes PWA
Remplacez les fichiers dans `web/icons/`

## 🔧 Configuration

### Manifeste PWA
Le fichier `web/manifest.json` configure l'application en tant que PWA :
- Nom de l'application
- Icônes
- Couleurs du thème
- Mode d'affichage

### Index.html
Le fichier `web/index.html` inclut :
- Métadonnées SEO
- Écran de chargement personnalisé
- Configuration viewport
- Support PWA

## 📊 Performance

### Optimisations appliquées
- Lazy loading des routes
- Code splitting automatique par Flutter
- Compression des assets
- Cache des ressources statiques

### Taille du bundle
```bash
# Analyser la taille du bundle
flutter build web --analyze-size
```

## 🐛 Debugging

### Chrome DevTools
```bash
flutter run -d chrome --web-renderer html
# ou
flutter run -d chrome --web-renderer canvaskit
```

### Logs
Ouvrez la console du navigateur (F12) pour voir les logs

## 📝 Notes importantes

1. **Renderer** : Par défaut, Flutter utilise `auto` qui choisit entre HTML et CanvasKit
2. **CORS** : Si vous utilisez des APIs externes, configurez les headers CORS
3. **Assets** : Tous les assets doivent être déclarés dans `pubspec.yaml`
4. **Routing** : L'application utilise `go_router` pour la navigation

## 🔐 Sécurité

- Pas de données sensibles dans le code client
- Utilisation de HTTPS en production recommandée
- Configuration des headers de sécurité sur le serveur

## 📞 Support

Pour toute question ou problème :
- Consultez la documentation Flutter Web : https://flutter.dev/web
- Vérifiez les issues GitHub du projet
- Contactez l'équipe de développement

---

**Version** : 1.0.0  
**Dernière mise à jour** : 2025-09-30
