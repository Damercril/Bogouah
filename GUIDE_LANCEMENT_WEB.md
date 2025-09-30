# 🚀 Guide de Lancement - Version Web Bougouah

## ✅ Vérification des prérequis

Avant de lancer la version web, assurez-vous que :
- Flutter SDK est installé (version 3.9.0+)
- Chrome ou Edge est installé
- Vous êtes dans le dossier du projet

## 📦 Installation des dépendances

```bash
flutter pub get
```

## 🌐 Lancement en mode développement

### Option 1 : Lancer avec Chrome
```bash
flutter run -d chrome
```

### Option 2 : Lancer avec Edge
```bash
flutter run -d edge
```

### Option 3 : Lancer avec un serveur web local
```bash
flutter run -d web-server --web-port=8080
```
Puis ouvrir : http://localhost:8080

## 🔨 Build de production

### Build standard
```bash
flutter build web --release
```

### Build avec analyse de taille
```bash
flutter build web --release --analyze-size
```

### Build avec renderer spécifique
```bash
# HTML renderer (plus léger, meilleure compatibilité)
flutter build web --release --web-renderer html

# CanvasKit renderer (meilleure performance graphique)
flutter build web --release --web-renderer canvaskit

# Auto (par défaut, choisit automatiquement)
flutter build web --release --web-renderer auto
```

## 🎯 Utilisation du script PowerShell

Un script PowerShell est fourni pour simplifier le build :

```powershell
.\build_web.ps1
```

Ce script :
- ✅ Vérifie Flutter
- 🧹 Nettoie les builds précédents
- 📥 Installe les dépendances
- 🔨 Build la version web
- 🌐 Propose de lancer un serveur local

## 📂 Structure des fichiers web

Après le build, les fichiers seront dans `build/web/` :
```
build/web/
├── index.html          # Page principale
├── main.dart.js        # Code compilé
├── flutter.js          # Runtime Flutter
├── manifest.json       # Manifeste PWA
├── favicon.png         # Icône
├── icons/              # Icônes PWA
└── assets/             # Assets de l'app
```

## 🌍 Déploiement

### Firebase Hosting
```bash
# Installation de Firebase CLI
npm install -g firebase-tools

# Connexion
firebase login

# Initialisation (si pas déjà fait)
firebase init hosting

# Déploiement
firebase deploy --only hosting
```

### Netlify
1. Connecter votre repo GitHub
2. Configuration :
   - Build command: `flutter build web --release`
   - Publish directory: `build/web`
3. Déployer

### GitHub Pages
```bash
# Build
flutter build web --release --base-href /nom-du-repo/

# Copier dans la branche gh-pages
git checkout -b gh-pages
cp -r build/web/* .
git add .
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages
```

### Serveur Apache/Nginx

#### Apache (.htaccess)
```apache
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /
  RewriteRule ^index\.html$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule . /index.html [L]
</IfModule>
```

#### Nginx
```nginx
location / {
  try_files $uri $uri/ /index.html;
}
```

## 🎨 Fonctionnalités Web Implémentées

### ✨ Layout Responsive
- **Mobile** (< 600px) : Bottom navigation bar
- **Tablette** (600-1024px) : Sidebar + layout adapté
- **Desktop** (> 1024px) : Sidebar étendue + layout optimisé

### 🎯 Composants Web
- `WebLayout` : Layout avec sidebar pour desktop/tablette
- `ResponsiveHelper` : Utilitaires de détection de taille d'écran
- `ResponsiveGrid` : Grilles adaptatives
- `ResponsiveCard` : Cartes avec padding adapté
- `ResponsiveTwoColumns` : Layout deux colonnes responsive

### 🔧 Optimisations
- Écran de chargement personnalisé
- PWA support (installable)
- Métadonnées SEO
- Cache des assets
- Transitions fluides

## 🐛 Debugging

### Activer les DevTools
```bash
flutter run -d chrome --dart-define=FLUTTER_WEB_USE_SKIA=true
```

### Voir les logs
Ouvrez la console du navigateur (F12) → Console

### Mode debug avec hot reload
```bash
flutter run -d chrome --debug
```

## 📊 Performance

### Analyser la taille du bundle
```bash
flutter build web --analyze-size
```

### Optimiser les images
- Utilisez des formats WebP
- Compressez les images
- Utilisez des images responsive

### Lazy loading
Les routes sont déjà configurées pour le lazy loading automatique.

## ⚙️ Configuration

### Modifier le port de développement
```bash
flutter run -d web-server --web-port=3000
```

### Modifier le titre de l'application
Éditez `web/index.html` ligne 23

### Modifier les couleurs PWA
Éditez `web/manifest.json`

## 🔐 Sécurité

### Headers de sécurité recommandés
Les configurations Firebase et Netlify incluent déjà :
- X-Content-Type-Options: nosniff
- X-Frame-Options: DENY
- X-XSS-Protection: 1; mode=block

### HTTPS
Toujours utiliser HTTPS en production !

## 📱 Test sur différents appareils

### Responsive Design Mode
1. Ouvrir DevTools (F12)
2. Cliquer sur l'icône mobile/tablette
3. Tester différentes tailles d'écran

### Test sur appareil réel
```bash
# Trouver votre IP locale
ipconfig

# Lancer avec votre IP
flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080

# Accéder depuis mobile : http://VOTRE_IP:8080
```

## 🆘 Résolution de problèmes

### Erreur "Chrome not found"
Installez Chrome ou utilisez Edge :
```bash
flutter run -d edge
```

### Erreur de build
```bash
flutter clean
flutter pub get
flutter build web --release
```

### Assets non chargés
Vérifiez que tous les assets sont déclarés dans `pubspec.yaml`

### Problème de CORS
Configurez les headers CORS sur votre serveur backend

## 📚 Ressources

- [Documentation Flutter Web](https://flutter.dev/web)
- [Guide PWA](https://web.dev/progressive-web-apps/)
- [Optimisation Performance](https://flutter.dev/docs/perf/web-performance)

---

**Besoin d'aide ?** Consultez le fichier `WEB_README.md` pour plus de détails.
