import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../../features/auth/views/new_login_screen.dart';
import '../../features/home/views/new_home_screen.dart';
import '../../features/dashboard/views/new_dashboard_screen.dart';
import '../../features/operators/views/new_operators_screen.dart';
import '../../features/tickets/views/new_tickets_screen.dart';
import '../../features/profile/views/profile_screen.dart';
import '../../features/profile/views/support_screen.dart';
import '../../features/operator/views/operator_main_screen.dart';
import '../../features/houbago/views/houbago_screen.dart';
import '../../features/houbago/views/houbago_bonus_screen.dart';
import 'main_screen_wrapper.dart';

class AppRouter {
  static GoRouter getRouter(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);

    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final isLoggedIn = authController.isAuthenticated;
        final isLoginRoute = state.matchedLocation == '/login';
        final userRole = authController.userModel?.role;

        // Si l'utilisateur n'est pas connecté et n'est pas sur la page de login, rediriger vers login
        if (!isLoggedIn && !isLoginRoute) {
          return '/login';
        }

        // Si l'utilisateur est connecté et est sur la page de login, rediriger selon le rôle
        if (isLoggedIn && isLoginRoute) {
          if (userRole == 'operator') {
            return '/operator';
          }
          return '/';
        }

        // Pas de redirection nécessaire
        return null;
      },
      refreshListenable: authController,
      routes: [
        // Route d'authentification
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const NewLoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),

        // Routes principales avec la barre de navigation en bas
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const MainScreenWrapper(
              currentIndex: 0,
              child: NewHomeScreen(),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const MainScreenWrapper(
              currentIndex: 2,
              child: NewDashboardScreen(),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/operators',
          name: 'operators',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const MainScreenWrapper(
              currentIndex: 1,
              child: NewOperatorsScreen(),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/tickets',
          name: 'tickets',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const MainScreenWrapper(
              currentIndex: 3,
              child: NewTicketsScreen(),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const MainScreenWrapper(
              currentIndex: 4,
              child: ProfileScreen(),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/support',
          name: 'support',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const MainScreenWrapper(
              currentIndex: 5,
              child: SupportScreen(),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/houbago',
          name: 'houbago',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const MainScreenWrapper(
              currentIndex: 6,
              child: HoubagoScreen(),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/bonus',
          name: 'bonus',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const MainScreenWrapper(
              currentIndex: 7,
              child: HoubagoBonusScreen(),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        
        // Route pour l'interface opérateur
        GoRoute(
          path: '/operator',
          name: 'operator',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const OperatorMainScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
      ],
      errorPageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text('Page non trouvée: ${state.matchedLocation}'),
          ),
        ),
      ),
    );
  }
}
