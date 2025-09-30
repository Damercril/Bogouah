import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../controllers/auth_controller.dart';
import '../../../core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Image.asset(
                    'assets/logos/logo.png',
                    height: 100,
                    width: 100,
                  ).animate()
                    .fadeIn(duration: 600.ms)
                    .scale(duration: 600.ms),
                  
                  const SizedBox(height: 32),
                  
                  // Titre
                  Text(
                    'Connexion',
                    style: theme.textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ).animate()
                    .fadeIn(delay: 200.ms, duration: 500.ms)
                    .slideY(begin: 0.2, end: 0, delay: 200.ms, duration: 500.ms),
                  
                  const SizedBox(height: 8),
                  
                  // Sous-titre
                  Text(
                    'Bienvenue sur Bougouah Admin',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ).animate()
                    .fadeIn(delay: 400.ms, duration: 500.ms),
                  
                  const SizedBox(height: 32),
                  
                  // Champ email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Entrez votre adresse email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null;
                    },
                  ).animate()
                    .fadeIn(delay: 600.ms, duration: 500.ms)
                    .slideY(begin: 0.2, end: 0, delay: 600.ms, duration: 500.ms),
                  
                  const SizedBox(height: 16),
                  
                  // Champ mot de passe
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      hintText: 'Entrez votre mot de passe',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      if (value.length < 6) {
                        return 'Le mot de passe doit contenir au moins 6 caractères';
                      }
                      return null;
                    },
                  ).animate()
                    .fadeIn(delay: 800.ms, duration: 500.ms)
                    .slideY(begin: 0.2, end: 0, delay: 800.ms, duration: 500.ms),
                  
                  const SizedBox(height: 16),
                  
                  // Options de connexion
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Option "Se souvenir de moi"
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          Text(
                            'Se souvenir de moi',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      
                      // Mot de passe oublié
                      TextButton(
                        onPressed: () {
                          _showForgotPasswordDialog();
                        },
                        child: const Text('Mot de passe oublié ?'),
                      ),
                    ],
                  ).animate()
                    .fadeIn(delay: 1000.ms, duration: 500.ms),
                  
                  const SizedBox(height: 24),
                  
                  // Bouton de connexion
                  Consumer<AuthController>(
                    builder: (context, authController, _) {
                      return ElevatedButton(
                        onPressed: authController.isLoading
                            ? null
                            : () => _handleLogin(authController),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: authController.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Se connecter'),
                      );
                    },
                  ).animate()
                    .fadeIn(delay: 1200.ms, duration: 500.ms)
                    .slideY(begin: 0.2, end: 0, delay: 1200.ms, duration: 500.ms),
                  
                  const SizedBox(height: 16),
                  
                  // Lien d'inscription
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Vous n\'avez pas de compte ?',
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          // Naviguer vers l'écran d'inscription
                          // context.push('/register');
                          _showRegisterDialog();
                        },
                        child: const Text('S\'inscrire'),
                      ),
                    ],
                  ).animate()
                    .fadeIn(delay: 1400.ms, duration: 500.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin(AuthController authController) async {
    if (_formKey.currentState!.validate()) {
      final success = await authController.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      
      if (success && mounted) {
        context.go('/home');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authController.error ?? 'Une erreur s\'est produite'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réinitialiser le mot de passe'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Entrez votre adresse email',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Veuillez entrer un email valide';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          Consumer<AuthController>(
            builder: (context, authController, _) {
              return ElevatedButton(
                onPressed: authController.isLoading
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          final success = await authController.resetPassword(
                            emailController.text.trim(),
                          );
                          
                          if (success && context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Un email de réinitialisation a été envoyé à votre adresse email',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  authController.error ?? 'Une erreur s\'est produite',
                                ),
                                backgroundColor: Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                        }
                      },
                child: authController.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Envoyer'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showRegisterDialog() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isPasswordVisible = false;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Créer un compte'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom complet',
                        hintText: 'Entrez votre nom',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre nom';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Entrez votre adresse email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Veuillez entrer un email valide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: 'Créez un mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un mot de passe';
                        }
                        if (value.length < 6) {
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              Consumer<AuthController>(
                builder: (context, authController, _) {
                  return ElevatedButton(
                    onPressed: authController.isLoading
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              final success = await authController.signUpWithEmailAndPassword(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                nameController.text.trim(),
                              );
                              
                              if (success && context.mounted) {
                                Navigator.pop(context);
                                context.go('/home');
                              } else if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      authController.error ?? 'Une erreur s\'est produite',
                                    ),
                                    backgroundColor: Theme.of(context).colorScheme.error,
                                  ),
                                );
                              }
                            }
                          },
                    child: authController.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('S\'inscrire'),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
