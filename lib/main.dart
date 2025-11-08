import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/premium_purchase_screen.dart';
import 'services/sample_data_service.dart';
import 'providers/in_app_purchase_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive storage
  await StorageService.init();
  await SampleDataService.seedIfEmpty();
  
  runApp(const ShortNotesApp());
}

class ShortNotesApp extends StatelessWidget {
  const ShortNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Short Notes Trainer',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      navigatorKey: InAppPurchaseProvider.navigatorKey,
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/main': (context) => const MainNavigationScreen(),
        '/premium': (context) => const PremiumPurchaseScreen(),
      },
    );
  }
}

