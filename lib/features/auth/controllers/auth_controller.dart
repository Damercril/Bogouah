import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthController with ChangeNotifier {
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _userModel != null;
  
  // Constructeur
  AuthController() {
    _checkLoginStatus();
  }
  
  // Vérifier si l'utilisateur est déjà connecté
  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    
    if (isLoggedIn) {
      // Créer un utilisateur fictif pour la maquette
      _userModel = UserModel(
        uid: 'mock-user-id',
        email: 'user@example.com',
        displayName: 'Utilisateur Test',
        role: 'admin',
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // Connexion avec email et mot de passe
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      // Simuler un délai de connexion
      await Future.delayed(const Duration(seconds: 1));
      
      // Vérifier les identifiants (pour la maquette, accepter n'importe quels identifiants)
      if (email.isNotEmpty && password.isNotEmpty) {
        // Déterminer le rôle selon l'email
        String role = 'admin';
        String displayName = email.split('@')[0];
        
        if (email.contains('operateur')) {
          role = 'operator';
          displayName = 'Opérateur';
        } else if (email.contains('admin')) {
          role = 'admin';
          displayName = 'Administrateur';
        }
        
        _userModel = UserModel(
          uid: 'mock-user-id-${role}',
          email: email,
          displayName: displayName,
          role: role,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );
        
        // Sauvegarder l'état de connexion et le rôle
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('user_role', role);
        await prefs.setString('user_email', email);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Email ou mot de passe invalide');
      }
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Inscription avec email et mot de passe
  Future<bool> signUpWithEmailAndPassword(String email, String password, String displayName) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      // Simuler un délai d'inscription
      await Future.delayed(const Duration(seconds: 1));
      
      // Pour la maquette, accepter n'importe quelle inscription
      if (email.isNotEmpty && password.isNotEmpty && displayName.isNotEmpty) {
        _userModel = UserModel(
          uid: 'mock-user-id',
          email: email,
          displayName: displayName,
          role: 'admin',
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );
        
        // Sauvegarder l'état de connexion
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Veuillez remplir tous les champs');
      }
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Déconnexion
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Simuler un délai de déconnexion
      await Future.delayed(const Duration(milliseconds: 500));
      
      _userModel = null;
      
      // Mettre à jour l'état de connexion
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Erreur lors de la déconnexion: $e';
      notifyListeners();
    }
  }
  
  // Réinitialisation du mot de passe
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      // Simuler un délai de réinitialisation
      await Future.delayed(const Duration(seconds: 1));
      
      // Pour la maquette, accepter n'importe quelle adresse email
      if (email.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Veuillez entrer une adresse email');
      }
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Effacer les erreurs
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  // Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }
}
