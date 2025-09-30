# Script PowerShell pour build la version web de Bougouah Admin

Write-Host "🚀 Build de la version web de Bougouah Admin" -ForegroundColor Cyan
Write-Host ""

# Vérifier que Flutter est installé
Write-Host "📦 Vérification de Flutter..." -ForegroundColor Yellow
$flutterVersion = flutter --version 2>&1 | Select-String "Flutter"
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Flutter n'est pas installé ou n'est pas dans le PATH" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Flutter détecté: $flutterVersion" -ForegroundColor Green
Write-Host ""

# Nettoyer les builds précédents
Write-Host "🧹 Nettoyage des builds précédents..." -ForegroundColor Yellow
flutter clean
Write-Host "✅ Nettoyage terminé" -ForegroundColor Green
Write-Host ""

# Récupérer les dépendances
Write-Host "📥 Récupération des dépendances..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur lors de la récupération des dépendances" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Dépendances installées" -ForegroundColor Green
Write-Host ""

# Build de la version web
Write-Host "🔨 Build de la version web en mode release..." -ForegroundColor Yellow
flutter build web --release --web-renderer auto
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur lors du build" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Build terminé avec succès!" -ForegroundColor Green
Write-Host ""

# Afficher les informations
Write-Host "📊 Informations du build:" -ForegroundColor Cyan
Write-Host "  📁 Dossier de sortie: build/web/" -ForegroundColor White
Write-Host "  🌐 Renderer: Auto (HTML/CanvasKit)" -ForegroundColor White
Write-Host "  🎯 Mode: Release" -ForegroundColor White
Write-Host ""

# Proposer de lancer un serveur local
Write-Host "💡 Pour tester localement, vous pouvez:" -ForegroundColor Cyan
Write-Host "  1. Installer dhttpd: dart pub global activate dhttpd" -ForegroundColor White
Write-Host "  2. Lancer le serveur: dhttpd --path=build/web --port=8080" -ForegroundColor White
Write-Host "  3. Ouvrir: http://localhost:8080" -ForegroundColor White
Write-Host ""

$response = Read-Host "Voulez-vous lancer un serveur local maintenant? (O/N)"
if ($response -eq "O" -or $response -eq "o") {
    Write-Host "🌐 Lancement du serveur local..." -ForegroundColor Yellow
    
    # Vérifier si dhttpd est installé
    $dhttpdCheck = dart pub global list 2>&1 | Select-String "dhttpd"
    if (-not $dhttpdCheck) {
        Write-Host "📦 Installation de dhttpd..." -ForegroundColor Yellow
        dart pub global activate dhttpd
    }
    
    Write-Host "✅ Serveur démarré sur http://localhost:8080" -ForegroundColor Green
    Write-Host "   Appuyez sur Ctrl+C pour arrêter le serveur" -ForegroundColor Yellow
    Write-Host ""
    
    dhttpd --path=build/web --port=8080
}

Write-Host ""
Write-Host "✨ Terminé!" -ForegroundColor Green
