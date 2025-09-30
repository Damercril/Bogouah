import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bougouah/main.dart';
import 'package:bougouah/features/auth/controllers/auth_controller.dart';

void main() {
  testWidgets('App initializes correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts with the login screen when not authenticated
    expect(find.text('Connexion'), findsOneWidget);
  });

  testWidgets('Login flow works correctly', (WidgetTester tester) async {
    // Build our app with a test wrapper that provides AuthController
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthController()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify we're on the login screen
    expect(find.text('Connexion'), findsOneWidget);

    // Enter email and password
    await tester.enterText(
      find.byType(TextField).first, 
      'test@example.com'
    );
    await tester.enterText(
      find.byType(TextField).at(1), 
      'password123'
    );

    // Tap the login button
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    // After successful login, we should see the home screen
    // This might fail if the navigation is not set up correctly
    expect(find.text('Tableau de bord'), findsOneWidget);
  });

  testWidgets('Navigation works correctly', (WidgetTester tester) async {
    // Create a mock AuthController that's already authenticated
    final authController = AuthController();
    authController.signInWithEmailAndPassword('test@example.com', 'password123');

    // Build our app with the authenticated controller
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authController),
        ],
        child: const MyApp(),
      ),
    );
    
    await tester.pumpAndSettle();

    // We should be on the home screen
    expect(find.text('Tableau de bord'), findsOneWidget);

    // Navigate to Dashboard
    await tester.tap(find.byIcon(Icons.dashboard).first);
    await tester.pumpAndSettle();

    // Check if we're on the Dashboard screen
    expect(find.text('Dashboard'), findsOneWidget);

    // Navigate to Operators
    await tester.tap(find.byIcon(Icons.people).first);
    await tester.pumpAndSettle();

    // Check if we're on the Operators screen
    expect(find.text('Opérateurs'), findsOneWidget);

    // Navigate to Tickets
    await tester.tap(find.byIcon(Icons.confirmation_number).first);
    await tester.pumpAndSettle();

    // Check if we're on the Tickets screen
    expect(find.text('Tickets'), findsOneWidget);
  });
}
