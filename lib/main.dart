import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

// Core imports
import 'core/theme/new_app_theme.dart';
import 'core/navigation/app_router.dart';

// Features imports
import 'features/auth/controllers/auth_controller.dart';
import 'features/profile/controllers/profile_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser les contrôleurs GetX
  Get.put(ProfileController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.getRouter(context);
          
          return MaterialApp.router(
            title: 'Bougouah Admin',
            debugShowCheckedModeBanner: false,
            theme: NewAppTheme.lightTheme,
            darkTheme: NewAppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: router,
            builder: (context, child) {
              // Intégrer GetX dans le builder pour conserver ses fonctionnalités
              return GetBuilder<ProfileController>(
                builder: (_) => child!,
              );
            },
          );
        },
      ),
    );
  }
}


