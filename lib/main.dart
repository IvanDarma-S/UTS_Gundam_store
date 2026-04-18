import 'package:apps_marketplace_integration_backend/core/routes/app_router.dart';
import 'package:apps_marketplace_integration_backend/core/services/secure_storage.dart';
import 'package:apps_marketplace_integration_backend/core/theme/app_theme.dart';
import 'package:apps_marketplace_integration_backend/features/auth/presentation/providers/auth_provider.dart';
import 'package:apps_marketplace_integration_backend/features/dashboard/presentation/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Load auth provider immediately untuk cek status login
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Load product provider hanya saat dibutuhkan (lazy)
        ChangeNotifierProvider(create: (_) => ProductProvider(), lazy: true),
      ],
      child: MaterialApp(
        title: 'Marketplace Integration',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRouter.splash,
        routes: AppRouter.routes,
      ),
    );
  }
}

// SplashPage: cek token tersimpan, redirect otomatis
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final token = await SecureStorageService.getToken();
      if (!mounted) return;

      // Redirect berdasarkan token
      final route = token != null ? AppRouter.dashboard : AppRouter.login;
      Navigator.pushReplacementNamed(context, route);
    } catch (e) {
      // Jika error, redirect ke login
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/google_logo.png',
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
