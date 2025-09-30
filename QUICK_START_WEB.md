# ⚡ Quick Start - Version Web

## 🚀 Lancement rapide (3 étapes)

### 1️⃣ Installer les dépendances
```bash
flutter pub get
```

### 2️⃣ Lancer l'application web
```bash
flutter run -d chrome
```

### 3️⃣ Tester le responsive
- Redimensionnez la fenêtre du navigateur
- Ou utilisez Chrome DevTools (F12) → Mode responsive

---

## 📦 Build pour production

```bash
flutter build web --release
```

Les fichiers seront dans `build/web/`

---

## 🎯 Tester rapidement avec le script

```powershell
.\build_web.ps1
```

Ce script fait tout automatiquement et propose de lancer un serveur local.

---

## 📱 Voir les différents layouts

### Desktop (> 1024px)
- Sidebar de navigation à gauche
- Barre supérieure avec actions
- Contenu large (max 1400px)
- Grilles 4 colonnes

### Tablette (600-1024px)
- Sidebar de navigation à gauche
- Contenu moyen (max 900px)
- Grilles 2 colonnes

### Mobile (< 600px)
- Bottom navigation bar (comme avant)
- Aucun changement

---

## 🔧 Commandes utiles

```bash
# Lancer avec Edge
flutter run -d edge

# Lancer avec serveur web local
flutter run -d web-server --web-port=8080

# Build avec analyse de taille
flutter build web --release --analyze-size

# Nettoyer et rebuild
flutter clean && flutter pub get && flutter build web --release
```

---

## 📚 Documentation complète

- **WEB_README.md** → Documentation technique détaillée
- **GUIDE_LANCEMENT_WEB.md** → Guide complet de lancement
- **CHANGELOG_WEB.md** → Historique des changements
- **RESUME_VERSION_WEB.md** → Résumé de la version web

---

## ✅ Checklist avant déploiement

- [ ] Tester sur Chrome
- [ ] Tester sur Edge/Firefox
- [ ] Tester le responsive (mobile, tablette, desktop)
- [ ] Vérifier que toutes les routes fonctionnent
- [ ] Optimiser les images si nécessaire
- [ ] Build en mode release
- [ ] Tester le build localement
- [ ] Déployer sur la plateforme choisie

---

## 🎉 C'est tout !

La version web est prête à l'emploi. Bon développement ! 🚀
