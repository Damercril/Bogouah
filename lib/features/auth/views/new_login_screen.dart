import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/new_app_theme.dart';
import '../controllers/auth_controller.dart';

class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({Key? key}) : super(key: key);

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  
  bool _isLogin = true;
  bool _isPasswordVisible = false;
  bool _isResetPassword = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      _isResetPassword = false;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleResetPassword() {
    setState(() {
      _isResetPassword = !_isResetPassword;
    });
    _animationController.reset();
    _animationController.forward();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = Provider.of<AuthController>(context, listen: false);

    if (_isResetPassword) {
      await authController.resetPassword(_emailController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Un email de réinitialisation a été envoyé'),
            backgroundColor: NewAppTheme.accentColor,
          ),
        );
        _toggleResetPassword(); // Revenir à l'écran de connexion
      }
    } else if (_isLogin) {
      await authController.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
    } else {
      await authController.signUpWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final screenSize = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background design
          Positioned(
            top: -screenSize.height * 0.15,
            right: -screenSize.width * 0.2,
            child: Container(
              width: screenSize.width * 0.8,
              height: screenSize.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    NewAppTheme.primaryColor.withOpacity(0.8),
                    NewAppTheme.primaryColor.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -screenSize.height * 0.1,
            left: -screenSize.width * 0.1,
            child: Container(
              width: screenSize.width * 0.6,
              height: screenSize.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    NewAppTheme.secondaryColor.withOpacity(0.7),
                    NewAppTheme.secondaryColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // Logo and title
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: isDarkMode ? NewAppTheme.darkBlue : NewAppTheme.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "B",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: NewAppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "BOUGOUAH",
                            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isResetPassword
                                ? "Réinitialisation du mot de passe"
                                : _isLogin
                                    ? "Connexion à votre compte"
                                    : "Créer un nouveau compte",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 100.ms).slideY(begin: -0.2, end: 0),
                    
                    const SizedBox(height: 40),
                    
                    // Form
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!_isLogin && !_isResetPassword)
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nom complet',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre nom';
                                  }
                                  return null;
                                },
                              ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(begin: 0.2, end: 0),
                            
                            if (!_isLogin && !_isResetPassword)
                              const SizedBox(height: 16),
                            
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Veuillez entrer un email valide';
                                }
                                return null;
                              },
                            ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideX(begin: 0.2, end: 0),
                            
                            if (!_isResetPassword)
                              const SizedBox(height: 16),
                            
                            if (!_isResetPassword)
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Mot de passe',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: _togglePasswordVisibility,
                                  ),
                                ),
                                obscureText: !_isPasswordVisible,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre mot de passe';
                                  }
                                  if (!_isLogin && value.length < 6) {
                                    return 'Le mot de passe doit contenir au moins 6 caractères';
                                  }
                                  return null;
                                },
                              ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideX(begin: 0.2, end: 0),
                            
                            const SizedBox(height: 24),
                            
                            // Submit button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: authController.isLoading ? null : _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: NewAppTheme.primaryColor,
                                  foregroundColor: NewAppTheme.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: authController.isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: NewAppTheme.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        _isResetPassword
                                            ? 'Réinitialiser'
                                            : _isLogin
                                                ? 'Se connecter'
                                                : 'S\'inscrire',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ).animate().fadeIn(duration: 400.ms, delay: 500.ms).slideY(begin: 0.2, end: 0),
                            
                            const SizedBox(height: 16),
                            
                            // Boutons de connexion rapide (pour les tests)
                            if (_isLogin && !_isResetPassword)
                              Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: OutlinedButton.icon(
                                      onPressed: authController.isLoading ? null : () {
                                        _emailController.text = 'admin@bougouah.com';
                                        _passwordController.text = 'admin123';
                                        _submitForm();
                                      },
                                      icon: const Icon(Icons.admin_panel_settings),
                                      label: const Text('Connexion Admin'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: NewAppTheme.secondaryColor,
                                        side: BorderSide(color: NewAppTheme.secondaryColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: OutlinedButton.icon(
                                      onPressed: authController.isLoading ? null : () {
                                        _emailController.text = 'operateur@bougouah.com';
                                        _passwordController.text = 'operateur123';
                                        _submitForm();
                                      },
                                      icon: const Icon(Icons.support_agent),
                                      label: const Text('Connexion Opérateur'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: NewAppTheme.primaryColor,
                                        side: BorderSide(color: NewAppTheme.primaryColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ).animate().fadeIn(duration: 400.ms, delay: 550.ms).slideY(begin: 0.2, end: 0),
                            
                            if (_isLogin && !_isResetPassword)
                              const SizedBox(height: 16),
                            
                            // Toggle auth mode
                            if (!_isResetPassword)
                              TextButton(
                                onPressed: _toggleAuthMode,
                                child: Text(
                                  _isLogin
                                      ? 'Créer un nouveau compte'
                                      : 'Déjà un compte? Se connecter',
                                  style: TextStyle(
                                    color: NewAppTheme.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ).animate().fadeIn(duration: 400.ms, delay: 600.ms),
                            
                            // Reset password
                            if (_isLogin && !_isResetPassword)
                              TextButton(
                                onPressed: _toggleResetPassword,
                                child: Text(
                                  'Mot de passe oublié?',
                                  style: TextStyle(
                                    color: NewAppTheme.secondaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ).animate().fadeIn(duration: 400.ms, delay: 700.ms),
                            
                            // Back to login
                            if (_isResetPassword)
                              TextButton(
                                onPressed: _toggleResetPassword,
                                child: Text(
                                  'Retour à la connexion',
                                  style: TextStyle(
                                    color: NewAppTheme.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ).animate().fadeIn(duration: 400.ms, delay: 600.ms),
                          ],
                        ),
                      ),
                    ),
                    
                    if (authController.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: NewAppTheme.errorColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: NewAppTheme.errorColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authController.error!,
                                  style: const TextStyle(
                                    color: NewAppTheme.errorColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(duration: 300.ms).shake(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
